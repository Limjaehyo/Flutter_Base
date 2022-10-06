import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  SharedPreferences? _prefs;
  static SharedPref? _instance;
  SharedPref._();

  static SharedPref getInstance() {
    _instance ??= SharedPref._();
    return _instance!;
  }

  Future<bool> clearData() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!.clear();
  }

  Future<bool> saveData(String key, dynamic value) async {
    _prefs ??= await SharedPreferences.getInstance();

    bool result = false;
    if (value is int) {
      result = await _prefs!.setInt(key, value);
    } else if (value is bool) {
      result = await _prefs!.setBool(key, value);
    } else if (value is double) {
      result = await _prefs!.setDouble(key, value);
    } else if (value is String) {
      result = await _prefs!.setString(key, value);
    } else if (value is List<String>) {
      result = await _prefs!.setStringList(key, value);
    }
    return result;
  }

  Future<String?> loadData(String key) async {
    _prefs ??= await SharedPreferences.getInstance();
    return (_prefs!.get(key) as String?);
  }

  Future<bool> removeEntry(String key) async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!.remove(key);
  }
}
