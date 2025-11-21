import 'package:flutter/material.dart';

class PropertyModel {
  // Data types inferred from the property names
  int? id;
  String? property_title;
  String? detailed_description;
  String? upload_photo_url;
  num? rent; // num for flexibility (int/double)
  String? rental_period;
  String? size;
  String? status;

  // Foreign Keys (usually integers)
  int? user_id;
  int? location_id;
  int? property_types_id;

  // Date fields (usually Strings from the API)
  String? created_date;
  String? updated_date;

  // Boolean field (usually int or bool)
  bool? is_active;

  PropertyModel({
    this.id,
    this.property_title,
    this.detailed_description,
    this.upload_photo_url,
    this.rent,
    this.rental_period,
    this.size,
    this.status,
    this.user_id,
    this.location_id,
    this.property_types_id,
    this.created_date,
    this.updated_date,
    this.is_active,
  });

  PropertyModel.fromJson(Map<String, dynamic> json) {
    // Note: The field names here must exactly match the keys in the API response JSON.
    id = json['id'];
    property_title = json['property_title'];
    detailed_description = json['detailed_description'];
    upload_photo_url = json['upload_photo_url'];
    rent = json['rent'];
    rental_period = json['rental_period'];
    size = json['size'];
    status = json['status'];
    user_id = json['user_id'];
    location_id = json['location_id'];
    property_types_id = json['property_types_id'];
    created_date = json['created_date'];
    updated_date = json['updated_date'];
    is_active = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['property_title'] = this.property_title;
    data['detailed_description'] = this.detailed_description;
    data['upload_photo_url'] = this.upload_photo_url;
    data['rent'] = this.rent;
    data['rental_period'] = this.rental_period;
    data['size'] = this.size;
    data['status'] = this.status;
    data['user_id'] = this.user_id;
    data['location_id'] = this.location_id;
    data['property_types_id'] = this.property_types_id;
    data['created_date'] = this.created_date;
    data['updated_date'] = this.updated_date;
    data['is_active'] = this.is_active;
    return data;
  }
}