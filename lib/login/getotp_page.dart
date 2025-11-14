import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:r8fitness/utils/utils.dart';

const int otpLength = 5;

class GetOtpPage extends StatefulWidget {
  const GetOtpPage({super.key});

  @override
  State<GetOtpPage> createState() => _GetOtpPageState();
}

class _GetOtpPageState extends State<GetOtpPage> {
  //late OTPInteractor _otpInteractor;
  OTPTextEditController? _otpController;
  final TextEditingController _pinController = TextEditingController();

  String _receivedCode = "";
  String? errorMessage; // در State
  bool hasError = false;

  @override
  void initState() {
    super.initState();

    if (!kIsWeb) {
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
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    try {
      List<String> nullItems = findNullKeys(args);
      if (nullItems.isNotEmpty) {
        showAnimateTopSnackBar(
          context,
          2,
          3,
          'runtime error : args has null key ; $nullItems',
        );
        return;
      }
    } catch (e) {
      String errText = errorTracking(e.toString());
      showAnimateTopSnackBar(context, 2, 3, errText);
    }
    //appLog(args['otpCode'].toString());

    if (_receivedCode.length == otpLength) {
      if (_receivedCode == args['otpCode']) {
        setState(() {
          errorMessage = null; // ✅ درست بود، خطا پاک بشه
          hasError = false;
        });
        Future.delayed(const Duration(seconds: 1), () {
          if (!mounted) return;
          Navigator.pop(context, {'result': !hasError});
        });
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: theme.textTheme.bodyMedium?.color),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Enter Code",
              style: TextStyle(
                color: theme.textTheme.titleLarge?.color,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Text(
              "We've sent an OTP code to your phone number",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.textTheme.bodyMedium?.color,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 30),

            // OTP Input
            PinCodeTextField(
              appContext: context,
              length: otpLength,
              controller: _pinController,
              keyboardType: TextInputType.number,
              animationType: AnimationType.scale,
              animationDuration: const Duration(milliseconds: 300),
              cursorColor: theme.colorScheme.primary,
              enableActiveFill: true,
              autoDisposeControllers: false,
              backgroundColor: Colors.transparent,
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
                activeColor: hasError ? Colors.red : theme.colorScheme.primary,
                selectedColor: hasError
                    ? Colors.red
                    : theme.colorScheme.primary,
                inactiveColor: hasError ? Colors.red : Colors.grey,
                activeFillColor: theme.inputDecorationTheme.fillColor,
                selectedFillColor: theme.inputDecorationTheme.fillColor,
                inactiveFillColor: theme.inputDecorationTheme.fillColor,
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
                backgroundColor: theme.colorScheme.primary,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _handleVerifyCode,
              child: Text(
                "Verify",
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
