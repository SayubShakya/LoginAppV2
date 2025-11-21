import 'package:flutter/material.dart';
import 'package:loginappv2/src/features/properties/models/model_property.dart';
class PropertyApi {
  // Assuming a status field might still be useful, or can be removed if not present.
  String? status;

  // totalResults replaced by a count of total properties, if the API provides it.
  int? totalProperties;


  List<PropertyModel>? properties;

  PropertyApi({this.status, this.totalProperties, this.properties});

  PropertyApi.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalProperties = json['totalProperties']; // Update key if needed
    if (json['properties'] != null) {
      properties = <PropertyModel>[];
      json['properties'].forEach((v) {
        properties!.add(new PropertyModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['totalProperties'] = this.totalProperties;
    if (this.properties != null) {
      data['properties'] = this.properties!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}