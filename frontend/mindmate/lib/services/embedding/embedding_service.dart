import 'dart:async';
import 'package:isar/isar.dart';
import '../../data/database/isar_database.dart';
import '../../domain/models/embedding_record.dart';
import 'embedding_model.dart';
import 'embedding_worker.dart';
import 'embedding_queue.dart';

class EmbeddingService {
  static final EmbeddingService _instance = EmbeddingService._internal();
  static EmbeddingService get instance => _instance;

  final EmbeddingModel _model = EmbeddingModel();
  late EmbeddingWorker _worker;

  EmbeddingService._internal() {
    _worker = EmbeddingWorker(_model);
  }

  Future<void> init() async {
    await _model.init();
    _worker.start();
  }

  Future<void> dispose() async {
    _worker.stop();
    _model.release();
  }

  Future<List<double>> embedText(String text) async {
    return await _model.generateAsync(text);
  }

  Future<void> processQueue() async {
    await _worker.processQueue();
  }

  // Helper method to enqueue and process a specific journal
  Future<EmbeddingRecord?> generateJournalEmbedding(String journalId) async {
    int id = int.parse(journalId);
    await EmbeddingQueue.addTask('journal', id);
    await _worker.processQueue();
    // Fetch and return the newly generated record
    return await _getLatestRecord('journal', id);
  }

  // Helper method to enqueue and process a specific chat
  Future<EmbeddingRecord?> generateChatEmbedding(String chatId) async {
    int id = int.parse(chatId);
    await EmbeddingQueue.addTask('chat', id);
    await _worker.processQueue();
    // Fetch and return the newly generated record
    return await _getLatestRecord('chat', id);
  }

  Future<EmbeddingRecord?> _getLatestRecord(String type, int id) async {
    final isar = IsarDatabase.instance;
    return await isar.collection<EmbeddingRecord>()
        .filter()
        .sourceTypeEqualTo(type)
        .and()
        .sourceIdEqualTo(id)
        .sortByCreatedAtDesc()
        .findFirst();
  }
}
