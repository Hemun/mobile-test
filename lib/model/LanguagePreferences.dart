import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class LanguagePreferences {
  static const String _kLanguageCodeKey = 'language_code';

  // Get the saved language code
  static Future<String?> getLanguageCode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kLanguageCodeKey);
  }

  // Save the selected language code
  static Future<void> setLanguageCode(String languageCode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLanguageCodeKey, languageCode);
  }
}
