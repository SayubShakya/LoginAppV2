
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/property_model.dart';

class PropertyService {
  final String _baseUrl = "http://localhost:5000/api/properties"; // **IMPORTANT: Replace with your actual backend URL**
  final String _uploadImageUrl = 'YOUR_BACKEND_API_URL/api/upload-image'; // **IMPORTANT: Replace with your image upload endpoint**

  // Helper for API Headers (e.g., for authentication)
  Map<String, String> _getHeaders({bool isMultipart = false}) {
    // You'll likely need to add an Authorization token here
    // e.g., String? token = Get.find<AuthController>().token;
    // if (token != null) headers['Authorization'] = 'Bearer $token';

    if (isMultipart) {
      // No Content-Type for multipart requests; http package handles it
      return {};
    } else {
      return {'Content-Type': 'application/json; charset=UTF-8'};
    }
  }

  Future<PropertyModel?> createProperty(PropertyModel property) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: _getHeaders(),
        body: jsonEncode(property.toJson()),
      );

      if (response.statusCode == 201) { // 201 Created
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

  // Method to upload an image and get its URL back
  Future<String?> uploadImage(String imagePath) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(_uploadImageUrl),
      );
      // Add authentication headers if needed
      // request.headers.addAll(_getHeaders(isMultipart: true));

      request.files.add(await http.MultipartFile.fromPath('image', imagePath)); // 'image' should match your backend's expected field name

      var response = await request.send();
      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final Map<String, dynamic> data = jsonDecode(respStr);
        // Assuming your backend returns a JSON with the URL, e.g., {'imageUrl': 'http://...'}
        return data['imageUrl']; // **IMPORTANT: Adjust 'imageUrl' to match your backend's response key**
      } else {
        print('Failed to upload image: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

// You can add other methods like fetchProperties, updateProperty, deleteProperty etc.
}