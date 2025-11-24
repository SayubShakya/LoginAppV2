import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loginappv2/src/utils/get_storage_key.dart';

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://localhost:5000/api",
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    ),
  )
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final storage = GetStorage();
          String? token = storage.read(GetStorageKey.accessToken);

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },
      ),
    );
}
