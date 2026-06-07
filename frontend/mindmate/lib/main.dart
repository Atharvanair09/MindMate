import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/state/user_provider.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/mood_check_in_page.dart';
import 'presentation/pages/insights_page.dart';
import 'presentation/pages/login_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MindMateApp(),
    ),
  );
}

class MindMateApp extends StatelessWidget {
  const MindMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MindMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF9F9FF),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/mood-check-in': (context) => const MoodCheckInPage(),
        '/insights': (context) => const InsightsPage(),
      },
    );
  }
}
