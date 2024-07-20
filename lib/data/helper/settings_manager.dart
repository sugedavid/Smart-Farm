import 'package:shared_preferences/shared_preferences.dart';

class SettingsManager {
  static const String _settingsKey = 'settings';
  static const String _mlModelKey = '${_settingsKey}_ml_model';
  static const String _darkModeKey = '${_settingsKey}_dark_mode';

  // save ml model
  Future<void> saveMlModel(String model) async {
    final prefs = await SharedPreferences.getInstance();
    String savedModel = prefs.getString(_mlModelKey) ?? '';
    savedModel = model;
    prefs.setString(_mlModelKey, savedModel);
  }

  // delete ml model
  Future<void> deleteMlModel(String model) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_mlModelKey);
  }

  // get ml model
  Future<String> getMlModel() async {
    final prefs = await SharedPreferences.getInstance();
    String savedModel = prefs.getString(_mlModelKey) ?? 'beans_model';
    return savedModel;
  }

  // save dark mode
  Future<void> saveDarkMode(bool darkMode) async {
    final prefs = await SharedPreferences.getInstance();
    bool savedMode = prefs.getBool(_darkModeKey) ?? false;
    savedMode = darkMode;
    prefs.setBool(_darkModeKey, savedMode);
  }

  // delete dark mode
  Future<void> deleteDarkMode(bool model) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_darkModeKey);
  }

  // get dark mode
  Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    bool savedModel = prefs.getBool(_darkModeKey) ?? false;
    return savedModel;
  }
}