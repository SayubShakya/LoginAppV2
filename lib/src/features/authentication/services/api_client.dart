// dart
import 'package:dio/dio.dart';
import 'package:loginappv2/src/features/authentication/services/token_manager.dart';

class ApiClient {
  ApiClient._internal() {
    _init();
  }

  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  late final Dio dio;

  void _init() {
    final baseOptions = BaseOptions(
      // Ensure this is correct for your environment (localhost works on web/emulator,
      // but may need the host device IP for physical devices)
      baseUrl: 'http://localhost:5000/api',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    dio = Dio(baseOptions);

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            // 1. Fetch the token asynchronously
            final token = await TokenManager().getAccessToken();

            // ignore: avoid_print
            print('Interceptor fetched token: ${token != null ? "[REDACTED]" : "null"}');

            // 2. Set the Authorization header if a token exists
            if (token != null && token.isNotEmpty) {
              // Standard header name is 'Authorization' (case-sensitive)
              options.headers['Authorization'] = 'Bearer $token';

              // ⚠️ REFINEMENT: Remove the redundant fallback header.
              // Most modern servers respect the standard capitalization.
              // If the standard header is set, we ensure the fallback is removed
              // or simply rely on the capitalized one.
              // options.headers.remove('authorization');
            } else {
              // Ensure no Authorization header is present if token is null
              options.headers.remove('Authorization');
              options.headers.remove('authorization');
            }

            // ignore: avoid_print
            print('Request -> ${options.method} ${options.uri} headers: ${options.headers}');
          } catch (e) {
            // ignore: avoid_print
            print('Error retrieving token in interceptor: $e');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // ignore: avoid_print
          print('Response <- ${response.statusCode} ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (DioException err, handler) async {
          if (err.response?.statusCode == 401) {
            // ignore: avoid_print
            print('Received 401 from ${err.requestOptions.path}. Clearing token.');

            // ⚠️ BEST PRACTICE: Clear token on 401 (Unauthorized) response
            // This is crucial for security and forcing a re-login.
            await TokenManager().clearAccessToken();

            // Optional: You could use Get.offAll to navigate back to the login screen here
            // Get.offAllNamed(Routes.LOGIN);
          }
          // The error type is DioException now, not DioError
          return handler.next(err);
        },
      ),
    );
  }
}