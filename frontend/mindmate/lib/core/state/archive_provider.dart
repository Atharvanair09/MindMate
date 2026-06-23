import 'package:flutter/material.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/repositories/journal_repository.dart';
import '../../domain/models/archive_models.dart' as archive;
import '../../domain/models/journal_entry.dart';
import '../../domain/models/chat_message.dart';
import '../../services/ml/journal_sentiment_analyzer.dart';

class ArchiveProvider extends ChangeNotifier {
  final ChatRepository _chatRepository;
  final JournalRepository _journalRepository;

  List<archive.LocalChat> _chats = [];
  List<JournalEntry> _journals = [];
  
  List<archive.LocalChat> _filteredChats = [];
  List<JournalEntry> _filteredJournals = [];

  bool _isLoading = false;
  String _searchQuery = '';

  ArchiveProvider({
    required ChatRepository chatRepository,
    required JournalRepository journalRepository,
  })  : _chatRepository = chatRepository,
        _journalRepository = journalRepository;

  bool get isLoading => _isLoading;
  List<archive.LocalChat> get chats => _searchQuery.isEmpty ? _chats : _filteredChats;
  List<JournalEntry> get journals => _searchQuery.isEmpty ? _journals : _filteredJournals;

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final allMessages = await _chatRepository.getAll();
      
      // Group messages by conversationId
      final Map<String, List<ChatMessage>> grouped = {};
      for (var msg in allMessages) {
        if (!grouped.containsKey(msg.conversationId)) {
          grouped[msg.conversationId] = [];
        }
        grouped[msg.conversationId]!.add(msg);
      }

      _chats = grouped.entries.map((entry) {
        final msgs = entry.value;
        msgs.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        
        final localMsgs = msgs.map((m) => archive.LocalMessage(
          role: m.role,
          text: m.message,
          timestamp: m.createdAt,
        )).toList();
        
        final firstMsgText = localMsgs.firstWhere((m) => m.role == 'user', orElse: () => localMsgs.first).text;
        final title = firstMsgText.length > 30 ? '${firstMsgText.substring(0, 27)}...' : firstMsgText;
        
        return archive.LocalChat(
          id: entry.key,
          title: title,
          messages: localMsgs,
          createdAt: msgs.first.createdAt,
          updatedAt: msgs.last.createdAt,
        );
      }).toList();
      
      _chats.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

      final allJournals = await _journalRepository.getAll();
      _journals = allJournals.where((j) => !j.isDeleted).toList();
      _journals.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      _applySearch();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void search(String query) {
    _searchQuery = query.toLowerCase();
    _applySearch();
    notifyListeners();
  }

  void _applySearch() {
    if (_searchQuery.isEmpty) {
      _filteredChats = [];
      _filteredJournals = [];
      return;
    }

    _filteredChats = _chats.where((chat) {
      final titleMatch = chat.title.toLowerCase().contains(_searchQuery);
      final messageMatch = chat.messages.any((m) => m.text.toLowerCase().contains(_searchQuery));
      return titleMatch || messageMatch;
    }).toList();

    _filteredJournals = _journals.where((journal) {
      return journal.content.toLowerCase().contains(_searchQuery);
    }).toList();
  }

  Future<void> renameChat(String id, String newTitle) async {
    final chatIndex = _chats.indexWhere((c) => c.id == id);
    if (chatIndex != -1) {
      _chats[chatIndex].title = newTitle;
      _chats[chatIndex].updatedAt = DateTime.now();
      notifyListeners();
    }
  }

  Future<void> deleteChat(String id) async {
    final allMessages = await _chatRepository.getAll();
    final toDelete = allMessages.where((m) => m.conversationId == id).toList();
    for (var m in toDelete) {
      await _chatRepository.delete(m.id);
    }
    _chats.removeWhere((c) => c.id == id);
    _applySearch();
    notifyListeners();
  }

  Future<void> deleteJournal(int id) async {
    final j = await _journalRepository.getById(id);
    if (j != null) {
      j.isDeleted = true;
      await _journalRepository.update(j);
    }
    _journals.removeWhere((j) => j.id == id);
    _applySearch();
    notifyListeners();
  }

  Future<void> clearAllData() async {
    final allChats = await _chatRepository.getAll();
    for (var c in allChats) {
      await _chatRepository.delete(c.id);
    }
    final allJournals = await _journalRepository.getAll();
    for (var j in allJournals) {
      j.isDeleted = true;
      await _journalRepository.update(j);
    }
    _chats.clear();
    _journals.clear();
    _applySearch();
    notifyListeners();
  }

  // Hook for saving new messages from chat
  Future<void> saveMessageToChat(String chatId, String text, bool isUser) async {
    var chat = _chats.firstWhere(
      (c) => c.id == chatId,
      orElse: () {
        final newChat = archive.LocalChat(
          id: chatId,
          title: text.length > 30 ? '${text.substring(0, 27)}...' : text,
          messages: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        _chats.insert(0, newChat);
        return newChat;
      },
    );

    final newMsg = archive.LocalMessage(
      role: isUser ? 'user' : 'ai',
      text: text,
      timestamp: DateTime.now(),
    );
    chat.messages.add(newMsg);
    chat.updatedAt = DateTime.now();
    
    // Sort chats by updatedAt
    _chats.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    final isarMsg = ChatMessage()
      ..conversationId = chatId
      ..message = text
      ..role = isUser ? 'user' : 'ai'
      ..createdAt = DateTime.now();

    // Run on-device sentiment analysis only for user messages.
    // AI responses are excluded to avoid polluting emotional signal.
    if (isUser && text.trim().isNotEmpty) {
      final analysis = JournalSentimentAnalyzer.instance.analyzeText(text);
      isarMsg.sentimentScore = analysis.sentimentScore;
      isarMsg.stressScore = analysis.stressScore;
      // emotionalIntensity: high stress + low energy = most depleted (1.0)
      isarMsg.emotionalIntensity = (1.0 - analysis.energyScore).clamp(0.0, 1.0);
    }

    await _chatRepository.create(isarMsg);

    notifyListeners();
  }
}
