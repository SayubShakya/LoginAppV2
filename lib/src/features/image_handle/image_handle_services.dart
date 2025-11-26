// lib/src/features/image/services/image_service.dart

import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';
import 'dart:typed_data'; // Needed for Uint8List in the fetch method

class ImageService {
  // Use the IP address, replacing 'localhost'
  static const String _serverBaseUrl = 'http://10.10.10.35:5000';

  // Endpoint for POST (Uploading the image)
  static const String _uploadUrl = '$_serverBaseUrl/api/images/upload-image';

  // Base URL for GET (Fetching the image)
  // This matches the format: http://10.10.10.35:5000/uploads/filename.jpg
  static const String _fetchBaseUrl = '$_serverBaseUrl/uploads/';

  // --- 1. UPLOAD METHOD (Updated to return Filename) ---

  /// Uploads the image file and returns the filename from the server response.
  Future<String?> uploadImage(File imageFile) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(_uploadUrl));

      request.files.add(
        http.MultipartFile(
          'file', // Key must match the backend field name
          imageFile.readAsBytes().asStream(),
          imageFile.lengthSync(),
          filename: basename(imageFile.path),
        ),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        final decoded = jsonDecode(responseData);

        // **CRITICAL CHANGE:** Returning the filename, which is needed for fetching.
        // The JSON response contains: "image": { "filename": "..." }
        return decoded['image']['filename'] as String?;
      } else {
        print('Failed to upload image. Status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // --- 2. FETCH METHOD (NEW) ---

  /// Fetches the raw image bytes from the server using the provided filename.
  /// Returns null if fetching fails.
  Future<Uint8List?> fetchImage(String filename) async {
    // Construct the full URL, e.g., http://10.10.10.35:5000/uploads/room.jpg
    final String getImageUrl = '$_fetchBaseUrl$filename';

    try {
      final response = await http.get(Uri.parse(getImageUrl));

      if (response.statusCode == 200) {
        // The response body is the raw image data (bytes)
        return response.bodyBytes;
      } else {
        print('Failed to fetch image. Status: ${response.statusCode} for URL: $getImageUrl');
        return null;
      }
    } catch (e) {
      print('Error fetching image: $e');
      return null;
    }
  }
}