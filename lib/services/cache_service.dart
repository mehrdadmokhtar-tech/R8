import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  CacheService._privateConstructor();
  static final CacheService instance = CacheService._privateConstructor();

  int? _userId;
  String? _userFirstName;
  String? _userLastName;
  String? _userPhoto;

  int? get userId => _userId;
  String? get userFirstName => _userFirstName;
  String? get userLastName => _userLastName;
  String? get userPhoto => _userPhoto;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getInt('userId');
    _userFirstName = prefs.getString('userFirstName');
    _userLastName = prefs.getString('userLastName');
    _userPhoto = prefs.getString('userPhoto');
  }

  Future<void> save({required int userId, required String userFirstName, required String userLastName, required String userPhoto}) async {
    final prefs = await SharedPreferences.getInstance();
    _userId = userId;
    _userFirstName = userFirstName;
    _userLastName = userLastName;
    _userPhoto = userPhoto;
    await prefs.setInt('userId', userId);
    await prefs.setString('userFirstName', userFirstName);
    await prefs.setString('userLastName', userLastName);
    await prefs.setString('userPhoto', userPhoto);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = null;
    _userFirstName = null;
    _userPhoto = null;
    await prefs.remove('userId');
    await prefs.remove('userName');
    await prefs.remove('userLastName');
    await prefs.remove('userPhoto');
  }
}
