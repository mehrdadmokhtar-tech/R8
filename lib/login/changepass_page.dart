import 'package:flutter/material.dart';
import 'package:r8fitness/utils/utils.dart';
import 'package:r8fitness/services/api_service.dart';

class ChangePassPage extends StatefulWidget {
  const ChangePassPage({super.key});

  @override
  State<ChangePassPage> createState() => _ChangePassPageState();
}

class _ChangePassPageState extends State<ChangePassPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _handleSaveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    final newPassword = _newPasswordController.text.trim();
    final confirmnewPassword = _confirmNewPasswordController.text.trim();

    if (newPassword != confirmnewPassword) {
      // اگر پسوردها یکسان نبود
      showTopSnackBar(
        context,
        2,
        3,
        "Password and Repeat password don't match.",
      );
      return;
    }

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
      }
    } catch (e) {
      showTopSnackBar(context, 2, 3, '$e');
    }
    // appLog(args['userId'].toString());
    // appLog(args['serverOtp'].toString());

    try {
      final data = await apiChangePassword(
        userid: args['userId'].toString(),
        otpcode: args['serverOtp'].toString(),
        newpassword: newPassword,
      );
      if (!mounted) return;

      if (data['returnValue'] == 1) {
        showTopSnackBar(context, 1, 3, data['returnMessage']);
        // بعد از 5 ثانیه این صفحه رو ببند و برگرد به صفحه ی اصلی
        Future.delayed(const Duration(seconds: 5), () {
          if (!mounted) return;
          Navigator.of(context).pop();
        });
      } else {
        showTopSnackBar(context, 2, 3, data['returnMessage']);
      }
    } catch (e) {
      showTopSnackBar(context, 2, 3, '$e');
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
        padding: EdgeInsetsGeometry.symmetric(horizontal: 35),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Change Password",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              const Text(
                "Create new password for your account.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),

              SizedBox(height: 30),

              // فیلد رمز عبور
              TextFormField(
                controller: _newPasswordController,
                obscureText: _obscurePassword,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "New Password",
                  labelStyle: const TextStyle(
                    color: Colors.white54,
                    fontSize: 18,
                  ),
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
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your new password.';
                  }
                  if (value.length < 6) {
                    return 'Password needs to be at least 6 characters.';
                  }
                  return null;
                },
              ),

              SizedBox(height: 20),

              // فیلد تکرار رمز عبور
              TextFormField(
                controller: _confirmNewPasswordController,
                obscureText: _obscureConfirmPassword,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Re-enter your password",
                  labelStyle: const TextStyle(
                    color: Colors.white54,
                    fontSize: 18,
                  ),
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
                      _obscureConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your new password.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // دکمه ذخیره تغییرات
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _handleSaveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00B8D4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Save Changes",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
