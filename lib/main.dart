import 'package:flutter/material.dart';
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
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        //textTheme: GoogleFonts.rubikTextTheme(),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF00B8D4), // رنگ اصلی برنامه همون رنگ آبی
          onPrimary: Colors.white, // رنگ متن روی دکمه ها
          secondary: Colors.grey[900]!,
          onSecondary: Colors.white,
          primaryContainer: Color.fromARGB(255, 242, 242, 242),
          onPrimaryContainer: Colors.black,
          surface: Colors.grey[100]!, // کارت، دیالوگ و ...
          onSurface: Colors.black, // متن روی کارت و دیالوگ
        ),
        textTheme: TextTheme(
          bodySmall: TextStyle(color: Colors.grey[900]),
          bodyMedium: TextStyle(color: Colors.black87),
          bodyLarge: TextStyle(color: Colors.black),
          titleLarge: TextStyle(color: Colors.black),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: Colors.grey[700],
        ),
        dialogTheme: DialogThemeData(backgroundColor: Colors.white),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[300],
        ),
      ),

      // 🌙 تم تاریک
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        //textTheme: GoogleFonts.rubikTextTheme(ThemeData.dark().textTheme),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF00B8D4), // رنگ اصلی برنامه همون رنگ آبی
          onPrimary: Colors.white,
          secondary: Colors.white70,
          onSecondary: Colors.black,
          primaryContainer: Color.fromARGB(255, 52, 44, 42),
          onPrimaryContainer: Colors.white,
          surface: Colors.grey[700]!, // کارت، دیالوگ و ...
          onSurface:
              Colors.white70, // متن روی کارت و دیالوگ // رنگ متن روی دکمه ها
        ),
        textTheme: TextTheme(
          bodySmall: TextStyle(color: Colors.white70),
          bodyMedium: TextStyle(color: Colors.white70),
          bodyLarge: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Color.fromARGB(255, 52, 44, 42),
          indicatorColor: Color.fromARGB(255, 221, 213, 211),
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: Color.fromARGB(255, 52, 44, 42),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[900],
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
