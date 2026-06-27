import 'package:isar/isar.dart';
import '../../domain/models/anonymous_post.dart';
import '../../domain/repositories/anonymous_post_repository.dart';
import '../database/isar_database.dart';

class AnonymousPostRepositoryImpl implements AnonymousPostRepository {
  Isar get _isar => IsarDatabase.instance;
  IsarCollection<AnonymousPost> get _collection => _isar.collection<AnonymousPost>();

  @override
  Future<int> create(AnonymousPost post) async {
    return await _isar.writeTxn(() async {
      return await _collection.put(post);
    });
  }

  @override
  Future<List<AnonymousPost>> getAll() async {
    return await _collection.where().findAll();
  }

  @override
  Future<void> update(AnonymousPost post) async {
    await _isar.writeTxn(() async {
      await _collection.put(post);
    });
  }

  @override
  Future<bool> delete(int id) async {
    return await _isar.writeTxn(() async {
      return await _collection.delete(id);
    });
  }
}
