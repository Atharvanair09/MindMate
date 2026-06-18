import 'package:isar/isar.dart';
import '../../domain/models/mood_log.dart';
import '../../domain/repositories/mood_repository.dart';
import '../database/isar_database.dart';

class MoodRepositoryImpl implements MoodRepository {
  Isar get _isar => IsarDatabase.instance;
  IsarCollection<MoodLog> get _collection => _isar.collection<MoodLog>();

  @override
  Future<int> create(MoodLog item) async {
    return await _isar.writeTxn(() async {
      return await _collection.put(item);
    });
  }

  @override
  Future<void> update(MoodLog item) async {
    await _isar.writeTxn(() async {
      await _collection.put(item);
    });
  }

  @override
  Future<bool> delete(int id) async {
    return await _isar.writeTxn(() async {
      return await _collection.delete(id);
    });
  }

  @override
  Future<MoodLog?> getById(int id) async {
    return await _collection.get(id);
  }

  @override
  Future<List<MoodLog>> getAll() async {
    return await _collection.where().findAll();
  }

  @override
  Stream<List<MoodLog>> watch() {
    return _collection.where().watch(fireImmediately: true);
  }

  @override
  Future<List<MoodLog>> search(String query) async {
    final all = await getAll();
    final lowerQuery = query.toLowerCase();
    return all.where((log) => 
      log.reason.toLowerCase().contains(lowerQuery) || 
      log.source.toLowerCase().contains(lowerQuery)
    ).toList();
  }
}
