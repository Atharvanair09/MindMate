import '../models/anonymous_post.dart';

abstract class AnonymousPostRepository {
  Future<int> create(AnonymousPost post);
  Future<List<AnonymousPost>> getAll();
  Future<bool> delete(int id);
}
