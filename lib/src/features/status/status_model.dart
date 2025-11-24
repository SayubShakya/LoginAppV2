import 'package:flutter/foundation.dart';

@immutable
class PropertyStatus {
  final String id;
  final String name;
  final bool isActive;
  final DateTime createdDate;
  final DateTime updatedDate;

  const PropertyStatus({
    required this.id,
    required this.name,
    required this.isActive,
    required this.createdDate,
    required this.updatedDate,
  });

  factory PropertyStatus.fromJson(Map<String, dynamic> json) {
    return PropertyStatus(
      id: json['id'] as String,
      name: json['name'] as String,
      isActive: json['is_active'] as bool,
      createdDate: DateTime.parse(json['created_date']),
      updatedDate: DateTime.parse(json['updated_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_active': isActive,
      'created_date': createdDate.toIso8601String(),
      'updated_date': updatedDate.toIso8601String(),
    };
  }
}

// Pagination Container Model
class PaginatedStatusResponse {
  final List<PropertyStatus> data;
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  PaginatedStatusResponse({
    required this.data,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory PaginatedStatusResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> statusJson = json['data'] ?? [];

    return PaginatedStatusResponse(
      data: statusJson.map((e) => PropertyStatus.fromJson(e)).toList(),
      page: json['page'],
      limit: json['limit'],
      total: json['total'],
      totalPages: json['totalPages'],
    );
  }
}
