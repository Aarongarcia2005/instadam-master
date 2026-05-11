import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'screens/login_screen.dart';
import 'screens/feed_screen.dart';
import 'services/preferences_service.dart';
import 'database/db_helper.dart';

void main() {
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeNotifier _themeNotifier;

  @override
  void initState() {
    super.initState();
    _initTheme();
  }

  Future<void> _initTheme() async {
    final savedTheme = await PreferencesService.getThemeMode();
    _themeNotifier = ThemeNotifier(savedTheme);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!mounted) return const SizedBox();
    
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeNotifier,
      builder: (context, themeMode, _) {
        return MaterialApp(
          title: 'InstaDAM',
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
            appBarTheme: const AppBarTheme(
              elevation: 0,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            primarySwatch: Colors.blue,
            appBarTheme: AppBarTheme(
              elevation: 0,
              backgroundColor: Colors.grey[900],
              foregroundColor: Colors.white,
            ),
          ),
          themeMode: themeMode,
          home: AuthWrapper(themeNotifier: _themeNotifier),
        );
      },
    );
  }
}

class AuthWrapper extends StatefulWidget {
  final ThemeNotifier themeNotifier;

  const AuthWrapper({super.key, required this.themeNotifier});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    _initializeExampleData();
  }

  Future<void> _initializeExampleData() async {
    DBHelper dbHelper = DBHelper();
    
    // Verificar si ya hay posts de ejemplo
    List<Map<String, dynamic>> posts = await (await dbHelper.database).query('posts');
    
    // Si no hay posts, insertar datos de ejemplo
    if (posts.isEmpty) {
      try {
        // Buscar usuario blanco
        Map<String, dynamic>? demoUser = await dbHelper.getUserByUsername('blanco');
        
        if (demoUser == null) {
          await dbHelper.insertUser({
            'username': 'blanco',
            'password': 'blanco',
            'email': 'blanco@gmail.com',
          });
          demoUser = await dbHelper.getUserByUsername('blanco');
        }
        
        if (demoUser != null) {
          int demoUserId = demoUser['id'];
          
          // Insertar posts de ejemplo
          await dbHelper.insertPost({
            'userId': demoUserId,
            'content': 'Primer post INSTADAM ',
            'imagePath': 'https://s2.abcstatics.com/media/sociedad/2016/02/24/sindrome-down-anciano--620x349.jpg',
            'timestamp': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
          });
          
          await dbHelper.insertPost({
            'userId': demoUserId,
            'content': 'Segundo post INSTADAM ',
            'imagePath': 'assets/imagen2.png',
            'timestamp': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
          });
          
          await dbHelper.insertPost({
            'userId': demoUserId,
            'content': 'Tercer post INSTADAM 🦽',
            'imagePath': 'assets/imagen3.png',
            'timestamp': DateTime.now().toIso8601String(),
          });
        }
      } catch (e) {
        debugPrint('Error inicializando datos de ejemplo: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkRememberedUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.data == true) {
          return FutureBuilder<String?>(
            future: _getUsername(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              if (userSnapshot.data != null) {
                return FeedScreen(
                  username: userSnapshot.data!,
                  themeNotifier: widget.themeNotifier,
                );
              }
              return LoginScreen(themeNotifier: widget.themeNotifier);
            },
          );
        }
        return LoginScreen(themeNotifier: widget.themeNotifier);
      },
    );
  }

  Future<bool> _checkRememberedUser() async {
    return await PreferencesService.getRememberUser();
  }

  Future<String?> _getUsername() async {
    return await PreferencesService.getUsername();
  }
}
