import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:r8fitness/services/api_service.dart';
import 'package:r8fitness/services/storage_service.dart';
import 'package:r8fitness/utils/utils.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    WidgetsFlutterBinding.ensureInitialized();

    final storage = const FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');
    final refreshToken = await storage.read(key: 'refresh_token');
    if (!mounted) return;

    appLog('توکن لود');
    appLog('accessToken ${accessToken.toString()}');
    appLog('refreshToken ${refreshToken.toString()}');

    // لاگین نشده و اکسس توکن وجود ندارد
    if (accessToken == null || refreshToken == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return;
    }

    // کنترل تاریخ انقضا اکسس توکن موجود
    final isExpired = _isAccessTokenExpired(accessToken);

    appLog('توکن اکسپایر کنترل ${isExpired.toString()}');

    if (!isExpired) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      });
    } else {
      // تلاش برای دریافت اکسس توکن جدید
      final Map<String, dynamic> data;
      try {
        data = await apiGetNewToken(refreshtoken: refreshToken.toString());
        if (!mounted) return;
        if (data['returnValue'] == 1) {
          final accessToken = data['accessToken'] ?? '';
          final refreshToken = data['refreshToken'] ?? '';
          await StorageService.instance.saveTokens(
            accessToken: accessToken,
            refreshToken: refreshToken,
          );
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/dashboard');
        } else {
          Navigator.pushReplacementNamed(context, '/login');
        }
      } catch (e) {
        showTopSnackBar(context, 2, 3, '$e');
        appLog('$e');
      }
    }
  }

  bool _isAccessTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        return true; // JWT معتبر نیست
      }

      final payload = utf8.decode(
        base64Url.decode(base64Url.normalize(parts[1])),
      );
      final payloadMap = json.decode(payload);

      if (payloadMap is! Map<String, dynamic>) {
        return true;
      }

      final exp = payloadMap['exp'];
      if (exp == null) return true;

      final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      return DateTime.now().isAfter(expiryDate);
    } catch (e) {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset(
          "assets/images/logo-animate.gif",
          width: 170,
          height: 170,
        ),
      ),
    );
  }
}
