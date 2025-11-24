import 'package:dio/dio.dart';
import 'package:loginappv2/src/features/authentication/models/login_response_model.dart';

class AuthService {
  final Dio _dio = Dio();

  Future<LoginResponseModel> loginUser(String email, String password) async {
    try {
      final response = await _dio.post(
        'http://localhost:5000/api/auth/token',
        data: {
          "email_address": email,
          "password": password,
        },
      );

      if (response.statusCode == 200) {
        return LoginResponseModel.fromJson(response.data);
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
