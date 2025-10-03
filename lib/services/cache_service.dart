import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  CacheService._privateConstructor();
  static final CacheService instance = CacheService._privateConstructor();

  int? _userId;
  String? _userName;
  String? _userPhoto;

  int? get userId => _userId;
  String? get userName => _userName;
  String? get userPhoto => _userPhoto;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getInt('userId');
    _userName = prefs.getString('userName');
    _userPhoto = prefs.getString('userPhoto');
  }

  Future<void> save({required int userId, required String userName, required String userPhoto}) async {
    final prefs = await SharedPreferences.getInstance();
    _userId = userId;
    _userName = userName;
    _userPhoto = userPhoto;
    await prefs.setInt('userId', userId);
    await prefs.setString('userName', userName);
    await prefs.setString('userPhoto', userPhoto);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = null;
    _userName = null;
    _userPhoto = null;
    await prefs.remove('userId');
    await prefs.remove('userName');
    await prefs.remove('userPhoto');
  }
}
