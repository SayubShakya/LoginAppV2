import 'package:dio/dio.dart';
import 'package:loginappv2/src/features/authentication/services/api_client.dart';

import '../models/model_property.dart';

class PropertyService {
  final Dio _dio = ApiClient().dio;

  Future<List<PropertyModel>> getProperties({int page = 1, int limit = 5}) async {
    try {
      final response = await _dio.get("/properties", queryParameters: {
        "page": page,
        "limit": limit,
      });

      print("Response data: ${response.data}");

      if (response.statusCode == 200) {
        List data = response.data["data"];
        return data.map((json) => PropertyModel.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load properties: ${response.statusCode}");
      }
    } catch (e) {
      print("PropertyService error: $e");
      rethrow;
    }
  }
}
