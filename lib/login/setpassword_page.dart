import 'package:flutter/material.dart';
import 'package:r8fitness/utils/utils.dart';
import 'package:r8fitness/services/api_service.dart';

class SetPasswordPage extends StatefulWidget {
  const SetPasswordPage({super.key});

  @override
  State<SetPasswordPage> createState() => _SetPasswordPageState();
}

class _SetPasswordPageState extends State<SetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isSaveLoading = false;

  Future<void> _handleSaveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    final newPassword = _newPasswordController.text.trim();
    final confirmnewPassword = _confirmNewPasswordController.text.trim();

    setState(() {
      _isSaveLoading = true;
    });

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
        return;
      }
    } catch (e) {
      String errText = errorTracking(e.toString());
      showTopSnackBar(context, 2, 3, errText);
    }
    //appLog(args['userId'].toString());
    //appLog(args['otpCode'].toString());

    try {
      String reqBy = args['requestBy'].toString();
      String uId = args['userId'].toString();
      String uOtp = args['otpCode'].toString();

      Map<String, dynamic> data = {};
      if (reqBy == 'register') {
        data = await apiRegister(
          personid: uId,
          otpcode: uOtp,
          password: newPassword,
        );
      } else {
        if (reqBy == 'forgotpass') {
          data = await apiSetPassword(
            userid: uId,
            otpcode: uOtp,
            newpassword: newPassword,
          );
        }
      }
      if (!mounted) return;

      if (data['returnValue'] == 1) {
        showTopSnackBar(context, 1, 4, data['returnMessage']);
        Future.delayed(const Duration(seconds: 4), () {
          if (!mounted) return;
          Navigator.pop(context, {'result': true});
        });
      } else {
        showTopSnackBar(context, 2, 3, data['returnMessage']);
      }
    } catch (e) {
      String errText = errorTracking(e.toString());
      showTopSnackBar(context, 2, 3, errText);
    } finally {
      if (mounted) {
        setState(() {
          _isSaveLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).textTheme.bodyMedium?.color,
        ),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 35),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Set Password",
                style: TextStyle(
                  color: Theme.of(context).textTheme.titleLarge?.color,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Text(
                "Create new password for your account.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  fontSize: 14,
                ),
              ),

              SizedBox(height: 30),

              // فیلد رمز عبور
              TextFormField(
                controller: _newPasswordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "New Password",
                  labelStyle: const TextStyle(fontSize: 18),
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
                decoration: InputDecoration(
                  labelText: "Re-enter your password",
                  labelStyle: const TextStyle(fontSize: 18),
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
                  onPressed: _isSaveLoading
                      ? null
                      : () async {
                          setState(() {
                            _isSaveLoading = true;
                          });

                          await _handleSaveChanges();

                          setState(() {
                            _isSaveLoading = false;
                          });
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    disabledBackgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Save Changes",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      if (_isSaveLoading) ...[
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
    );
  }
}
