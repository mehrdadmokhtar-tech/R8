import 'package:flutter/material.dart';
import 'package:r8fitness/utils/utils.dart';
import 'package:r8fitness/services/api_service.dart';

class VerifyUserPage extends StatefulWidget {
  const VerifyUserPage({super.key});

  @override
  State<VerifyUserPage> createState() => _VerifyUserPageState();
}

class _VerifyUserPageState extends State<VerifyUserPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nationcodeController = TextEditingController();
  final TextEditingController mobilenoController = TextEditingController();

  bool _isOTPLoading = false; // لودینگ دکمه OTP
  //String? _serverError; // پیام خطای سرور

  @override
  void dispose() {
    nationcodeController.dispose();
    mobilenoController.dispose();
    super.dispose();
  }

  Future<void> _handleVerifyUser() async {
    if (!_formKey.currentState!.validate()) return; // اجرای ولیدیشن‌ها

    final nationcode = nationcodeController.text.trim();
    final mobileno = mobilenoController.text.trim();

    setState(() {
      _isOTPLoading = true;
      //_serverError = null;
    });

    try {
      final data = await apiVerifyUser(
        nationcode: nationcode,
        mobileno: mobileno,
      );
      if (!mounted) return;

      if (data['returnValue'] == 1) {
        await Navigator.pushReplacementNamed(
          context,
          '/getotp',
          arguments: {'userId': data['userId'], 'serverOtp': data['otpCode']},
        );
        if (!mounted) return;
      } else {
        showTopSnackBar(context, 2, 3, data['returnMessage']);
      }
    } catch (e) {
      String errText = errorTracking(e.toString());
      showTopSnackBar(context, 2, 3, errText);
    } finally {
      if (mounted) {
        setState(() {
          _isOTPLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      //backgroundColor: Colors.black,
      appBar: AppBar(
        //backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          color: Theme.of(context).textTheme.bodyMedium?.color,
          icon: Icon(Icons.close), // آیکون ضربدر برای بسته شدن صفحه
          onPressed: () {
            Navigator.pop(context); // برمی‌گرده به صفحه قبل
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Form(
            key: _formKey,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/logo.png', height: 100),
                    const SizedBox(height: 10),
                    Text(
                      "Verify User",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Please enter your information to get OTP",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w100,
                        letterSpacing: 0.3,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                    const SizedBox(height: 50),

                    // National Id Field
                    TextFormField(
                      controller: nationcodeController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      decoration: InputDecoration(
                        hintText: "National ID",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 46, 46, 46),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(87, 0, 187, 212),
                            width: 2.5,
                          ),
                        ),
                        errorStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w100,
                          height: 1.5,
                        ),
                      ),
                      validator: (value) {
                        if ((value?.trim() ?? '').isEmpty) {
                          return "Please enter your National ID.";
                        }
                        if (!RegExp(r'^[0-9]{10}$').hasMatch(value!.trim())) {
                          return "The National ID format is incorrect.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    //Phone number field
                    TextFormField(
                      controller: mobilenoController,
                      keyboardType: TextInputType.phone,
                      maxLength: 11,
                      decoration: InputDecoration(
                        hintText: "Phone Number",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 46, 46, 46),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(87, 0, 187, 212),
                            width: 2.5,
                          ),
                        ),
                        errorStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w100,
                          height: 1.5,
                        ),
                      ),
                      validator: (value) {
                        if ((value?.trim() ?? '').isEmpty) {
                          return "Please enter your Phone Number.";
                        }
                        if (!RegExp(r'^09\d{9}$').hasMatch(value!.trim())) {
                          return "The Phone Number format is incorrect.";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 30),

                    //Recive OTP Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          disabledBackgroundColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _isOTPLoading ? null : _handleVerifyUser,
                        //onPressed: _isOTPLoading ? null : _handleVerifyUser,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Get verification code",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            if (_isOTPLoading) ...[
                              const SizedBox(width: 12),
                              const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
