import 'package:isar/isar.dart';
import '../../domain/models/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../database/isar_database.dart';
import '../../services/embedding/embedding_queue.dart';
import '../../core/state/demo_mode_provider.dart';

class ChatRepositoryImpl implements ChatRepository {
  Isar get _isar => IsarDatabase.instance;
  IsarCollection<ChatMessage> get _collection => _isar.collection<ChatMessage>();

  @override
  Future<int> create(ChatMessage item) async {
    final id = await _isar.writeTxn(() async {
      return await _collection.put(item);
    });
    await EmbeddingQueue.addTask('chat', id);
    return id;
  }

  @override
  Future<void> update(ChatMessage item) async {
    await _isar.writeTxn(() async {
      await _collection.put(item);
    });
    await EmbeddingQueue.addTask('chat', item.id);
  }

  @override
  Future<bool> delete(int id) async {
    return await _isar.writeTxn(() async {
      return await _collection.delete(id);
    });
  }

  @override
  Future<ChatMessage?> getById(int id) async {
    return await _collection.get(id);
  }

  @override
  Future<List<ChatMessage>> getAll() async {
    return await _collection.filter().isDemoDataEqualTo(DemoModeProvider.isDemoModeActive).findAll();
  }

  @override
  Stream<List<ChatMessage>> watch() {
    return _collection.filter().isDemoDataEqualTo(DemoModeProvider.isDemoModeActive).watch(fireImmediately: true);
  }

  @override
  Future<List<ChatMessage>> search(String query) async {
    final all = await getAll();
    final lowerQuery = query.toLowerCase();
    return all.where((msg) => msg.message.toLowerCase().contains(lowerQuery)).toList();
  }

  @override
  Future<List<ChatMessage>> getHistory({required String conversationId}) async {
    // With generated code, use .filter().conversationIdEqualTo(conversationId).findAll()
    final all = await getAll();
    final history = all.where((msg) => msg.conversationId == conversationId).toList();
    history.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return history;
  }
}
