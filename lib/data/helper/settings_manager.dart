import 'package:shared_preferences/shared_preferences.dart';

class SettingsManager {
  static const String settingsKey = 'settings';
  static const String mlModelKey = '${settingsKey}_ml_model';
  static const String darkModeKey = '${settingsKey}_dark_mode';
  static const String offlineKey = '${settingsKey}_offline';

  // save ml model
  Future<void> saveMlModel(String model) async {
    final prefs = await SharedPreferences.getInstance();
    String savedModel = prefs.getString(mlModelKey) ?? '';
    savedModel = model;
    prefs.setString(mlModelKey, savedModel);
  }

  // get ml model
  Future<String> getMlModel() async {
    final prefs = await SharedPreferences.getInstance();
    String savedModel = prefs.getString(mlModelKey) ?? 'beans_model';
    return savedModel;
  }

  // save dark mode
  Future<void> saveDarkMode(bool darkMode) async {
    final prefs = await SharedPreferences.getInstance();
    bool savedMode = prefs.getBool(darkModeKey) ?? false;
    savedMode = darkMode;
    prefs.setBool(darkModeKey, savedMode);
  }

  // delete dark mode
  Future<void> deleteDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(darkModeKey);
  }

  // get dark mode
  Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    bool savedMode = prefs.getBool(darkModeKey) ?? false;
    return savedMode;
  }

  // save offline
  Future<void> saveOffline(bool offline) async {
    final prefs = await SharedPreferences.getInstance();
    bool savedMode = prefs.getBool(offlineKey) ?? false;
    savedMode = offline;
    prefs.setBool(offlineKey, savedMode);
  }

  // get offline
  Future<bool> getOffline() async {
    final prefs = await SharedPreferences.getInstance();
    bool savedMode = prefs.getBool(offlineKey) ?? true;
    return savedMode;
  }
}
