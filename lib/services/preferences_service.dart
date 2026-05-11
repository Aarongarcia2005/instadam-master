import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ValueNotifier<ThemeMode> {
  ThemeNotifier(super.value);
}

class PreferencesService {
  static const String _rememberUserKey = 'rememberUser';
  static const String _usernameKey = 'username';
  static const String _themeModeKey = 'themeMode';

  static Future<void> setRememberUser(bool remember) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberUserKey, remember);
  }

  static Future<bool> getRememberUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_rememberUserKey) ?? false;
  }

  static Future<void> setUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, username);
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  static Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode.toString());
  }

  static Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_themeModeKey) ?? 'ThemeMode.system';
    if (value.contains('dark')) return ThemeMode.dark;
    if (value.contains('light')) return ThemeMode.light;
    return ThemeMode.system;
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}