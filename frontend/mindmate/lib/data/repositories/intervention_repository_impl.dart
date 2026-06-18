import 'package:isar/isar.dart';
import '../../domain/models/intervention_log.dart';
import '../../domain/repositories/intervention_repository.dart';
import '../database/isar_database.dart';

class InterventionRepositoryImpl implements InterventionRepository {
  Isar get _isar => IsarDatabase.instance;
  IsarCollection<InterventionLog> get _collection => _isar.collection<InterventionLog>();

  @override
  Future<int> create(InterventionLog item) async {
    return await _isar.writeTxn(() async {
      return await _collection.put(item);
    });
  }

  @override
  Future<void> update(InterventionLog item) async {
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
  Future<InterventionLog?> getById(int id) async {
    return await _collection.get(id);
  }

  @override
  Future<List<InterventionLog>> getAll() async {
    return await _collection.where().findAll();
  }

  @override
  Stream<List<InterventionLog>> watch() {
    return _collection.where().watch(fireImmediately: true);
  }

  @override
  Future<List<InterventionLog>> search(String query) async {
    final all = await getAll();
    final lowerQuery = query.toLowerCase();
    return all.where((rec) => rec.interventionType.toLowerCase().contains(lowerQuery)).toList();
  }
}
