import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/property_model.dart';

class PropertyService {
  final String _baseUrl = "http://localhost:5000/api/properties";
  final String _uploadImageUrl = "http://localhost:5000/api/images/upload-image";
  final String _locationsUrl = "http://localhost:5000/api/locations?page=1&limit=50";
  final String _propertyTypesUrl = "http://localhost:5000/api/property-types?page=1&limit=50";
  final String _statusesUrl = "http://localhost:5000/api/statuses?page=1&limit=50"; // Optional if your backend provides statuses

  // Helper for API Headers
  Map<String, String> _getHeaders({bool isMultipart = false}) {
    if (isMultipart) return {};
    return {'Content-Type': 'application/json; charset=UTF-8'};
  }

  // --- Create Property ---
  Future<PropertyModel?> createProperty(PropertyModel property) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: _getHeaders(),
        body: jsonEncode(property.toJson()),
      );

      if (response.statusCode == 201) {
        return PropertyModel.fromJson(jsonDecode(response.body));
      } else {
        print('Failed to create property: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error creating property: $e');
      return null;
    }
  }

  // --- Upload Image ---
  Future<Map<String, dynamic>?> uploadImage(String imagePath) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(_uploadImageUrl),
      );

      request.files.add(await http.MultipartFile.fromPath('image', imagePath));

      var response = await request.send();
      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final Map<String, dynamic> data = jsonDecode(respStr);
        // Return full image object with 'image_id' and 'path'
        return data;
      } else {
        print('Failed to upload image: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // --- Fetch Locations ---
  Future<List<LocationModel>> getLocations({int page = 1, int limit = 50}) async {
    try {
      final response = await http.get(Uri.parse("$_locationsUrl&page=$page&limit=$limit"),
          headers: _getHeaders());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'] as List;
        return data.map((json) => LocationModel.fromJson(json)).toList();
      } else {
        print('Failed to fetch locations: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching locations: $e');
      return [];
    }
  }

  // --- Fetch Property Types ---
  Future<List<PropertyTypeModel>> getPropertyTypes({int page = 1, int limit = 50}) async {
    try {
      final response = await http.get(Uri.parse("$_propertyTypesUrl&page=$page&limit=$limit"),
          headers: _getHeaders());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'] as List;
        return data.map((json) => PropertyTypeModel.fromJson(json)).toList();
      } else {
        print('Failed to fetch property types: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching property types: $e');
      return [];
    }
  }

  // --- Fetch Statuses (if backend provides) ---
  Future<List<StatusModel>> getStatuses({int page = 1, int limit = 50}) async {
    try {
      final response = await http.get(Uri.parse("$_statusesUrl&page=$page&limit=$limit"),
          headers: _getHeaders());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'] as List;
        return data.map((json) => StatusModel.fromJson(json)).toList();
      } else {
        print('Failed to fetch statuses: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching statuses: $e');
      return [];
    }
  }
}

// --- Models for Location, PropertyType, Status ---
class LocationModel {
  final String id;
  final String city;
  final String areaName;

  LocationModel({required this.id, required this.city, required this.areaName});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'],
      city: json['city'] ?? '',
      areaName: json['area_name'] ?? '',
    );
  }
}

class PropertyTypeModel {
  final String id;
  final String name;

  PropertyTypeModel({required this.id, required this.name});

  factory PropertyTypeModel.fromJson(Map<String, dynamic> json) {
    return PropertyTypeModel(
      id: json['id'],
      name: json['name'] ?? '',
    );
  }
}

class StatusModel {
  final String id;
  final String name;

  StatusModel({required this.id, required this.name});

  factory StatusModel.fromJson(Map<String, dynamic> json) {
    return StatusModel(
      id: json['id'],
      name: json['name'] ?? '',
    );
  }
}
