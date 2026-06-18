import 'package:isar/isar.dart';
import '../../domain/models/prediction_log.dart';
import '../../domain/repositories/prediction_repository.dart';
import '../database/isar_database.dart';

class PredictionRepositoryImpl implements PredictionRepository {
  Isar get _isar => IsarDatabase.instance;
  IsarCollection<PredictionLog> get _collection => _isar.collection<PredictionLog>();

  @override
  Future<int> create(PredictionLog item) async {
    return await _isar.writeTxn(() async {
      return await _collection.put(item);
    });
  }

  @override
  Future<void> update(PredictionLog item) async {
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
  Future<PredictionLog?> getById(int id) async {
    return await _collection.get(id);
  }

  @override
  Future<List<PredictionLog>> getAll() async {
    return await _collection.where().findAll();
  }

  @override
  Stream<List<PredictionLog>> watch() {
    return _collection.where().watch(fireImmediately: true);
  }

  @override
  Future<List<PredictionLog>> search(String query) async {
    final all = await getAll();
    final lowerQuery = query.toLowerCase();
    return all.where((rec) => rec.predictedMood.toLowerCase().contains(lowerQuery)).toList();
  }
}
