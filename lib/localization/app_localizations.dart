import 'package:flutter/material.dart';

enum AppLanguage {
  spanish,
  catalan,
  english,
  french,
}

extension AppLanguageExtension on AppLanguage {
  String get code {
    switch (this) {
      case AppLanguage.spanish:
        return 'es';
      case AppLanguage.catalan:
        return 'ca';
      case AppLanguage.english:
        return 'en';
      case AppLanguage.french:
        return 'fr';
    }
  }

  String get displayName {
    switch (this) {
      case AppLanguage.spanish:
        return 'Español';
      case AppLanguage.catalan:
        return 'Català';
      case AppLanguage.english:
        return 'English';
      case AppLanguage.french:
        return 'Français';
    }
  }

  Locale get locale {
    switch (this) {
      case AppLanguage.spanish:
        return const Locale('es');
      case AppLanguage.catalan:
        return const Locale('ca');
      case AppLanguage.english:
        return const Locale('en');
      case AppLanguage.french:
        return const Locale('fr');
    }
  }
}

class AppLocalizations {
  final AppLanguage language;

  AppLocalizations(this.language);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(AppLanguage.spanish);
  }

  // Login Screen
  String get loginTitle => _translations['login_title']![language]!;
  String get loginUsername => _translations['login_username']![language]!;
  String get loginPassword => _translations['login_password']![language]!;
  String get loginButton => _translations['login_button']![language]!;
  String get loginRegister => _translations['login_register']![language]!;
  String get loginRegisterHint => _translations['login_register_hint']![language]!;

  // Feed Screen
  String get feedTitle => _translations['feed_title']![language]!;
  String get feedProfile => _translations['feed_profile']![language]!;
  String get feedSettings => _translations['feed_settings']![language]!;
  String get feedCreatePost => _translations['feed_create_post']![language]!;

  // Create Post Screen
  String get createPostTitle => _translations['create_post_title']![language]!;
  String get createPostHint => _translations['create_post_hint']![language]!;
  String get createPostUploadPhoto => _translations['create_post_upload_photo']![language]!;
  String get createPostTakePhoto => _translations['create_post_take_photo']![language]!;
  String get createPostGallery => _translations['create_post_gallery']![language]!;
  String get createPostPost => _translations['create_post_post']![language]!;
  String get createPostCancel => _translations['create_post_cancel']![language]!;

  // Settings Screen
  String get settingsTitle => _translations['settings_title']![language]!;
  String get settingsAppearance => _translations['settings_appearance']![language]!;
  String get settingsLightMode => _translations['settings_light_mode']![language]!;
  String get settingsDarkMode => _translations['settings_dark_mode']![language]!;
  String get settingsSystemTheme => _translations['settings_system_theme']![language]!;
  String get settingsLanguage => _translations['settings_language']![language]!;
  String get settingsInfo => _translations['settings_info']![language]!;
  String get settingsAbout => _translations['settings_about']![language]!;
  String get settingsAccessibility => _translations['settings_accessibility']![language]!;
  String get settingsLogout => _translations['settings_logout']![language]!;

  // Profile Screen
  String get profileTitle => _translations['profile_title']![language]!;
  String get profilePosts => _translations['profile_posts']![language]!;
  String get profileFollowers => _translations['profile_followers']![language]!;
  String get profileFollowing => _translations['profile_following']![language]!;

  // Comments Screen
  String get commentsTitle => _translations['comments_title']![language]!;
  String get commentsHint => _translations['comments_hint']![language]!;
  String get commentsSend => _translations['comments_send']![language]!;

  // General
  String get back => _translations['back']![language]!;
  String get ok => _translations['ok']![language]!;
  String get cancel => _translations['cancel']![language]!;
  String get error => _translations['error']![language]!;
  String get success => _translations['success']![language]!;

  static const Map<String, Map<AppLanguage, String>> _translations = {
    // Login Screen
    'login_title': {
      AppLanguage.spanish: 'Bienvenido a InstaDAM',
      AppLanguage.catalan: 'Benvingut a InstaDAM',
      AppLanguage.english: 'Welcome to InstaDAM',
      AppLanguage.french: 'Bienvenue à InstaDAM',
    },
    'login_username': {
      AppLanguage.spanish: 'Usuario',
      AppLanguage.catalan: 'Usuari',
      AppLanguage.english: 'Username',
      AppLanguage.french: 'Nom d\'utilisateur',
    },
    'login_password': {
      AppLanguage.spanish: 'Contraseña',
      AppLanguage.catalan: 'Contrasenya',
      AppLanguage.english: 'Password',
      AppLanguage.french: 'Mot de passe',
    },
    'login_button': {
      AppLanguage.spanish: 'Iniciar Sesión',
      AppLanguage.catalan: 'Iniciar Sessió',
      AppLanguage.english: 'Sign In',
      AppLanguage.french: 'Se connecter',
    },
    'login_register': {
      AppLanguage.spanish: 'Crear Cuenta',
      AppLanguage.catalan: 'Crear Compte',
      AppLanguage.english: 'Create Account',
      AppLanguage.french: 'Créer un Compte',
    },
    'login_register_hint': {
      AppLanguage.spanish: '¿No tienes cuenta? Regístrate',
      AppLanguage.catalan: 'No tens compte? Registra\'t',
      AppLanguage.english: 'Don\'t have an account? Register',
      AppLanguage.french: 'Pas de compte? S\'inscrire',
    },

    // Feed Screen
    'feed_title': {
      AppLanguage.spanish: 'Feed',
      AppLanguage.catalan: 'Feed',
      AppLanguage.english: 'Feed',
      AppLanguage.french: 'Flux',
    },
    'feed_profile': {
      AppLanguage.spanish: 'Perfil',
      AppLanguage.catalan: 'Perfil',
      AppLanguage.english: 'Profile',
      AppLanguage.french: 'Profil',
    },
    'feed_settings': {
      AppLanguage.spanish: 'Ajustes',
      AppLanguage.catalan: 'Ajustos',
      AppLanguage.english: 'Settings',
      AppLanguage.french: 'Paramètres',
    },
    'feed_create_post': {
      AppLanguage.spanish: 'Crear Publicación',
      AppLanguage.catalan: 'Crear Publicació',
      AppLanguage.english: 'Create Post',
      AppLanguage.french: 'Créer une Publication',
    },

    // Create Post Screen
    'create_post_title': {
      AppLanguage.spanish: 'Nueva Publicación',
      AppLanguage.catalan: 'Nova Publicació',
      AppLanguage.english: 'New Post',
      AppLanguage.french: 'Nouvelle Publication',
    },
    'create_post_hint': {
      AppLanguage.spanish: '¿Qué estás pensando?',
      AppLanguage.catalan: 'Què estàs pensant?',
      AppLanguage.english: 'What\'s on your mind?',
      AppLanguage.french: 'À quoi penses-tu?',
    },
    'create_post_upload_photo': {
      AppLanguage.spanish: 'Subir Foto',
      AppLanguage.catalan: 'Pujar Foto',
      AppLanguage.english: 'Upload Photo',
      AppLanguage.french: 'Télécharger Photo',
    },
    'create_post_take_photo': {
      AppLanguage.spanish: 'Tomar Foto',
      AppLanguage.catalan: 'Fer Foto',
      AppLanguage.english: 'Take Photo',
      AppLanguage.french: 'Prendre une Photo',
    },
    'create_post_gallery': {
      AppLanguage.spanish: 'Galería',
      AppLanguage.catalan: 'Galeria',
      AppLanguage.english: 'Gallery',
      AppLanguage.french: 'Galerie',
    },
    'create_post_post': {
      AppLanguage.spanish: 'Publicar',
      AppLanguage.catalan: 'Publicar',
      AppLanguage.english: 'Post',
      AppLanguage.french: 'Publier',
    },
    'create_post_cancel': {
      AppLanguage.spanish: 'Cancelar',
      AppLanguage.catalan: 'Cancelar',
      AppLanguage.english: 'Cancel',
      AppLanguage.french: 'Annuler',
    },

    // Settings Screen
    'settings_title': {
      AppLanguage.spanish: 'Ajustes',
      AppLanguage.catalan: 'Ajustos',
      AppLanguage.english: 'Settings',
      AppLanguage.french: 'Paramètres',
    },
    'settings_appearance': {
      AppLanguage.spanish: 'Apariencia',
      AppLanguage.catalan: 'Aparença',
      AppLanguage.english: 'Appearance',
      AppLanguage.french: 'Apparence',
    },
    'settings_light_mode': {
      AppLanguage.spanish: 'Modo Claro',
      AppLanguage.catalan: 'Mode Clar',
      AppLanguage.english: 'Light Mode',
      AppLanguage.french: 'Mode Clair',
    },
    'settings_dark_mode': {
      AppLanguage.spanish: 'Modo Oscuro',
      AppLanguage.catalan: 'Mode Fosc',
      AppLanguage.english: 'Dark Mode',
      AppLanguage.french: 'Mode Sombre',
    },
    'settings_system_theme': {
      AppLanguage.spanish: 'Sistema',
      AppLanguage.catalan: 'Sistema',
      AppLanguage.english: 'System',
      AppLanguage.french: 'Système',
    },
    'settings_language': {
      AppLanguage.spanish: 'Idioma',
      AppLanguage.catalan: 'Idioma',
      AppLanguage.english: 'Language',
      AppLanguage.french: 'Langue',
    },
    'settings_info': {
      AppLanguage.spanish: 'Información',
      AppLanguage.catalan: 'Informació',
      AppLanguage.english: 'Information',
      AppLanguage.french: 'Information',
    },
    'settings_about': {
      AppLanguage.spanish: 'Acerca de InstaDAM',
      AppLanguage.catalan: 'Sobre InstaDAM',
      AppLanguage.english: 'About InstaDAM',
      AppLanguage.french: 'À propos de InstaDAM',
    },
    'settings_accessibility': {
      AppLanguage.spanish: 'Accesibilidad',
      AppLanguage.catalan: 'Accessibilitat',
      AppLanguage.english: 'Accessibility',
      AppLanguage.french: 'Accessibilité',
    },
    'settings_logout': {
      AppLanguage.spanish: 'Cerrar Sesión',
      AppLanguage.catalan: 'Tancar Sessió',
      AppLanguage.english: 'Sign Out',
      AppLanguage.french: 'Se déconnecter',
    },

    // Profile Screen
    'profile_title': {
      AppLanguage.spanish: 'Perfil',
      AppLanguage.catalan: 'Perfil',
      AppLanguage.english: 'Profile',
      AppLanguage.french: 'Profil',
    },
    'profile_posts': {
      AppLanguage.spanish: 'Publicaciones',
      AppLanguage.catalan: 'Publicacions',
      AppLanguage.english: 'Posts',
      AppLanguage.french: 'Publications',
    },
    'profile_followers': {
      AppLanguage.spanish: 'Seguidores',
      AppLanguage.catalan: 'Seguidors',
      AppLanguage.english: 'Followers',
      AppLanguage.french: 'Abonnés',
    },
    'profile_following': {
      AppLanguage.spanish: 'Siguiendo',
      AppLanguage.catalan: 'Seguint',
      AppLanguage.english: 'Following',
      AppLanguage.french: 'Suivi',
    },

    // Comments Screen
    'comments_title': {
      AppLanguage.spanish: 'Comentarios',
      AppLanguage.catalan: 'Comentaris',
      AppLanguage.english: 'Comments',
      AppLanguage.french: 'Commentaires',
    },
    'comments_hint': {
      AppLanguage.spanish: 'Escribe un comentario...',
      AppLanguage.catalan: 'Escriu un comentari...',
      AppLanguage.english: 'Write a comment...',
      AppLanguage.french: 'Écrivez un commentaire...',
    },
    'comments_send': {
      AppLanguage.spanish: 'Enviar',
      AppLanguage.catalan: 'Enviar',
      AppLanguage.english: 'Send',
      AppLanguage.french: 'Envoyer',
    },

    // General
    'back': {
      AppLanguage.spanish: 'Volver',
      AppLanguage.catalan: 'Tornar',
      AppLanguage.english: 'Back',
      AppLanguage.french: 'Retour',
    },
    'ok': {
      AppLanguage.spanish: 'Aceptar',
      AppLanguage.catalan: 'Acceptar',
      AppLanguage.english: 'OK',
      AppLanguage.french: 'OK',
    },
    'cancel': {
      AppLanguage.spanish: 'Cancelar',
      AppLanguage.catalan: 'Cancelar',
      AppLanguage.english: 'Cancel',
      AppLanguage.french: 'Annuler',
    },
    'error': {
      AppLanguage.spanish: 'Error',
      AppLanguage.catalan: 'Error',
      AppLanguage.english: 'Error',
      AppLanguage.french: 'Erreur',
    },
    'success': {
      AppLanguage.spanish: 'Éxito',
      AppLanguage.catalan: 'Èxit',
      AppLanguage.english: 'Success',
      AppLanguage.french: 'Succès',
    },
  };
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  final AppLanguage language;

  const AppLocalizationsDelegate({required this.language});

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(language);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => old.language != language;
}
