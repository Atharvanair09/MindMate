import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/profile_setup_page.dart';
import 'presentation/pages/mood_check_in_page.dart';
import 'presentation/pages/insights_page.dart';
import 'presentation/pages/chat_page.dart';
import 'presentation/pages/profile_page.dart';
import 'presentation/pages/animated_splash_page.dart';
import 'presentation/pages/weekly_reflection_page.dart';
import 'presentation/pages/username_privacy_tester_page.dart';
import 'presentation/pages/avatar_privacy_tester_page.dart';
import 'presentation/pages/pseudonymization_tester_page.dart';
import 'presentation/pages/sanitized_storage_tester_page.dart';
import 'presentation/pages/community_recommendation_tester_page.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/journal_repository_impl.dart';
import 'data/repositories/chat_repository_impl.dart';
import 'presentation/viewmodels/auth_viewmodel.dart';
import 'core/state/user_provider.dart';
import 'core/state/diary_provider.dart';
import 'core/state/archive_provider.dart';
import 'presentation/pages/memory_vault_page.dart';
import 'data/database/isar_database.dart';
import 'services/embedding/embedding_service.dart';
import 'services/ml/feature_pipeline.dart';
import 'services/notifications/notification_service.dart';
import 'core/state/session_initializer.dart';
import 'core/state/app_state_observer.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize app state awareness
  AppStateObserver.instance.initialize();

  // This removes the debug guidelines border if it was accidentally enabled
  debugPaintSizeEnabled = false;

  final authRepository = AuthRepository();
  final bool hasSession = await authRepository.hasValidSession();

  // Pre-load the user's stored profile from MongoDB before rendering the app
  // so the username and avatar are ready the moment home screen appears.
  UserProvider? preloadedProvider;
  if (hasSession) {
    preloadedProvider = UserProvider();
    await preloadedProvider.loadProfile(authRepository);
    
    final uuid = await authRepository.getDeviceUuid();
    if (uuid != null) {
      await SessionInitializer.initializeUserSession(uuid);
    }
  }

  final journalRepository = JournalRepositoryImpl();
  final chatRepository = ChatRepositoryImpl();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel(repository: authRepository)),
        ChangeNotifierProvider(
          create: (_) => preloadedProvider ?? UserProvider(),
        ),
        ChangeNotifierProvider(create: (_) => DiaryProvider(repository: journalRepository)),
        ChangeNotifierProvider(create: (_) => ArchiveProvider(chatRepository: chatRepository, journalRepository: journalRepository)..loadData()),
      ],
      child: MindMateApp(hasSession: hasSession),
    ),
  );
}

class MindMateApp extends StatelessWidget {
  final bool hasSession;
  
  const MindMateApp({super.key, required this.hasSession});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      title: 'MindMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.indigo,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4B39EF)),
        scaffoldBackgroundColor: const Color(0xFFF9F9FF),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => AnimatedSplashPage(nextRoute: hasSession ? '/home' : '/login'),
        '/login': (context) => const LoginPage(),
        '/profile-setup': (context) => const ProfileSetupPage(),
        '/home': (context) => const HomePage(),
        '/mood-check-in': (context) => const MoodCheckInPage(),
        '/insights': (context) => const InsightsPage(),
        '/chat': (context) => const ChatPage(),
        '/profile-page': (context) => const ProfilePage(),
        '/memory-vault': (context) => const MemoryVaultPage(),
        '/weekly-reflection': (context) => const WeeklyReflectionPage(),
        '/username-privacy-tester': (context) => const UsernamePrivacyTesterPage(),
        '/avatar-privacy-tester': (context) => const AvatarPrivacyTesterPage(),
        '/pseudonymization-tester': (context) => const PseudonymizationTesterPage(),
        '/sanitized-storage-tester': (context) => const SanitizedStorageTesterPage(),
        '/community-recommendation-tester': (context) => const CommunityRecommendationTesterPage(),
      },
    );
  }
}
