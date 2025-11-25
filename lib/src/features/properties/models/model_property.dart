// dart
import 'package:loginappv2/src/features/authentication/models/user_model.dart';
import 'package:loginappv2/src/features/image_handle/image_handle_model.dart';
import 'package:loginappv2/src/features/property_type/property_type_model.dart';
import 'package:loginappv2/src/features/status/status_model.dart';
import 'package:loginappv2/src/features/user_dashboard/services/property_service.dart' hide PropertyTypeModel, LocationModel;
import '../../user_dashboard/models/location/model_location.dart';

class PropertyModel {
  final String id;
  final String propertyTitle;
  final String detailedDescription;
  final int rent;
  final bool isActive;
  final ImageModel image;
  final LocationModel location;
  final UserModel user;
  final PropertyTypeModel propertyType;
  final StatusModel status;
  final DateTime createdDate;
  final DateTime updatedDate;

  PropertyModel({
    required this.id,
    required this.propertyTitle,
    required this.detailedDescription,
    required this.rent,
    required this.isActive,
    required this.image,
    required this.location,
    required this.user,
    required this.propertyType,
    required this.status,
    required this.createdDate,
    required this.updatedDate,
  });

  static Map<String, dynamic> _normalize(Map? m) {
    if (m == null) return <String, dynamic>{};
    final map = Map<String, dynamic>.from(m);
    if (map.containsKey('_id') && !map.containsKey('id')) {
      map['id'] = map['_id'];
    }
    return map;
  }

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    final imageJson = _normalize(json['image_id'] as Map?);
    final userJson = _normalize(json['user_id'] as Map?);
    final propertyTypeJson = _normalize(json['property_types_id'] as Map?);
    final locationJson = _normalize(json['location'] as Map?);

    final statusRaw = json['status_id'];
    final statusJson = statusRaw is String ? {'id': statusRaw} : _normalize(statusRaw as Map?);

    return PropertyModel(
      id: json['id'] ?? json['_id'] ?? '',
      propertyTitle: json['property_title'] ?? '',
      detailedDescription: json['detailed_description'] ?? '',
      rent: (json['rent'] is int) ? json['rent'] as int : int.tryParse('${json['rent']}') ?? 0,
      isActive: json['is_active'] ?? false,
      image: ImageModel.fromJson(imageJson),
      location: LocationModel.fromJson(locationJson),
      user: UserModel.fromJson(userJson),
      propertyType: PropertyTypeModel.fromJson(propertyTypeJson),
      status: StatusModel.fromJson(statusJson),
      createdDate: DateTime.tryParse(json['created_date'] ?? '') ?? DateTime.now(),
      updatedDate: DateTime.tryParse(json['updated_date'] ?? '') ?? DateTime.now(),
    );
  }
}
