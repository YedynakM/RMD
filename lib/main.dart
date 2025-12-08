import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/repositories/local_auth_repository.dart';
import 'data/repositories/i_auth_repository.dart'; 
import 'data/repositories/local_music_repository.dart'; 
import 'data/repositories/i_music_repository.dart';     

import 'data/services/connectivity_service.dart';
import 'data/services/mqtt_service.dart';


import 'providers/auth_provider.dart';
import 'providers/home_provider.dart';


import 'screens/login_page.dart';
import 'screens/registration_page.dart';
import 'screens/home_page.dart';
import 'screens/profile_page.dart';
import 'screens/all_music_list_page.dart';
import 'screens/file_explorer_page.dart';
import 'screens/player_page.dart';
import 'screens/remote_music_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  

  final authRepo = LocalAuthRepository();
  final musicRepo = LocalMusicRepository();
  final connectivityService = ConnectivityService();
  final mqttService = MqttService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authRepo, connectivityService),
        ),
        ChangeNotifierProvider(
            create: (_) => HomeProvider(mqttService)
        ),

        Provider<IAuthRepository>.value(value: authRepo), 
        Provider<IMusicRepository>.value(value: musicRepo), 
        Provider<ConnectivityService>.value(value: connectivityService),
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
      title: 'IoT Music Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          elevation: 0,
        ),
      ),
      home: const AuthWrapper(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegistrationPage(),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
        '/all-music': (context) => const AllMusicListPage(),
        '/explorer': (context) => const FileExplorerPage(),
        '/player': (context) => const PlayerPage(),
        '/remote-music': (context) => const RemoteMusicPage(), 
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authStatus = context.watch<AuthProvider>().status;

    switch (authStatus) {
      case AuthStatus.initial:
      case AuthStatus.tryingAutoLogin:
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      case AuthStatus.authenticated:
        return const HomePage();
      case AuthStatus.unauthenticated:
        return const LoginPage();
    }
  }
}