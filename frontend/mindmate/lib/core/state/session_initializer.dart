import '../../data/database/isar_database.dart';
import '../../services/embedding/embedding_service.dart';
import '../../services/ml/feature_pipeline.dart';
import '../../services/notifications/notification_service.dart';
import '../../services/community/community_socket_service.dart';

class SessionInitializer {
  static Future<void> initializeUserSession(String uuid) async {
    await IsarDatabase.initialize(uuid);
    await EmbeddingService.instance.init();
    FeaturePipeline.instance.initialize();
    await NotificationService.instance.initialize();
    await CommunitySocketService.instance.init();
  }
}
