import 'package:flutter/material.dart';
import 'package:r8fitness/utils/utils.dart';
import 'package:r8fitness/services/api_service.dart';
import 'package:r8fitness/services/cache_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

int? userId = CacheService.instance.userId;
String? userFullName = CacheService.instance.userFullName;

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();

    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try{
      final accessToken = await storage.read(key: 'access_token');
      final userid = CacheService.instance.userId.toString();

      final datas = await apiCredits(token: accessToken.toString(), userid : userid);
      if (!mounted) return;
      for (var data in datas) {
        appLog('wallet : ${data['wallet'].toString()}');
        appLog('buffet : ${data['buffet'].toString()}');
        appLog('train : ${data['train'].toString()}');
      }
    } catch (e) {
      showTopSnackBar(context, 2, 3, '$e');
      appLog('error : $e');
    }      
    appLog('user id ${CacheService.instance.userId.toString()}');
    appLog('user fullname ${CacheService.instance.userFullName.toString()}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue, elevation: 3),
      body: Center(
        child: Text(
          "${userId.toString()}\n${userFullName.toString()}\nخوش آمدید",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
