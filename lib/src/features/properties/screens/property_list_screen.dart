import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/property_controller.dart';

class PropertyListScreen extends StatelessWidget {
  final PropertyController controller = Get.put(PropertyController());

  PropertyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Property Listings"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.retryFetch,
          ),
        ],
      ),
      body: Obx(() {
        // Show loading indicator
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Show error message
        if (controller.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: controller.retryFetch,
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        }

        // Show empty state
        if (controller.propertyList.isEmpty) {
          return const Center(
            child: Text("No properties found."),
          );
        }

        // Show property list
        return ListView.builder(
          itemCount: controller.propertyList.length,
          itemBuilder: (context, index) {
            final property = controller.propertyList[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: ListTile(
                leading: _buildPropertyImage(property),
                title: Text(property.propertyTitle ?? "No Title"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Rent: \$${property.rent ?? 'N/A'}"),
                    Text("City: ${property.location?.city ?? 'Unknown Location'}"),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildPropertyImage(property) {
    final image = property.image;
    final imagePath = image?.path;
    final filename = image?.filename;

    // If no image data, show placeholder
    if (imagePath == null && filename == null) {
      return Container(
        width: 80,
        height: 80,
        color: Colors.grey[300],
        child: const Icon(Icons.home, color: Colors.grey),
      );
    }

    // Build image URL
    String imageUrl;
    if (filename != null && filename.isNotEmpty) {
      imageUrl = 'http://192.168.1.75:5000/uploads/$filename';
    } else if (imagePath != null && imagePath.isNotEmpty) {
      // Extract filename from path if needed
      if (imagePath.contains('\\')) {
        final extractedFilename = imagePath.split('\\').last;
        imageUrl = 'http://192.168.1.75:5000/uploads/$extractedFilename';
      } else {
        imageUrl = imagePath;
      }
    } else {
      // Fallback to placeholder
      return Container(
        width: 80,
        height: 80,
        color: Colors.grey[300],
        child: const Icon(Icons.home, color: Colors.grey),
      );
    }

    return Container(
      width: 80,
      height: 80,
      color: Colors.grey[300],
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image, color: Colors.grey);
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}