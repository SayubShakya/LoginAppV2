/// Defines the data structure for a single property.
class Property {
  final String id;
  final String propertyTitle;
  final String detailedDescription;
  final String uploadPhotoUrl;
  final double rent;
  final String rentalPeriod;
  final String size;
  final String status;
  final String locationId;
  final String propertyTypesId;
  final DateTime createdDate;
  final DateTime updatedDate;
  final bool isActive;

  Property({
    required this.id,
    required this.propertyTitle,
    required this.detailedDescription,
    required this.uploadPhotoUrl,
    required this.rent,
    required this.rentalPeriod,
    required this.size,
    required this.status,
    required this.locationId,
    required this.propertyTypesId,
    required this.createdDate,
    required this.updatedDate,
    required this.isActive,
  });

  /// Factory constructor to create a Property instance from a Map (e.g., JSON response from the API).
  factory Property.fromJson(Map<String, dynamic> data) {
    return Property(
      id: data['id'] ?? 'N/A',
      propertyTitle: data['property_title'] ?? 'N/A',
      detailedDescription: data['detailed_description'] ?? '',
      uploadPhotoUrl: data['upload_photo_url'] ?? 'https://placehold.co/100x100/7F9CF5/ffffff?text=Property',
      rent: (data['rent'] as num?)?.toDouble() ?? 0.0,
      rentalPeriod: data['rental_period'] ?? 'Monthly',
      size: data['size'] ?? '0 sqft',
      status: data['status'] ?? 'Available',
      locationId: data['location_id'] ?? 'Unknown',
      propertyTypesId: data['property_types_id'] ?? 'Apartment',
      createdDate: data['created_date'] is String
          ? DateTime.parse(data['created_date'])
          : (data['created_date'] ?? DateTime.now()),
      updatedDate: data['updated_date'] is String
          ? DateTime.parse(data['updated_date'])
          : (data['updated_date'] ?? DateTime.now()),
      isActive: data['is_active'] ?? true,
    );
  }

  /// Converts the Property instance to a Map for storage or API transmission.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'property_title': propertyTitle,
      'detailed_description': detailedDescription,
      'upload_photo_url': uploadPhotoUrl,
      'rent': rent,
      'rental_period': rentalPeriod,
      'size': size,
      'status': status,
      'location_id': locationId,
      'property_types_id': propertyTypesId,
      'created_date': createdDate.toIso8601String(),
      'updated_date': updatedDate.toIso8601String(),
      'is_active': isActive,
    };
  }

  // Utility method for creating an immutable copy of the property, useful for updates.
  Property copyWith({
    String? id,
    String? propertyTitle,
    String? detailedDescription,
    String? uploadPhotoUrl,
    double? rent,
    String? rentalPeriod,
    String? size,
    String? status,
    String? locationId,
    String? propertyTypesId,
    DateTime? updatedDate,
    bool? isActive, required DateTime createdDate,
  }) {
    return Property(
      id: id ?? this.id,
      propertyTitle: propertyTitle ?? this.propertyTitle,
      detailedDescription: detailedDescription ?? this.detailedDescription,
      uploadPhotoUrl: uploadPhotoUrl ?? this.uploadPhotoUrl,
      rent: rent ?? this.rent,
      rentalPeriod: rentalPeriod ?? this.rentalPeriod,
      size: size ?? this.size,
      status: status ?? this.status,
      locationId: locationId ?? this.locationId,
      propertyTypesId: propertyTypesId ?? this.propertyTypesId,
      createdDate: this.createdDate,
      updatedDate: updatedDate ?? DateTime.now(),
      isActive: isActive ?? this.isActive,
    );
  }
}