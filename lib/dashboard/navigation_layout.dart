import 'package:flutter/material.dart';

class NavigationLayout extends StatefulWidget {
  final int currentIndex;
  final Widget body;
  final PreferredSizeWidget? appBar;

  const NavigationLayout({
    super.key,
    required this.currentIndex,
    required this.body,
    this.appBar,
  });

  @override
  State<NavigationLayout> createState() => _NavigationLayoutState();
}

class _NavigationLayoutState extends State<NavigationLayout> {
  int _currentIndex = 0;

  final List<IconData> _icons = [
    Icons.home,
    Icons.account_circle,
    Icons.payment,
  ];

  final List<String> _labels = ["Dashboard", "Profile", "Payment"];

  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  void _onItemTapped(int index) {
    // اینجا می‌تونی ناوبری به صفحات مختلف بزنی
    // مثلاً:
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, "/dashboard");
        break;
      case 1:
        Navigator.pushReplacementNamed(context, "/profile");
        break;
      case 2:
        Navigator.pushReplacementNamed(context, "/payment");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 235, 235),
      appBar: widget.appBar,
      body: widget.body,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 6, spreadRadius: 2),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_icons.length, (index) {
            final isActive = _currentIndex == index;

            return GestureDetector(
              onTap: () => _onItemTapped(index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive
                          ? Color.fromARGB(255, 0, 184, 212)
                          : Colors.transparent,
                    ),
                    child: Icon(
                      _icons[index],
                      color: isActive ? Colors.white : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _labels[index],
                    style: TextStyle(
                      fontSize: 12,
                      color: isActive
                          ? Color.fromARGB(255, 0, 184, 212)
                          : Colors.grey[700],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
