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
      throw Exception('Api call error : ${response.statusCode}');
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
      throw Exception('Api call error : ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('$e');
  }
}

Future<Map<String, dynamic>> apiVerifyPerson({
  required String nationcode,
  required String mobileno,
}) async {
  final url = Uri.https(mainAddress, 'api/crm/person-verify', {
    'NationCode': nationcode,
    'MobileNo': mobileno,
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

Future<Map<String, dynamic>> apiVerifyUser({
  required String nationcode,
  required String mobileno,
}) async {
  final url = Uri.https(mainAddress, 'api/user/user-verify', {
    'NationCode': nationcode,
    'MobileNo': mobileno,
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

Future<Map<String, dynamic>> apiGetNewToken({
  required String refreshtoken,
}) async {
  final url = Uri.https(mainAddress, '/api/user/newtoken', {
    'RefreshToken': refreshtoken,
  });
  appLog(url.toString());

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Api call error : ${response.statusCode}');
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
      throw Exception('Api call error : ${response.statusCode}');
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
      throw Exception('Api call error : ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('$e');
  }
}

Future<Map<String, dynamic>> apiSetPassword({
  required String userid,
  required String otpcode,
  required String newpassword,
}) async {
  final url = Uri.https(mainAddress, 'api/user/setpassword', {
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
      throw Exception('Api call error : ${response.statusCode}');
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
      throw Exception('Api call error : ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('$e');
  }
}

Future<List<Map<String, dynamic>>> apiMemberCredits({
  required String token,
  required String userid,
}) async {
  final url = Uri.https(mainAddress, 'api/dashboard/member-credits', {
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
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Api call error : ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('$e');
  }
}

Future<List<Map<String, dynamic>>> apiMemeberPackages({
  required String token,
  required String userid,
}) async {
  final url = Uri.https(mainAddress, 'api/dashboard/member-packages', {
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
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Api call error : ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('$e');
  }
}
