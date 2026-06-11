import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/profile_setup_page.dart';
import 'presentation/pages/mood_check_in_page.dart';
import 'presentation/pages/insights_page.dart';
import 'presentation/pages/chat_page.dart';
import 'presentation/pages/profile_page.dart';
import 'presentation/pages/video_splash_page.dart';
import 'data/repositories/auth_repository.dart';
import 'presentation/viewmodels/auth_viewmodel.dart';
import 'core/state/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final authRepository = AuthRepository();
  final bool hasSession = await authRepository.hasValidSession();

  // Pre-load the user's stored profile from MongoDB before rendering the app
  // so the username and avatar are ready the moment home screen appears.
  UserProvider? preloadedProvider;
  if (hasSession) {
    preloadedProvider = UserProvider();
    await preloadedProvider.loadProfile(authRepository);
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel(repository: authRepository)),
        ChangeNotifierProvider(
          create: (_) => preloadedProvider ?? UserProvider(),
        ),
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
        '/': (context) => VideoSplashPage(nextRoute: hasSession ? '/home' : '/login'),
        '/login': (context) => const LoginPage(),
        '/profile-setup': (context) => const ProfileSetupPage(),
        '/home': (context) => const HomePage(),
        '/mood-check-in': (context) => const MoodCheckInPage(),
        '/insights': (context) => const InsightsPage(),
        '/chat': (context) => const ChatPage(),
        '/profile-page': (context) => const ProfilePage(),
      },
    );
  }
}
