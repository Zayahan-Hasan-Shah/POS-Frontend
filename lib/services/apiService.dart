import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pos_frontend/models/signupModel/signupEntity.dart';

class ApiService {
  // If using Android Emulator
  static const String baseUrl =
      'http://10.0.2.2:8000'; // This maps to 127.0.0.1 on your host machine

  // If using iOS Simulator
  // static const String baseUrl = 'http://127.0.0.1:8000';

  // If using physical device
  // static const String baseUrl = 'http://YOUR_MACHINE_IP:8000';

  // SignUp API call
  Future<http.Response> signup(SignupEntity signupData) async {
    final url = Uri.parse('$baseUrl/auth/signup');
    print('-----Attempting to connect to: $url----');
    print('-----Request body: ${jsonEncode(signupData.toJson())}----');

    try {
      final response = await http.post(
        url,
        body: jsonEncode(signupData.toJson()),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      print('-----Response body----${response.body}');
      print('-----Response status code----${response.statusCode}');
      return response;
    } catch (e) {
      print('-----Error during API call----');
      print('Error type: ${e.runtimeType}');
      print('Error details: $e');
      rethrow;
    }
  }
}
