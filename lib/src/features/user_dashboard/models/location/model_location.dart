// lib/src/features/location/models/location_model.dart

import 'package:flutter/foundation.dart';

@immutable
class LocationModel {
  final String id;
  final String? streetAddress;
  final String? areaName;
  final String? city; // Made optional
  final String? postalCode;
  final double? latitude; // Made optional
  final double? longitude; // Made optional
  final bool? isActive; // Made optional
  final DateTime? createdDate; // Made optional
  final DateTime? updatedDate; // Made optional

  const LocationModel({
    required this.id,
    this.streetAddress,
    this.areaName,
    this.city,
    this.postalCode,
    this.latitude,
    this.longitude,
    this.isActive,
    this.createdDate,
    this.updatedDate,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      streetAddress: json['street_address']?.toString(),
      areaName: json['area_name']?.toString(),
      city: json['city']?.toString(),
      postalCode: json['postal_code']?.toString(),
      latitude: (json['latitude'] is num) ? (json['latitude'] as num).toDouble() : null,
      longitude: (json['longitude'] is num) ? (json['longitude'] as num).toDouble() : null,
      isActive: json['is_active'] as bool?,
      createdDate: DateTime.tryParse(json['created_date']?.toString() ?? ''),
      updatedDate: DateTime.tryParse(json['updated_date']?.toString() ?? ''),
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
    'created_date': createdDate?.toIso8601String(),
    'updated_date': updatedDate?.toIso8601String(),
  };
}