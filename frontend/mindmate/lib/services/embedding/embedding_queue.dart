import 'package:isar/isar.dart';
import '../../domain/models/embedding_task.dart';
import '../../data/database/isar_database.dart';

class EmbeddingQueue {
  static Isar get _isar => IsarDatabase.instance;
  static IsarCollection<EmbeddingTask> get _collection => _isar.collection<EmbeddingTask>();

  static Future<void> addTask(String sourceType, int sourceId) async {
    final task = EmbeddingTask()
      ..sourceType = sourceType
      ..sourceId = sourceId
      ..status = 'pending'
      ..createdAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _collection.put(task);
    });
  }

  static Future<List<EmbeddingTask>> getPendingTasks({int limit = 10}) async {
    return await _collection
        .filter()
        .statusEqualTo('pending')
        .or()
        .statusEqualTo('failed')
        .and()
        .retryCountLessThan(3)
        .sortByCreatedAt()
        .limit(limit)
        .findAll();
  }

  static Future<void> markProcessing(int taskId) async {
    await _isar.writeTxn(() async {
      final task = await _collection.get(taskId);
      if (task != null) {
        task.status = 'processing';
        task.startedAt = DateTime.now();
        await _collection.put(task);
      }
    });
  }

  static Future<void> markCompleted(int taskId) async {
    await _isar.writeTxn(() async {
      final task = await _collection.get(taskId);
      if (task != null) {
        task.status = 'completed';
        task.completedAt = DateTime.now();
        await _collection.put(task);
      }
    });
  }

  static Future<void> markFailed(int taskId, String error) async {
    await _isar.writeTxn(() async {
      final task = await _collection.get(taskId);
      if (task != null) {
        task.status = 'failed';
        task.retryCount += 1;
        task.lastError = error;
        await _collection.put(task);
      }
    });
  }
}
