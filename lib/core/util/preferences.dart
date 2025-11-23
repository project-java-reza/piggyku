import 'package:finai_frontend/core/util/security.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static SharedPreferences? prefs;
  static const String token = "token";
  static const String authorization = "authorization";
  static const String channel = "channel";
  static const String deviceId = "deviceId";
  static const String language = "language";

  static void setStringPref(String key, String value) {
    prefs?.setString(key, value);
  }

  static String getStringPref(String key) {
    return prefs?.getString(key).toString() ?? '';
  }

  Future<String?> getStringAs(String key) async {
    return prefs?.getString(key);
  }

  static void getKey() async {
    prefs = await SharedPreferences.getInstance();
  }
}

class Prefs {
  static Future<String?> get getLanguage =>
      PreferencesHelper.getString(Const.language);

  static Future setLanguage(String value) =>
      PreferencesHelper.setString(Const.language, value);

  static Future<String?> get getLocale =>
      PreferencesHelper.getString(Const.locale);

  static Future setLocale(String value) =>
      PreferencesHelper.setString(Const.locale, value);
}

class Const {
  static const String language = "language";
  static const String locale = "locale";
}

class PreferencesHelper {
  static Future<bool> getBool(String key) async {
    final p = await prefs;

    try {
      return p.getBool(Security.encryptAes(key) ?? '') ?? false;
    } catch (e) {
      return p.getBool(key) ?? false;
    }
  }

  static Future<bool?> getBoolNullable(String key) async {
    final p = await prefs;
    try {
      return p.getBool(Security.encryptAes(key) ?? '');
    } catch (e) {
      return p.getBool(key);
    }
  }

  static Future setBool(String key, bool value) async {
    final p = await prefs;

    try {
      return p.setBool(Security.encryptAes(key) ?? '', value);
    } catch (e) {
      return p.setBool(key, value);
    }
  }

  static Future<int> getInt(String key) async {
    final p = await prefs;
    try {
      return p.getInt(Security.encryptAes(key) ?? '') ?? 0;
    } catch (e) {
      return p.getInt(key) ?? 0;
    }
  }

  static Future setInt(String key, int value) async {
    final p = await prefs;

    try {
      return p.setInt(Security.encryptAes(key) ?? '', value);
    } catch (e) {
      return p.setInt(key, value);
    }
  }

  static Future<String?> getString(String key) async {
    final p = await prefs;

    try {
      var decrypt = Security.decryptAes(
          p.getString(Security.encryptAes(key) ?? '') ?? '');
      return decrypt;
    } catch (e) {
      return p.getString(key);
    }
  }

  static Future setString(String key, String value) async {
    final p = await prefs;
    //return p.setString(key, value);

    try {
      return p.setString(
          Security.encryptAes(key) ?? '', Security.encryptAes(value) ?? '');
    } catch (e) {
      return p.setString(key, value);
    }
  }

  static Future<double> getDouble(String key) async {
    final p = await prefs;
    try {
      return p.getDouble(Security.encryptAes(key) ?? '') ?? 0.0;
    } catch (e) {
      return p.getDouble(key) ?? 0.0;
    }
  }

  static Future setDouble(String key, double value) async {
    final p = await prefs;

    try {
      return p.setDouble(Security.encryptAes(key) ?? '', value);
    } catch (e) {
      return p.setDouble(key, value);
    }
  }

  static Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  static void removeAll() async {
    final p = await prefs;

    p.remove(Security.encryptAes(Const.language) ?? '');
    p.remove(Security.encryptAes(Const.locale) ?? '');
  }
}
