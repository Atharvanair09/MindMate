import 'package:isar/isar.dart';
import '../../domain/models/embedding_record.dart';
import '../../domain/repositories/embedding_repository.dart';
import '../database/isar_database.dart';

class EmbeddingRepositoryImpl implements EmbeddingRepository {
  Isar get _isar => IsarDatabase.instance;
  IsarCollection<EmbeddingRecord> get _collection => _isar.collection<EmbeddingRecord>();

  @override
  Future<int> create(EmbeddingRecord item) async {
    return await _isar.writeTxn(() async {
      return await _collection.put(item);
    });
  }

  @override
  Future<void> update(EmbeddingRecord item) async {
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
  Future<EmbeddingRecord?> getById(int id) async {
    return await _collection.get(id);
  }

  @override
  Future<List<EmbeddingRecord>> getAll() async {
    return await _collection.where().findAll();
  }

  @override
  Stream<List<EmbeddingRecord>> watch() {
    return _collection.where().watch(fireImmediately: true);
  }

  @override
  Future<List<EmbeddingRecord>> search(String query) async {
    final all = await getAll();
    final lowerQuery = query.toLowerCase();
    return all.where((rec) => 
      rec.sourceType.toLowerCase().contains(lowerQuery) || 
      rec.modelVersion.toLowerCase().contains(lowerQuery)
    ).toList();
  }
}
