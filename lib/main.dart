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
      theme: ThemeData(textTheme: GoogleFonts.rubikTextTheme()),
      home: const MainPage(),
      routes: {
        '/main': (context) => MyApp(),
        '/login': (context) => LoginPage(),
        '/forgotpass': (context) => ForgotPassPage(),
        '/changepass': (context) => ChangePassPage(),
        '/nfc': (context) => NFCReaderPage(),
        '/otp': (context) => OtpPage(),
        '/dashboard': (context) => DashboardPage(),
        '/register': (context) => RegisterPage(),
      },
    );
  }
}
