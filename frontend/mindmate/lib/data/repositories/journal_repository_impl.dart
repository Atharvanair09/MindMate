import 'package:isar/isar.dart';
import '../../domain/models/journal_entry.dart';
import '../../domain/repositories/journal_repository.dart';
import '../database/isar_database.dart';
import '../../services/embedding/embedding_queue.dart';
import '../../core/state/demo_mode_provider.dart';

class JournalRepositoryImpl implements JournalRepository {
  Isar get _isar => IsarDatabase.instance;
  IsarCollection<JournalEntry> get _collection => _isar.collection<JournalEntry>();

  @override
  Future<int> create(JournalEntry item) async {
    final id = await _isar.writeTxn(() async {
      return await _collection.put(item);
    });
    await EmbeddingQueue.addTask('journal', id);
    return id;
  }

  @override
  Future<void> update(JournalEntry item) async {
    await _isar.writeTxn(() async {
      await _collection.put(item);
    });
    await EmbeddingQueue.addTask('journal', item.id);
  }

  @override
  Future<bool> delete(int id) async {
    return await _isar.writeTxn(() async {
      return await _collection.delete(id);
    });
  }

  @override
  Future<JournalEntry?> getById(int id) async {
    return await _collection.get(id);
  }

  @override
  Future<List<JournalEntry>> getAll() async {
    return await _collection.filter().isDemoDataEqualTo(DemoModeProvider.isDemoModeActive).findAll();
  }

  @override
  Stream<List<JournalEntry>> watch() {
    return _collection.filter().isDemoDataEqualTo(DemoModeProvider.isDemoModeActive).watch(fireImmediately: true);
  }

  @override
  Future<List<JournalEntry>> search(String query) async {
    // Search depends on generated extensions.
    // For now we'll do an in-memory search if Isar extensions aren't imported,
    // but ideally we'd use .filter().titleContains() etc.
    final all = await getAll();
    final lowerQuery = query.toLowerCase();
    return all.where((entry) => 
      (entry.title?.toLowerCase().contains(lowerQuery) ?? false) ||
      entry.content.toLowerCase().contains(lowerQuery)
    ).toList();
  }
}
