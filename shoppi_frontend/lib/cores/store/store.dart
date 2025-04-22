import 'package:shared_preferences/shared_preferences.dart';

class CacheData implements _CacheKey {
  static final CacheData instant = CacheData._internal();

  CacheData._internal();

  late SharedPreferences pref;

  Future<void> initCache() async {
    pref = await SharedPreferences.getInstance();
  }

  String get userId => pref.getString(_CacheKey.userId) ?? '';
  Future<void> setUserId(String userId) =>
      pref.setString(_CacheKey.userId, userId);

  String get username => pref.getString(_CacheKey.username) ?? '';
  Future<void> setUsername(String username) =>
      pref.setString(_CacheKey.username, username);

  String get token => pref.getString(_CacheKey.token) ?? '';
  Future<void> setToken(String token) => pref.setString(_CacheKey.token, token);

  Future removeAllCache() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(_CacheKey.userId);
  }
}

abstract class _CacheKey {
  _CacheKey._internal();

  static const String userId = "userId";
  static const String username = "username";
  static const String token = "token";
}
