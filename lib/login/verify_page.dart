import 'package:flutter/material.dart';
import 'package:r8fitness/utils/utils.dart';
import 'package:r8fitness/services/api_service.dart';

class VerifyPage extends StatefulWidget {
  const VerifyPage({super.key});

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nationcodeController = TextEditingController();
  final TextEditingController mobilenoController = TextEditingController();

  bool _isVerifyLoading = false; // لودینگ دکمه Reister
  //String? _serverError; // پیام خطای سرور

  @override
  void dispose() {
    nationcodeController.dispose();
    mobilenoController.dispose();
    super.dispose();
  }

  Future<void> _handleVerify() async {
    if (!_formKey.currentState!.validate()) return; // اجرای ولیدیشن‌ها

    final nationcode = nationcodeController.text.trim();
    final mobileno = mobilenoController.text.trim();

    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    try {
      List<String> nullItems = findNullKeys(args);
      if (nullItems.isNotEmpty) {
        showTopSnackBar(
          context,
          2,
          3,
          'runtime error : args has null key ; $nullItems',
        );
        return;
      }
    } catch (e) {
      String errText = errorTracking(e.toString());
      showTopSnackBar(context, 2, 3, errText);
    }

    setState(() {
      _isVerifyLoading = true;
      //_serverError = null;
    });

    try {
      Map<String, dynamic> data = {};
      String reqBy = args['requestBy'].toString();
      if (reqBy == 'register') {
        data = await apiVerifyPerson(
          nationcode: nationcode,
          mobileno: mobileno,
        );
      } else {
        if (reqBy == 'forgotpass') {
          data = await apiVerifyUser(
            nationcode: nationcode,
            mobileno: mobileno,
          );
        }
      }
      if (!mounted) return;

      if (data['returnValue'] == 1) {
        String uId = (reqBy == 'register')
            ? data['personId'].toString()
            : data['userId'].toString();
        String uOtp = data['otpCode'].toString();

        final pushResult = await Navigator.pushNamed(
          context,
          '/getotp',
          arguments: {'userId': uId, 'otpCode': uOtp},
        );
        if (!mounted) return;

        if (pushResult != null &&
            pushResult is Map &&
            pushResult['result'].toString() == 'true') {
          final pushResult1 = await Navigator.pushNamed(
            context,
            '/setpass',
            arguments: {'requestBy': reqBy, 'userId': uId, 'otpCode': uOtp},
          );
          if (!mounted) return;

          if (pushResult1 != null &&
              pushResult1 is Map &&
              pushResult1['result'].toString() == 'true') {
            Navigator.of(context).pop();
          }
        }
      } else {
        showTopSnackBar(context, 2, 3, data['returnMessage']);
      }
    } catch (e) {
      String errText = errorTracking(e.toString());
      showTopSnackBar(context, 2, 3, errText);
    } finally {
      if (mounted) {
        setState(() {
          _isVerifyLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          color: Colors.white,
          icon: Icon(Icons.close), // آیکون ضربدر به جای فلش
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
                      "Verify Member",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Please enter your information to get OTP",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 0.3,
                        color: Colors.white60,
                      ),
                    ),
                    const SizedBox(height: 50),

                    // National Id Field
                    TextFormField(
                      controller: nationcodeController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "National ID",
                        hintStyle: TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: Colors.grey[900],
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
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Phone Number",
                        hintStyle: TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: Colors.grey[900],
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
                          backgroundColor: const Color(0xFF00B8D4),
                          disabledBackgroundColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _isVerifyLoading
                            ? null
                            : () async {
                                setState(() {
                                  _isVerifyLoading = true;
                                });

                                await _handleVerify();

                                setState(() {
                                  _isVerifyLoading = false;
                                });
                              },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Get verification code",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            if (_isVerifyLoading) ...[
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
