import 'package:r8fitness/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:r8fitness/services/cache_service.dart';
import 'dart:convert';
import 'dart:typed_data';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final storage = const FlutterSecureStorage();
  bool isLoading = false;
  String userId = '';
  String userFName = '';
  String userLName = '';
  String userPhoto = '';
  Uint8List? imageBytes;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      await CacheService.instance.load();

      final accessToken = await storage.read(key: 'access_token');
      if (!mounted) return;
      userId = CacheService.instance.userId.toString();
      userFName = CacheService.instance.userFirstName.toString();
      userLName = CacheService.instance.userLastName.toString();
      userPhoto = CacheService.instance.userPhoto.toString();

      if (userId == '' && accessToken == null) return;

      setState(() {
        isLoading = false;
        if (userPhoto != '') imageBytes = base64Decode(userPhoto);
      });
    } catch (e) {
      String errText = errorTracking(e.toString());
      showAnimateTopSnackBar(context, 2, 3, errText);
      appLog('error : $errText');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _exit() async {
    await storage.deleteAll();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/main');
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
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[200],
              backgroundImage: imageBytes != null
                  ? MemoryImage(imageBytes!)
                  : null,
              child: imageBytes == null
                  ? const Icon(Icons.person, size: 50, color: Colors.grey)
                  : null,
            ),
            const SizedBox(height: 12),
            Text(
              '$userFName $userLName',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),
            const Text(
              'Do want to exit this account ?',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                disabledBackgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                _exit();
              },
              child: Text(
                "EXIT",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
