import 'package:loginappv2/src/features/authentication/models/user_model.dart';
import 'package:loginappv2/src/features/image_handle/image_handle_model.dart';
import 'package:loginappv2/src/features/property_type/property_type_model.dart';
import 'package:loginappv2/src/features/status/status_model.dart';
import 'package:loginappv2/src/features/user_dashboard/services/property_service.dart' hide PropertyTypeModel, LocationModel;
import '../../user_dashboard/models/location/model_location.dart';

class PropertyModel {
  final String id;
  final String? propertyTitle;
  final String? detailedDescription;
  final int? rent; // Made optional
  final bool? isActive; // Made optional
  final ImageModel? image; // Made optional
  final LocationModel? location; // Made optional
  final UserModel? user; // Made optional
  final PropertyTypeModel? propertyType; // Made optional
  final StatusModel? status; // Made optional
  final DateTime? createdDate; // Made optional
  final DateTime? updatedDate; // Made optional

  PropertyModel({
    required this.id,
    this.propertyTitle,
    this.detailedDescription,
    this.rent,
    this.isActive,
    this.image,
    this.location,
    this.user,
    this.propertyType,
    this.status,
    this.createdDate,
    this.updatedDate,
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
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      propertyTitle: json['property_title']?.toString(),
      detailedDescription: json['detailed_description']?.toString(),
      rent: (json['rent'] is int) ? json['rent'] as int : int.tryParse('${json['rent']}'),
      isActive: json['is_active'] as bool?,
      image: imageJson.isNotEmpty ? ImageModel.fromJson(imageJson) : null,
      location: locationJson.isNotEmpty ? LocationModel.fromJson(locationJson) : null,
      user: userJson.isNotEmpty ? UserModel.fromJson(userJson) : null,
      propertyType: propertyTypeJson.isNotEmpty ? PropertyTypeModel.fromJson(propertyTypeJson) : null,
      status: statusJson.isNotEmpty ? StatusModel.fromJson(statusJson) : null,
      createdDate: DateTime.tryParse(json['created_date']?.toString() ?? ''),
      updatedDate: DateTime.tryParse(json['updated_date']?.toString() ?? ''),
    );
  }
}