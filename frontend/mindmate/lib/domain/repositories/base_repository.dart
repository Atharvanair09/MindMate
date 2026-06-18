abstract class BaseRepository<T> {
  Future<int> create(T item);
  Future<void> update(T item);
  Future<bool> delete(int id);
  Future<T?> getById(int id);
  Future<List<T>> getAll();
  Stream<List<T>> watch();
  Future<List<T>> search(String query);
}
