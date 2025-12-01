import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// Імпортуємо ВСІ наші репозиторії
import 'data/repositories/i_auth_repository.dart';
import 'data/repositories/local_auth_repository.dart';
import 'data/repositories/i_music_repository.dart';
import 'data/repositories/local_music_repository.dart';

// Імпортую екрани
import 'screens/login_page.dart';
import 'screens/registration_page.dart';
import 'screens/home_page.dart';
import 'screens/profile_page.dart';
import 'screens/all_music_list_page.dart';
import 'screens/file_explorer_page.dart';
import 'screens/player_page.dart';



// ... (імпорти екранів)

// main() тепер асинхронна, щоб ми могли ініціалізувати БД
void main() async {
  // Це потрібно, щоб Flutter був готовий до асинхронного main
  WidgetsFlutterBinding.ensureInitialized(); 
  
  // Можна додати ініціалізацію БД тут, якщо потрібно
  // await AppDatabase.instance.database; 
  
  runApp(
    // 1. Використовуємо MultiProvider для "надання" кількох сервісів
    MultiProvider(
      providers: [
        // 2. Наш Auth Репозиторій
        Provider<IAuthRepository>(
          create: (_) => LocalAuthRepository(),
        ),
        // 3. Наш НОВИЙ Music Репозиторій
        Provider<IMusicRepository>(
          create: (_) => LocalMusicRepository(),
        ),
      ],
      child: const MyApp(),
    ),
  );
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
      

      // "Іменований роутинг". Дуже потужно.
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