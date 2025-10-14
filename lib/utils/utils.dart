import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

void appLog(String message) {
  debugPrint("📌 [MY_APP] $message");
}

String errorTracking(String errText) {
  String outText;
  outText = errText.replaceAll("Exception: ", "");
  if (outText.contains('Failed to fetch')) {
    outText = 'Can’t connect to the service . Check your network';
  }
  return outText;
}

void showDialogMessage(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("پیام"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("باشه"),
          ),
        ],
      );
    },
  );
}

void showTopSnackBar(
  BuildContext context,
  int colorType,
  int delaySeconds,
  String message,
) {
  Flushbar(
    messageText: Center(
      child: Text(
        message,
        style: TextStyle(color: Colors.white, fontSize: 16),
        textAlign: TextAlign.center,
      ),
    ),
    flushbarPosition: FlushbarPosition.TOP,
    duration: Duration(seconds: delaySeconds == 0 ? 3 : delaySeconds),
    backgroundColor: colorType == 1
        ? Colors.green
        : colorType == 2
        ? Colors.red
        : Colors.white, // رنگ پیش‌فرض
    borderRadius: BorderRadius.circular(5),
    //margin: EdgeInsets.all(16),
  ).show(context);
}

void showBottomSnackBar(BuildContext context, String message) {
  Flushbar(
    messageText: Center(
      child: Text(
        message,
        style: TextStyle(color: Colors.white, fontSize: 16),
        textAlign: TextAlign.center,
      ),
    ),
    flushbarPosition: FlushbarPosition.BOTTOM,
    duration: Duration(seconds: 3),
    backgroundColor: Color(0xFF616161),
    borderRadius: BorderRadius.circular(5),
    //margin: EdgeInsets.all(16),
  ).show(context);
}

Future<T?> showCustomBottomSheet<T>(
  BuildContext context, {
  required Widget child,
  double heightFactor = 0.5, // پیش‌فرض نصف صفحه
  Duration duration = const Duration(milliseconds: 600), // سرعت انیمیشن
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    barrierColor: Colors.black.withValues(alpha: 0.3), // پس‌زمینه نیمه شفاف
    transitionDuration: duration,
    pageBuilder: (context, anim1, anim2) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          heightFactor: heightFactor,
          child: Material(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            color: Colors.white,
            child: child, // ✅ پارامتری شد
          ),
        ),
      );
    },
    transitionBuilder: (context, anim1, anim2, widget) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic)),
        child: widget,
      );
    },
  );
}

List<String> findNullKeys(Map<String, dynamic> args) {
  List<String> nullKeys = [];
  args.forEach((key, value) {
    if (value == null) {
      nullKeys.add(key);
    }
  });
  return nullKeys;
}
