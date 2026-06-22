import 'package:isar/isar.dart';
import '../../data/database/isar_database.dart';
import '../../domain/models/journal_entry.dart';
import '../../domain/models/chat_message.dart';
import '../../domain/models/mood_log.dart';
import '../../domain/models/session_log.dart';
import '../../domain/models/intervention_log.dart';
import '../../domain/models/embedding_record.dart';
import '../../domain/models/daily_mood_check_in.dart';

class FeatureExtractor {
  Isar get isar => IsarDatabase.instance;

  // Journals
  Future<List<JournalEntry>> getJournalsForDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    return await isar.journalEntrys
        .filter()
        .createdAtBetween(startOfDay, endOfDay, includeLower: true, includeUpper: false)
        .and()
        .isDeletedEqualTo(false)
        .findAll();
  }

  // Chats
  Future<List<ChatMessage>> getChatsForDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    return await isar.chatMessages
        .filter()
        .createdAtBetween(startOfDay, endOfDay, includeLower: true, includeUpper: false)
        .findAll();
  }

  // Moods
  Future<List<MoodLog>> getMoodsForDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    return await isar.moodLogs
        .filter()
        .createdAtBetween(startOfDay, endOfDay, includeLower: true, includeUpper: false)
        .findAll();
  }

  // Daily Mood Check Ins
  Future<DailyMoodCheckIn?> getDailyMoodCheckInForDate(DateTime date) async {
    final todayMidnight = DateTime.utc(date.year, date.month, date.day);
    return await isar.dailyMoodCheckIns
        .where()
        .dateEqualTo(todayMidnight)
        .findFirst();
  }

  // Sessions
  Future<SessionLog?> getSessionLogForDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    return await isar.sessionLogs
        .filter()
        .dateEqualTo(startOfDay)
        .findFirst();
  }

  // Interventions
  Future<List<InterventionLog>> getInterventionsForDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    return await isar.interventionLogs
        .filter()
        .startedAtBetween(startOfDay, endOfDay, includeLower: true, includeUpper: false)
        .findAll();
  }

  // Embeddings
  Future<EmbeddingRecord?> getEmbedding(String sourceType, int sourceId) async {
    return await isar.embeddingRecords
        .filter()
        .sourceTypeEqualTo(sourceType)
        .and()
        .sourceIdEqualTo(sourceId)
        .findFirst();
  }

  // Rolling 7 days moods
  Future<List<MoodLog>> getMoodsForLast7Days(DateTime date) async {
    final startOfToday = DateTime(date.year, date.month, date.day);
    final startOf7DaysAgo = startOfToday.subtract(const Duration(days: 7));
    
    return await isar.moodLogs
        .filter()
        .createdAtBetween(startOf7DaysAgo, startOfToday, includeLower: true, includeUpper: false)
        .findAll();
  }

  // Previous mood
  Future<MoodLog?> getPreviousMood(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    return await isar.moodLogs
        .filter()
        .createdAtLessThan(startOfDay)
        .sortByCreatedAtDesc()
        .findFirst();
  }
}
