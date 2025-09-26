import 'dart:convert'; // برای تبدیل JSON
import 'package:http/http.dart' as http;
import 'package:r8fitness/utils/utils.dart';

const mainAddress = "api.r8fitness.ir";

Future<Map<String, dynamic>> apiLogin({
  required String userid,
  required String password,
}) async {
  final url = Uri.https(mainAddress, 'api/user/login', {
    'UserId': userid,
    'Password': password,
  });
  appLog(url.toString());

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('api error: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('$e');
  }
}

Future<Map<String, dynamic>> apiNFCLogin({required String tagno}) async {
  final url = Uri.https(mainAddress, 'api/user/nfclogin', {'TagNo': tagno});
  appLog(url.toString());

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('api error: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('$e');
  }
}

Future<Map<String, dynamic>> refreshToken({
  required String refreshtoken,
}) async {
  final url = Uri.https(mainAddress, 'api/user/token', {
    'RefreshToken': refreshtoken,
  });
  appLog(url.toString());

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('api error: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('$e');
  }
}

Future<Map<String, dynamic>> apiForgotPassword({
  required String nationcode,
  required String mobileno,
}) async {
  final url = Uri.https(mainAddress, 'api/user/forgotpass', {
    'Nationcode': nationcode,
    'Mobileno': mobileno,
  });
  appLog(url.toString());

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Api service call error: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Service call error: $e');
  }
}

Future<Map<String, dynamic>> apiGetNewTokens({
  required String refreshtoken,
}) async {
  final url = Uri.https(mainAddress, '/api/token/getnew', {
    'RefreshToken': refreshtoken,
  });
  appLog(url.toString());

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('api error: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('$e');
  }
}

Future<Map<String, dynamic>> apiRegister({
  required String nationcode,
  required String mobileno,
}) async {
  final url = Uri.https(mainAddress, 'api/user/register', {
    'Nationcode': nationcode,
    'Mobileno': mobileno,
  });
  appLog(url.toString());

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('api error: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('$e');
  }
}

Future<Map<String, dynamic>> apiCehckOtp({
  required String personid,
  required String otpcode,
}) async {
  final url = Uri.https(mainAddress, 'api/user/checkotp', {
    'PersonId': personid,
    'OtpCode': otpcode,
  });
  appLog(url.toString());

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('api error: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('$e');
  }
}

Future<Map<String, dynamic>> apiChangePassword({
  required String userid,
  required String otpcode,
  required String newpassword,
}) async {
  final url = Uri.https(mainAddress, 'api/user/chgpass', {
    'UserId': userid,
    'OtpCode': otpcode,
    'NewPassword': newpassword,
  });
  appLog(url.toString());

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('api error: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('$e');
  }
}

Future<Map<String, dynamic>> apiUserInfo({required String userid}) async {
  final url = Uri.https(mainAddress, 'api/user/getinfo', {'UserId': userid});
  appLog(url.toString());

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('api error: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('$e');
  }
}

Future<List<Map<String, dynamic>>> apiCredits({
  required String token,
  required String userid,
}) async {
  final url = Uri.https(mainAddress, 'api/dashboard/credits', {
    'UserId': userid,
  });
  appLog(url.toString());

  try {
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );    
    if (response.statusCode == 200) {
      appLog('eee1 : ${response.statusCode}');
      final List<dynamic> data = jsonDecode(response.body);
      appLog('eee2 : ${data.toString()}');
      return data.cast<Map<String, dynamic>>();
    } else {
      appLog('eee1 : ${response.statusCode}');
      throw Exception('api error: ${response.statusCode}');
    }
  } catch (e) {
    appLog('eee5 : $e');
    throw Exception('$e');
  }
}