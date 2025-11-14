import 'package:flutter/material.dart';
import 'package:r8fitness/home/home_page.dart';
import 'package:r8fitness/home/payment_page.dart';
import 'package:r8fitness/home/profile_page.dart';
import 'package:r8fitness/utils/utils.dart';
import 'package:flutter/services.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  final _isLoading = false;

  late final List<Widget> _pages;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    setState(() {
      _pages = [HomePage(), PaymentPage(), ProfilePage()];
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    DateTime? lastPressed;

    if (_isLoading) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: Image.asset(
            isDarkMode
                ? 'assets/images/logo-animate-black.gif'
                : 'assets/images/logo-animate-white.gif',
            width: 180,
            height: 180,
          ),
        ),
      );
    }

    return PopScope(
      canPop: false, // یعنی اجازه خروج به صورت خودکار داده نشه
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return; // اگر سیستم خودش pop کرده، هیچ کاری نکن

        final now = DateTime.now();

        if (lastPressed == null ||
            now.difference(lastPressed!) > const Duration(seconds: 2)) {
          lastPressed = now;
          showBottomSnackBar(context, 'Tap agian to exit');
        } else {
          await SystemNavigator.pop(); // خروج از برنامه
        }
      },
      child: Scaffold(
        // عنوان هدر هر تب
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 60,
          elevation: 0,
          title: Image.asset('assets/images/logo.png', height: 60),
          backgroundColor: theme.appBarTheme.backgroundColor,
        ),

        // محتوای اصلی (بر اساس تب انتخاب‌شده)
        body: IndexedStack(index: _currentIndex, children: _pages),

        // نوار پایین
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          showSelectedLabels: true,
          showUnselectedLabels: true,
          backgroundColor: theme.navigationBarTheme.backgroundColor,
          selectedItemColor: theme.colorScheme.secondary,
          unselectedItemColor: theme.colorScheme.secondary,
          type: BottomNavigationBarType.fixed, // برای جلوگیری از شفاف شدن زمینه
          items: [
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.home, 0),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.payment, 1),
              label: 'Payment',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.person, 2),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(IconData icon, int index) {
    final theme = Theme.of(context);
    bool isSelected = _currentIndex == index;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isSelected
            ? theme.colorScheme.primary
            : theme.navigationBarTheme.backgroundColor, // حلقه رنگی
      ),
      child: Icon(
        icon,
        color: theme.colorScheme.secondary, // رنگ ثابت آیکون
      ),
    );
  }
}
