import 'package:flutter/material.dart';
import 'package:r8fitness/utils/utils.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NFCReaderPage extends StatefulWidget {
  const NFCReaderPage({super.key});

  @override
  State<NFCReaderPage> createState() => _NFCReaderPageState();
}

class _NFCReaderPageState extends State<NFCReaderPage>
    with SingleTickerProviderStateMixin {
  String? nfcUID;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    startNFC();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void startNFC() {
    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        final data = tag.data as Map;
        appLog("tag Data : $data");

        List<int>? id;
        // بررسی نوع کارت  و سپس گرفتن یو آی دی
        if (data.containsKey("mifareclassic")) {
          id = List<int>.from(data["mifareclassic"]["identifier"]);
        } else if (data.containsKey("nfca")) {
          id = List<int>.from(data["nfca"]["identifier"]);
        } else if (data.containsKey("mifareultralight")) {
          id = List<int>.from(data["mifareultralight"]["identifier"]);
        } else if (data.containsKey("ndefformatable")) {
          id = List<int>.from(data["ndefformatable"]["identifier"]);
        }

        String uidHex = "";
        String uidNumeric = "";
        if (id == null) {
          appLog("⚠️ تگ با فرمت ناشناخته");
        } else {
          uidHex = id.map((e) => e.toRadixString(16).padLeft(2, '0')).join('');
          uidNumeric = id.map((e) => e.toString().padLeft(3, '0')).join('');

          appLog("UID Hex : $uidHex");
          appLog("UID Numeric : $uidNumeric");

          NfcManager.instance.stopSession();

          setState(() {
            // nfcUID = uidHex;
            nfcUID = "Data read successfully .";
          });

          // برگردوندن UID به صفحهٔ قبل
          Future.delayed(const Duration(seconds: 1), () {
            if (!mounted) return;
            Navigator.pop(context, uidNumeric);
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(title: const Text("NFC"), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // انیمیشن دایره‌ای
            ScaleTransition(
              scale: Tween(begin: 0.9, end: 1.1).animate(
                CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
              ),
              child: Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  border: Border.all(
                    color: theme.colorScheme.primary,
                    width: 3,
                  ),
                ),
                child: Icon(
                  Icons.nfc,
                  size: 80,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 40),

            // متن وضعیت
            Text(
              nfcUID == null ? "Tap the tag or band" : "$nfcUID",
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 20),

            if (nfcUID == null)
              Text(
                "Waiting to read data...",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              )
            else
              const Icon(Icons.check_circle, color: Colors.green, size: 40),
          ],
        ),
      ),
    );
  }
}
