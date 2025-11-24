// lib/src/features/location/models/location_model.dart

import 'package:flutter/foundation.dart';

@immutable
class LocationModel {
  final String id;
  final String? streetAddress;
  final String? areaName;
  final String city;
  final String? postalCode;
  final double latitude;
  final double longitude;
  final bool isActive;
  final DateTime createdDate;
  final DateTime updatedDate;

  const LocationModel({
    required this.id,
    this.streetAddress,
    this.areaName,
    required this.city,
    this.postalCode,
    required this.latitude,
    required this.longitude,
    required this.isActive,
    required this.createdDate,
    required this.updatedDate,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] as String,
      streetAddress: json['street_address'] as String?,
      areaName: json['area_name'] as String?,
      city: json['city'] as String,
      postalCode: json['postal_code'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      isActive: json['is_active'] as bool,
      createdDate: DateTime.parse(json['created_date'] as String),
      updatedDate: DateTime.parse(json['updated_date'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'street_address': streetAddress,
    'area_name': areaName,
    'city': city,
    'postal_code': postalCode,
    'latitude': latitude,
    'longitude': longitude,
    'is_active': isActive,
    'created_date': createdDate.toIso8601String(),
    'updated_date': updatedDate.toIso8601String(),
  };
}
