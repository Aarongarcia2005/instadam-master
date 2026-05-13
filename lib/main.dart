import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'screens/login_screen.dart';
import 'screens/feed_screen.dart';
import 'services/preferences_service.dart';
import 'database/db_helper.dart';
import 'localization/app_localizations.dart';

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
  late LanguageNotifier _languageNotifier;

  @override
  void initState() {
    super.initState();
    _initTheme();
    _initLanguage();
  }

  Future<void> _initTheme() async {
    final savedTheme = await PreferencesService.getThemeMode();
    _themeNotifier = ThemeNotifier(savedTheme);
    setState(() {});
  }

  Future<void> _initLanguage() async {
    final savedLanguage = await PreferencesService.getLanguage();
    _languageNotifier = LanguageNotifier(savedLanguage);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!mounted) return const SizedBox();
    
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeNotifier,
      builder: (context, themeMode, _) {
        return ValueListenableBuilder<AppLanguage>(
          valueListenable: _languageNotifier,
          builder: (context, language, _) {
            return MaterialApp(
              title: 'InstaDAM',
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                AppLocalizationsDelegate(language: language),
              ],
              supportedLocales: const [
                Locale('es'),
                Locale('ca'),
                Locale('en'),
                Locale('fr'),
              ],
              locale: language.locale,
              theme: ThemeData(
                useMaterial3: true,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.purple,
                  brightness: Brightness.light,
                ),
                scaffoldBackgroundColor: Colors.grey[50],
                cardColor: Colors.white,
                appBarTheme: AppBarTheme(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  iconTheme: const IconThemeData(color: Colors.black87),
                ),
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: Colors.grey[100],
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  labelStyle: TextStyle(color: Colors.grey[900]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.purple.shade600,
                      width: 2,
                    ),
                  ),
                ),
                textTheme: Typography.blackMountainView.copyWith(
                  bodyLarge: const TextStyle(color: Colors.black87),
                  bodyMedium: const TextStyle(color: Colors.black87),
                  bodySmall: const TextStyle(color: Colors.black87),
                  titleLarge: const TextStyle(color: Colors.black87),
                ),
                iconTheme: const IconThemeData(color: Colors.black87),
              ),
              darkTheme: ThemeData(
                useMaterial3: true,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.purple,
                  brightness: Brightness.dark,
                ),
                scaffoldBackgroundColor: Colors.grey[900],
                cardColor: Colors.grey[850],
                appBarTheme: AppBarTheme(
                  elevation: 0,
                  backgroundColor: Colors.grey[900],
                  foregroundColor: Colors.white,
                  iconTheme: const IconThemeData(color: Colors.white),
                ),
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: Colors.grey[800],
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[700]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[700]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.purple.shade200,
                      width: 2,
                    ),
                  ),
                ),
                textTheme: Typography.whiteMountainView.copyWith(
                  bodyLarge: const TextStyle(color: Colors.white),
                  bodyMedium: const TextStyle(color: Colors.white),
                  bodySmall: const TextStyle(color: Colors.white70),
                  titleLarge: const TextStyle(color: Colors.white),
                ),
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              themeMode: themeMode,
              home: AuthWrapper(
                themeNotifier: _themeNotifier,
                languageNotifier: _languageNotifier,
              ),
            );
          },
        );
      },
    );
  }
}

class AuthWrapper extends StatefulWidget {
  final ThemeNotifier themeNotifier;
  final LanguageNotifier languageNotifier;

  const AuthWrapper({
    super.key,
    required this.themeNotifier,
    required this.languageNotifier,
  });

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
            'content': 'Primer post INSTADAM',
            'imagePath': 'https://picsum.photos/seed/instadam1/900/500',
            'timestamp': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
          });
          
          await dbHelper.insertPost({
            'userId': demoUserId,
            'content': 'Segundo post INSTADAM',
            'imagePath': 'https://picsum.photos/seed/instadam2/900/500',
            'timestamp': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
          });
          
          await dbHelper.insertPost({
            'userId': demoUserId,
            'content': 'Tercer post INSTADAM 🦽',
            'imagePath': 'https://picsum.photos/seed/instadam3/900/500',
            'timestamp': DateTime.now().toIso8601String(),
          });
        }
      } catch (e) {
        debugPrint('Error inicializando datos de ejemplo: $e');
      }
    } else {
      try {
        for (var post in posts) {
          final String? imagePath = post['imagePath'] as String?;
          if (imagePath != null && imagePath.startsWith('assets/')) {
            final int id = post['id'] as int;
            String newImagePath = 'https://picsum.photos/seed/instadam_default_$id/900/500';

            if (post['content'] == 'Primer post INSTADAM') {
              newImagePath = 'https://picsum.photos/seed/instadam1/900/500';
            } else if (post['content'] == 'Segundo post INSTADAM') {
              newImagePath = 'https://picsum.photos/seed/instadam2/900/500';
            } else if (post['content'] == 'Tercer post INSTADAM 🦽') {
              newImagePath = 'https://picsum.photos/seed/instadam3/900/500';
            }

            await dbHelper.updatePost(id, {'imagePath': newImagePath});
          }
        }
      } catch (e) {
        debugPrint('Error migrando rutas de imagen antiguas: $e');
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
                  languageNotifier: widget.languageNotifier,
                );
              }
              return LoginScreen(
                themeNotifier: widget.themeNotifier,
                languageNotifier: widget.languageNotifier,
              );
            },
          );
        }
        return LoginScreen(
          themeNotifier: widget.themeNotifier,
          languageNotifier: widget.languageNotifier,
        );
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
