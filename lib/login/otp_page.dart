import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:r8fitness/utils/utils.dart';

const int otpLength = 5;

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  //late OTPInteractor _otpInteractor;
  OTPTextEditController? _otpController;
  final TextEditingController _pinController = TextEditingController();

  String _receivedCode = "";
  String? errorMessage; // در State
  bool hasError = false;

  @override
  void initState() {
    super.initState();

    _otpController =
        OTPTextEditController(
          codeLength: otpLength, // طول کد OTP
          onCodeReceive: (code) {
            setState(() {
              _receivedCode = code;
              _pinController.text = code;
            });
            appLog("📩 کد دریافتی: $code");
          },
        )..startListenUserConsent((code) {
          // اینجا regex می‌ذاری برای گرفتن 5 رقم
          final exp = RegExp(r'\d{' + otpLength.toString() + r'}');
          return exp.stringMatch(code ?? '') ?? '';
        });
  }

  @override
  void dispose() {
    if (Platform.isAndroid) {
      _otpController?.stopListen();
    }
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _handleVerifyCode() async {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    try {
      List<String> nullItems = findNullKeys(args);
      if (nullItems.isNotEmpty) {
        showTopSnackBar(
          context,
          2,
          3,
          'runtime error : args has null key ; $nullItems',
        );
      }    
    } catch (e) {
      showTopSnackBar(context, 2, 3, '$e');
    }

    if (_receivedCode.length == otpLength) {
      if (_receivedCode == args['serverOtp']) {
        setState(() {
          errorMessage = null; // ✅ درست بود، خطا پاک بشه
          hasError = false;
        });
        await Navigator.pushReplacementNamed(
          context,
          '/changepass',
          arguments: {'userId': args['userId'], 'serverOtp': args['serverOtp']},
        );
        if (!mounted) return;
      } else {
        setState(() {
          errorMessage = "Oops! The code is wrong.";
          hasError = true;
        });
      }
    } else {
      setState(() {
        errorMessage = "Enter the whole code, please.";
        hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Enter Code",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            const Text(
              "We've sent an OTP code to your phone number",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 30),

            // OTP Input
            PinCodeTextField(
              appContext: context,
              length: otpLength,
              controller: _pinController,
              textStyle: TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              animationType: AnimationType.scale,
              animationDuration: const Duration(milliseconds: 300),
              cursorColor: Color.fromARGB(255, 0, 184, 212),
              enableActiveFill: false,
              autoDisposeControllers: false,
              onChanged: (value) {
                setState(() {
                  _receivedCode = value;
                  if (value.isNotEmpty) {
                    hasError = false;
                    errorMessage = null;
                  }
                });
              },
              onCompleted: (_) => _handleVerifyCode(),
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(8),
                fieldHeight: 55,
                fieldWidth: 50,
                activeColor: hasError
                    ? Colors.red
                    : Color.fromARGB(255, 0, 184, 212),
                selectedColor: hasError
                    ? Colors.red
                    : Color.fromARGB(255, 0, 184, 212),
                inactiveColor: hasError ? Colors.red : Colors.grey,
                selectedFillColor: Colors.black,
                inactiveFillColor: Colors.black,
              ),
            ),
            // پیام خطا
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),

            const SizedBox(height: 24),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 0, 184, 212),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _handleVerifyCode,
              child: const Text(
                "Verify",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
