import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:r8fitness/utils/utils.dart';
import 'package:r8fitness/services/api_service.dart';
import 'package:r8fitness/services/storage_service.dart';
import 'package:r8fitness/services/cache_service.dart';
import 'package:r8fitness/login/nfcreader_page.dart';
import 'package:r8fitness/login/forgotpass_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoginLoading = false; // لودینگ دکمه لاگین
  bool _isNfcLoading = false; // لودینگ دکمه NFC
  bool _obscurePassword = true;
  String? _serverError; // پیام خطای سرور

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin(bool isNfc, String tagno) async {
    if (isNfc == false) {
      if (!_formKey.currentState!.validate()) return; // اجرای ولیدیشن‌ها
    }

    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    setState(() {
      if (isNfc) {
        _isNfcLoading = true;
      } else {
        _isLoginLoading = true;
      }
      _serverError = null;
    });

    try {
      final Map<String, dynamic> data;
      if (!isNfc) {
        data = await apiLogin(userid: username, password: password);
      } else {
        data = await apiNFCLogin(tagno: tagno);
      }
      if (!mounted) return;
      if (data['returnValue'] == 1) {
        //ذخیره توکن ها
        final accessToken = data['accessToken'] ?? '';
        final refreshToken = data['refreshToken'] ?? '';
        await StorageService.instance.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );

        //ذخیره اطلاعات یوزر
        final int userId = data['userId'] ?? 0;
        final String userName = data['userName'] ?? '';
        final String userPhoto = data['userPhoto'] ?? '';
        await CacheService.instance.save(
          userId: userId,
          userName: userName,
          userPhoto: userPhoto,
        );

        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        showTopSnackBar(context, 2, 3, data['returnMessage']);
      }
    } catch (e) {
      showTopSnackBar(context, 2, 3, '$e');
    } finally {
      if (mounted) {
        setState(() {
          if (isNfc) {
            _isNfcLoading = false;
          } else {
            _isLoginLoading = false;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Form(
            key: _formKey,
            child: Center(
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                        MediaQuery.of(context).size.height -
                        MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/logo.png', height: 100),
                        const SizedBox(height: 10),
                        const Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 35),

                        // Username
                        TextFormField(
                          controller: usernameController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.person,
                              color: Colors.white70,
                            ),
                            hintText: "Memebr ID",
                            hintStyle: const TextStyle(color: Colors.white54),
                            filled: true,
                            fillColor: Colors.grey[900],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 46, 46, 46),
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(87, 0, 187, 212),
                                width: 2.5,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter your username.";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),

                        // Password
                        TextFormField(
                          controller: passwordController,
                          obscureText: _obscurePassword,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.white70,
                            ),
                            hintText: "Password",
                            hintStyle: const TextStyle(color: Colors.white54),
                            filled: true,
                            fillColor: Colors.grey[900],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 46, 46, 46),
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(87, 0, 187, 212),
                                width: 2.5,
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter the password.";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),

                        // فراموشی رمز
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () async {
                              await showCustomBottomSheet<String>(
                                context,
                                child: ForgotPassPage(),
                                heightFactor: 1,
                              );
                            },
                            child: const Text(
                              "Forgot password?",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00B8D4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              if (!_isLoginLoading) {
                                _handleLogin(false, "");
                              }
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "LOGIN",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                if (_isLoginLoading) ...[
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
                        const SizedBox(height: 15),

                        const Text(
                          "OR",
                          style: TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 15),

                        // NFC Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent, // رنگ ثابت
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: const BorderSide(
                                color: Color.fromARGB(179, 196, 195, 195),
                                width: 2,
                              ),
                            ),
                            onPressed: () async {
                              if (!_isNfcLoading) {
                                final result =
                                    await showCustomBottomSheet<String>(
                                      context,
                                      child: NFCReaderPage(),
                                      heightFactor: 0.68,
                                    );
                                if (!mounted) return;
                                if (result != null) {
                                  appLog(
                                    "TagNo that returned to Login page: $result",
                                  );
                                  _handleLogin(true, result.toString());
                                }
                              }
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.nfc_rounded,
                                  color: Colors.white,
                                  size: 25,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  "Login with NFC",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white,
                                  ),
                                ),
                                if (_isNfcLoading) ...[
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

                        const SizedBox(height: 35),

                        RichText(
                          text: TextSpan(
                            text: "Never logged in before ? ",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                            ),
                            children: [
                              TextSpan(
                                text: "Register",
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 0, 184, 212),
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    //وقتی کلیک شد اینجا می‌ره
                                    Navigator.pushNamed(context, '/register');
                                  },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        if (_serverError != null) ...[
                          const SizedBox(height: 20),
                          Text(
                            _serverError!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
