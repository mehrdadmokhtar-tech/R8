import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:r8fitness/login/login_page.dart';
import 'package:r8fitness/login/nfcreader_page.dart';
import 'package:r8fitness/login/forgotpass_page.dart';
import 'package:r8fitness/login/changepass_page.dart';
import 'package:r8fitness/login/register_page.dart';
import 'package:r8fitness/login/otp_page.dart';
import 'package:r8fitness/dashboard/dashboard_page.dart';
import 'package:r8fitness/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // 👇 این یعنی اپ با تنظیمات سیستم (Dark / Light) هماهنگ میشه
      themeMode: ThemeMode.system,

      // 🎨 تم روشن
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.rubikTextTheme(),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
      ),

      // 🌙 تم تاریک
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        textTheme: GoogleFonts.rubikTextTheme(ThemeData.dark().textTheme),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),

      // 🧭 مسیرها
      home: const MainPage(),
      routes: {
        '/main': (context) => const MyApp(),
        '/login': (context) => const LoginPage(),
        '/forgotpass': (context) => const ForgotPassPage(),
        '/changepass': (context) => const ChangePassPage(),
        '/nfc': (context) => const NFCReaderPage(),
        '/otp': (context) => const OtpPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/register': (context) => const RegisterPage(),
      },
    );
  }
}
