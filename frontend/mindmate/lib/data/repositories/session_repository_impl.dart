import 'package:isar/isar.dart';
import '../../domain/models/session_log.dart';
import '../../domain/repositories/session_repository.dart';
import '../database/isar_database.dart';

class SessionRepositoryImpl implements SessionRepository {
  Isar get _isar => IsarDatabase.instance;
  IsarCollection<SessionLog> get _collection => _isar.collection<SessionLog>();

  @override
  Future<int> create(SessionLog item) async {
    return await _isar.writeTxn(() async {
      return await _collection.put(item);
    });
  }

  @override
  Future<void> update(SessionLog item) async {
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
  Future<SessionLog?> getById(int id) async {
    return await _collection.get(id);
  }

  @override
  Future<List<SessionLog>> getAll() async {
    return await _collection.where().findAll();
  }

  @override
  Stream<List<SessionLog>> watch() {
    return _collection.where().watch(fireImmediately: true);
  }

  @override
  Future<List<SessionLog>> search(String query) async {
    // SessionLog doesn't have much text to search, return empty or filtered based on logic.
    return [];
  }
}
