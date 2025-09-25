import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  CacheService._privateConstructor();
  static final CacheService instance = CacheService._privateConstructor();

  int? _userId;
  String? _userFullName;

  int? get userId => _userId;
  String? get userFullName => _userFullName;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getInt('userId');
    _userFullName = prefs.getString('userFullName');
  }

  Future<void> save({required int userId, required String userFullName}) async {
    final prefs = await SharedPreferences.getInstance();
    _userId = userId;
    _userFullName = userFullName;
    await prefs.setInt('userId', userId);
    await prefs.setString('userFullName', userFullName);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = null;
    _userFullName = null;
    await prefs.remove('userId');
    await prefs.remove('userFullName');
  }
}
