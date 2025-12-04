import 'package:dio/dio.dart';
import 'package:loginappv2/src/features/authentication/services/api_client.dart';

class BookingService {
  final Dio _dio = ApiClient().dio;

  Future<Map<String, dynamic>> createBooking({
    required String propertyId,
    required DateTime startDate,
    required DateTime endDate,
    bool isActive = true,
  }) async {
    try {
      // Format dates as YYYY-MM-DD
      final formattedStartDate = "${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}";
      final formattedEndDate = "${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}";

      final response = await _dio.post(
        '/bookings',
        data: {
          'property_id': propertyId,
          'start_date': formattedStartDate,
          'end_date': formattedEndDate,
          'is_active': isActive,
        },
      );

      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data;
        throw Exception(errorData['error'] ?? 'Booking failed');
      }
      rethrow;
    }
  }
}