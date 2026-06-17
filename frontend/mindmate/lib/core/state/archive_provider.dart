import 'package:flutter/material.dart';
import '../../data/repositories/archive_repository.dart';
import '../../domain/models/archive_models.dart';

class ArchiveProvider extends ChangeNotifier {
  final ArchiveRepository _repository;

  List<LocalChat> _chats = [];
  List<JournalEntry> _journals = [];
  
  List<LocalChat> _filteredChats = [];
  List<JournalEntry> _filteredJournals = [];

  bool _isLoading = false;
  String _searchQuery = '';

  ArchiveProvider({ArchiveRepository? repository})
      : _repository = repository ?? ArchiveRepository();

  bool get isLoading => _isLoading;
  List<LocalChat> get chats => _searchQuery.isEmpty ? _chats : _filteredChats;
  List<JournalEntry> get journals => _searchQuery.isEmpty ? _journals : _filteredJournals;

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _chats = await _repository.getAllChats();
      _journals = await _repository.getAllJournals();
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
      await _repository.saveChat(_chats[chatIndex]);
      _applySearch();
      notifyListeners();
    }
  }

  Future<void> deleteChat(String id) async {
    await _repository.deleteChat(id);
    _chats.removeWhere((c) => c.id == id);
    _applySearch();
    notifyListeners();
  }

  Future<void> deleteJournal(String id) async {
    await _repository.deleteJournal(id);
    _journals.removeWhere((j) => j.id == id);
    _applySearch();
    notifyListeners();
  }

  Future<void> clearAllData() async {
    await _repository.clearAllData();
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
        final newChat = LocalChat(
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

    chat.messages.add(LocalMessage(
      role: isUser ? 'user' : 'ai',
      text: text,
      timestamp: DateTime.now(),
    ));
    chat.updatedAt = DateTime.now();
    
    // Sort chats by updatedAt
    _chats.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    await _repository.saveChat(chat);
    notifyListeners();
  }
}
