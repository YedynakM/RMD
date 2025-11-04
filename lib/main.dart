import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Імпортуємо всі наші екрани
import 'screens/login_page.dart';
import 'screens/registration_page.dart';
import 'screens/home_page.dart';
import 'screens/profile_page.dart';
import 'screens/all_music_list_page.dart';
import 'screens/file_explorer_page.dart';
import 'screens/player_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Audio Hub',
      // Налаштовуємо темну тему для музичного плеєра
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
        textTheme: GoogleFonts.interTextTheme(
          ThemeData(brightness: Brightness.dark).textTheme,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,

      // Це "іменований роутинг". Дуже чисто і зручно.
      initialRoute: '/login', // Стартовий екран
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegistrationPage(),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
        '/all-music': (context) => const AllMusicListPage(),
        '/explorer': (context) => const FileExplorerPage(),
        '/player': (context) => const PlayerPage(),
      },
    );
  }
}