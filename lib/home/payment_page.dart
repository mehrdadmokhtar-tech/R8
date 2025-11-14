import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final storage = const FlutterSecureStorage();      

  void _onpress() async {
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Payment ? 💰',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Comming soon ..',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            // const SizedBox(height: 20),
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: theme.colorScheme.primary,
            //     disabledBackgroundColor: Colors.grey,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(12),
            //     ) ,
            //   ),
            //   onPressed: () { _onpress(); },
            //   child: Text(
            //     "START",
            //     style: TextStyle(
            //       fontSize: 17,
            //       fontWeight: FontWeight.bold,
            //       color: theme.colorScheme.onPrimary,
            //     ),
            //   )
            // ),
          ],
        ),
      ),
    );
  }
}
