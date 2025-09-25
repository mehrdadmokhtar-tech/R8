import 'package:flutter/material.dart';
import 'package:r8fitness/utils/utils.dart';
import 'package:r8fitness/services/cache_service.dart';

int? userId = CacheService.instance.userId;
String? userFullName = CacheService.instance.userFullName;

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();

    appLog('داشبورد');
    appLog('داشبورد user id : ${userId.toString()}');
    appLog('داشبورد user name : ${userFullName.toString()}');
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
