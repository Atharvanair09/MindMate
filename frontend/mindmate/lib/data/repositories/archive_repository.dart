import 'dart:convert';
import 'dart:io';
import '../../domain/models/archive_models.dart';
import '../services/local_storage_service.dart';

class ArchiveRepository {
  final LocalStorageService _storageService;
  
  static const String _chatsDir = 'chats';
  static const String _journalsDir = 'journals';

  ArchiveRepository({LocalStorageService? storageService})
      : _storageService = storageService ?? LocalStorageService();

  // --- Chats ---

  Future<void> saveChat(LocalChat chat) async {
    final jsonString = jsonEncode(chat.toJson());
    await _storageService.saveFile(_chatsDir, '${chat.id}.json', jsonString);
  }

  Future<LocalChat?> getChat(String id) async {
    final jsonString = await _storageService.readFile(_chatsDir, '$id.json');
    if (jsonString == null) return null;
    try {
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      return LocalChat.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  Future<List<LocalChat>> getAllChats() async {
    final files = await _storageService.listFiles(_chatsDir);
    final List<LocalChat> chats = [];
    
    for (var file in files) {
      if (file.path.endsWith('.json')) {
        try {
          final content = await file.readAsString();
          final data = jsonDecode(content) as Map<String, dynamic>;
          chats.add(LocalChat.fromJson(data));
        } catch (e) {
          // Skip invalid files
        }
      }
    }
    
    // Sort by updated descending
    chats.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return chats;
  }

  Future<void> deleteChat(String id) async {
    await _storageService.deleteFile(_chatsDir, '$id.json');
  }

  // --- Journals ---

  Future<void> saveJournal(JournalEntry entry) async {
    final jsonString = jsonEncode(entry.toJson());
    await _storageService.saveFile(_journalsDir, '${entry.id}.json', jsonString);
  }

  Future<JournalEntry?> getJournal(String id) async {
    final jsonString = await _storageService.readFile(_journalsDir, '$id.json');
    if (jsonString == null) return null;
    try {
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      return JournalEntry.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  Future<JournalEntry?> getJournalForDate(DateTime date) async {
    final entries = await getAllJournals();
    try {
      return entries.firstWhere((entry) => 
          entry.journalDate.year == date.year &&
          entry.journalDate.month == date.month &&
          entry.journalDate.day == date.day);
    } catch (e) {
      return null;
    }
  }

  Future<List<JournalEntry>> getAllJournals() async {
    final files = await _storageService.listFiles(_journalsDir);
    final List<JournalEntry> entries = [];
    
    for (var file in files) {
      if (file.path.endsWith('.json')) {
        try {
          final content = await file.readAsString();
          final data = jsonDecode(content) as Map<String, dynamic>;
          entries.add(JournalEntry.fromJson(data));
        } catch (e) {
          // Skip invalid files
        }
      }
    }
    
    // Sort by created descending
    entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return entries;
  }

  Future<void> deleteJournal(String id) async {
    await _storageService.deleteFile(_journalsDir, '$id.json');
  }

  // --- Global ---

  Future<void> clearAllData() async {
    await _storageService.clearDirectory(_chatsDir);
    await _storageService.clearDirectory(_journalsDir);
  }
}
