// lib/src/features/booking/models/booking_response.dart
// Import your existing UserModel and StatusModel

import 'package:loginappv2/src/features/properties/models/model_property.dart';

class BookingResponse {
  final String message;
  final BookingData booking;

  BookingResponse({
    required this.message,
    required this.booking,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      message: json['message'],
      booking: BookingData.fromJson(json['booking']),
    );
  }
}

class BookingData {
  final String id;
  final PropertyModel property;
  final dynamic user; // Use your existing UserModel
  final DateTime startDate;
  final DateTime endDate;
  final dynamic status; // Use your existing StatusModel
  final double totalRent;
  final bool isActive;
  final DateTime createdDate;
  final DateTime updatedDate;

  BookingData({
    required this.id,
    required this.property,
    required this.user,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.totalRent,
    required this.isActive,
    required this.createdDate,
    required this.updatedDate,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      id: json['id'],
      property: PropertyModel.fromJson(json['property_id']),
      user: json['user_id'], // Parse with your UserModel.fromJson
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      status: json['status_id'], // Parse with your StatusModel.fromJson
      totalRent: (json['total_rent'] as num).toDouble(),
      isActive: json['is_active'],
      createdDate: DateTime.parse(json['created_date']),
      updatedDate: DateTime.parse(json['updated_date']),
    );
  }

  int get durationInMonths {
    final days = endDate.difference(startDate).inDays;
    return (days / 30).ceil();
  }
}