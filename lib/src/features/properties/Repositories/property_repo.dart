import 'dart:convert';
import 'package:http/http.dart' as http;

// Import the data models you created
// Adjust this path to match your actual file location

import 'package:loginappv2/src/features/properties/models/model_property.dart';
import 'package:loginappv2/src/features/properties/models/property_api.dart';

/// A repository class responsible for all network interactions related to properties.
class PropertyRepository {
  // Base URL for your API endpoint
  static const String _baseUrl = 'http://localhost:5000/api';

  // --- GET: Fetch all properties ---

  /// Retrieves a list of all properties from the API.
  Future<List<PropertyModel>> fetchAllProperties() async {
    final uri = Uri.parse(_baseUrl);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // Decode the response body (a JSON string) into a Dart Map/List.
        final jsonResponse = json.decode(response.body);

        // Assuming the API returns a structure that matches PropertyApi:
        // { "status": "ok", "totalProperties": 100, "properties": [...] }
        final propertyApi = PropertyApi.fromJson(jsonResponse);

        // Return the list of properties from the model
        return propertyApi.properties ?? [];
      } else {
        // Handle server errors (e.g., 404, 500)
        print('Failed to load properties. Status code: ${response.statusCode}');
        throw Exception('Failed to load properties: Server error');
      }
    } catch (e) {
      // Handle network or parsing errors
      print('Network/Parsing Error: $e');
      throw Exception('Failed to load properties: $e');
    }
  }

  // --- POST: Create a new property ---

  /// Sends a POST request to create a new property listing.
  Future<PropertyModel> createProperty(PropertyModel newProperty) async {
    final uri = Uri.parse(_baseUrl);

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        // Convert the Dart model back to a JSON string for the request body
        body: json.encode(newProperty.toJson()),
      );

      if (response.statusCode == 201) { // 201 Created is the standard success code for POST
        // Deserialize the response body (which usually contains the created object with its new ID)
        final jsonResponse = json.decode(response.body);
        return PropertyModel.fromJson(jsonResponse);
      } else {
        print('Failed to create property. Status code: ${response.statusCode}, Body: ${response.body}');
        throw Exception('Failed to create property: Server error');
      }
    } catch (e) {
      print('Network/Parsing Error: $e');
      throw Exception('Failed to create property: $e');
    }
  }

  // --- DELETE: Remove a property ---

  /// Sends a DELETE request to remove a property by ID.
  Future<void> deleteProperty(int id) async {
    final uri = Uri.parse('$_baseUrl/$id');

    try {
      final response = await http.delete(uri);

      if (response.statusCode == 204) { // 204 No Content is standard success for DELETE
        print('Property with ID $id deleted successfully.');
        return;
      } else if (response.statusCode == 404) {
        throw Exception('Property with ID $id not found.');
      } else {
        print('Failed to delete property. Status code: ${response.statusCode}');
        throw Exception('Failed to delete property: Server error');
      }
    } catch (e) {
      print('Network Error: $e');
      throw Exception('Failed to delete property: $e');
    }
  }

// You would also add PUT/PATCH methods here for updates
// Future<PropertyModel> updateProperty(PropertyModel updatedProperty) async { ... }
}