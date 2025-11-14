import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:r8fitness/login/login_page.dart';
import 'package:r8fitness/login/nfcreader_page.dart';
import 'package:r8fitness/login/setpassword_page.dart';
import 'package:r8fitness/login/verify_page.dart';
import 'package:r8fitness/login/getotp_page.dart';
import 'package:r8fitness/home/navigation_page.dart';
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
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 214, 213, 213),
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF00B8D4), // رنگ اصلی برنامه همون رنگ آبی
          onPrimary: Colors.white, // رنگ متن روی دکمه ها
          secondary: Colors.grey[900]!,
          onSecondary: Colors.white,
          primaryContainer: Color.fromARGB(255, 242, 242, 242),
          onPrimaryContainer: Colors.black,
          surface: Colors.grey[300]!, // کارت، دیالوگ و ...
          onSurface: Colors.black, // متن روی کارت و دیالوگ
        ),
        //textTheme: GoogleFonts.rubikTextTheme(),
        textTheme: TextTheme(
          bodySmall: TextStyle(color: Colors.grey[700]),
          bodyMedium: TextStyle(color: Colors.black87),
          bodyLarge: TextStyle(color: Colors.black),
          titleLarge: TextStyle(color: Colors.black),
          titleMedium: TextStyle(color: Colors.grey[700]),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Color.fromARGB(255, 242, 242, 242),
          indicatorColor: Colors.grey[800],
        ),
        dialogTheme: DialogThemeData(backgroundColor: Color.fromARGB(255, 242, 242, 242),),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[300],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 46, 46, 46),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color.fromARGB(87, 0, 187, 212),
              width: 2.5,
            ),
          ),
          errorStyle: TextStyle(color: Colors.red),
        ),
      ),

      // 🌙 تم تاریک
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        //textTheme: GoogleFonts.rubikTextTheme(ThemeData.dark().textTheme),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 72, 64, 62),
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
          titleMedium: TextStyle(color: Colors.white70),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Color.fromARGB(255, 52, 44, 42),
          indicatorColor: Colors.white,
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: Color.fromARGB(255, 52, 44, 42),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[900],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 46, 46, 46),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color.fromARGB(87, 0, 187, 212),
              width: 2.5,
            ),
          ),
          errorStyle: TextStyle(color: Colors.red),
        ),
      ),

      builder: (context, child) {
        final theme = Theme.of(context);

        // هماهنگی استاتوس بار با رنگ Scaffold
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: Colors.red,
            //theme.appBarTheme.backgroundColor, // رنگ پس‌زمینه استاتوس بار
            statusBarIconBrightness: theme.brightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark, // رنگ آیکون‌ها
          ),
        );

        return child!;
      },

      // 🧭 مسیرها
      home: const MainPage(),
      routes: {
        '/main': (context) => const MyApp(),
        '/login': (context) => const LoginPage(),
        '/verify': (context) => const VerifyPage(),
        '/setpass': (context) => const SetPasswordPage(),
        '/nfc': (context) => const NFCReaderPage(),
        '/getotp': (context) => const GetOtpPage(),
        '/navi': (context) => const NavigationPage(),
      },
    );
  }
}
