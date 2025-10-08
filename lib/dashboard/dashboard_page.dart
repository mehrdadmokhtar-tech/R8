import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:r8fitness/utils/utils.dart';
import 'package:r8fitness/services/api_service.dart';
import 'package:r8fitness/services/cache_service.dart';
import 'package:r8fitness/dashboard/navigation_layout.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _isLoading = true;
  final storage = const FlutterSecureStorage();
  int? _userId;
  String? _userName;
  String? _userPhoto;

  @override
  void initState() {
    super.initState();

    _loadPageInfo();
  }

  Future<void> _loadPageInfo() async {
    try {
      await CacheService.instance.load();

      final accessToken = await storage.read(key: 'access_token');
      final userid = CacheService.instance.userId;

      if (userid == null && accessToken == null) return;

      setState(() {
        _userId = CacheService.instance.userId;
        _userName = CacheService.instance.userName;
        _userPhoto = CacheService.instance.userPhoto;
        _isLoading = false;
      });

      final datas = await apiMemberCredits(
        token: accessToken.toString(),
        userid: userid.toString(),
      );
      if (!mounted) return;
      for (var data in datas) {
        appLog('wallet : ${data['wallet'].toString()}');
        appLog('buffet : ${data['buffet'].toString()}');
        appLog('train : ${data['train'].toString()}');
      }
    } catch (e) {
      String errText = errorTracking(e.toString());
      showTopSnackBar(context, 2, 3, errText);
      appLog('error : $errText');
      setState(() => _isLoading = false);
    }
    //appLog('user id ${CacheService.instance.userId.toString()}');
    //appLog('user fullname ${CacheService.instance.userName.toString()}');
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.tealAccent),
        ),
      );
    }

    return NavigationLayout(
      currentIndex: 0,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 235, 235, 235),
        elevation: 0,
        leading: IconButton(
          color: Colors.black,
          icon: Icon(
            Icons.power_settings_new,
            size: 30,
          ), // آیکون پاور برای خارج شدن
          onPressed: () async {
            await storage.deleteAll();
            if (!mounted) return;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, '/main');
            });
          },
        ),
        title: Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _buildDashboardContent(),
    );
  }

  Widget _buildDashboardContent() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: _userPhoto != null
                          ? MemoryImage(base64Decode(_userPhoto!))
                                as ImageProvider
                          : const AssetImage('assets/images/user-profile.jpg'),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 15),
                SizedBox(
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Member ID:  ${_userId.toString()}',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _userName.toString(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // گوشه‌های گرد
                      ),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        height: 200,
                        child: Column(
                          children: [
                            Text(
                              "Cross Fit",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              "اینجا می‌توانید اطلاعات بیشتری درباره جلسات ببینید.",
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context); // بستن مودال
                              },
                              child: Text("Close"),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        SvgPicture.asset(
                          "assets/images/icons/dumbbell.svg",
                          width: 50,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Cross Fit",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "12 ",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: "Sessions",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 2),
                        RawChip(
                          label: const Text(
                            "Started 1 October",
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 138, 4),
                              fontSize: 10,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          backgroundColor: Color.fromARGB(22, 255, 138, 4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide.none,
                          ),
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          pressElevation: 0,
                          side: BorderSide.none,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 15),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // سمت چپ: آیکن + متن
                  Column(
                    children: [
                      SvgPicture.asset(
                        "assets/images/icons/buffet.svg", // مسیر فایل svg خودت
                        width: 50,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Buffet",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  // سمت راست: تعداد قدم‌ها + زمان
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "10,000,000 ",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: "Rls",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 2),
                      RawChip(
                        label: const Text(
                          "Started 1 October",
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 184, 212),
                            fontSize: 10,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        backgroundColor: Color.fromARGB(22, 0, 184, 212),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide.none,
                        ),
                        elevation: 0, // بدون سایه
                        shadowColor: Colors.transparent,
                        pressElevation: 0, // موقع کلیک هم سایه نندازه
                        side: BorderSide.none, // بعضی تم‌ها اینجا لازمه
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
