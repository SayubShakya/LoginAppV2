// lib/src/features/property/screens/property_list_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:typed_data';
import '../controllers/property_controller.dart';
// Note: We leave the ImageService import here to satisfy Uint8List types
// but remove the instance because it's now in the controller.

class PropertyListScreen extends StatelessWidget {
  final PropertyController controller = Get.put(PropertyController());

  // 🛑 REMOVED: This local instance caused the re-fetching issue.
  // final ImageService _imageService = ImageService();

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
        // ... (Loading, Error, and Empty state logic remains the same) ...
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.red),
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

  // --- UPDATED _buildPropertyImage METHOD ---
  Widget _buildPropertyImage(property) {
    // 1. ACCESS THE CACHED FUTURE from the model
    final imageFuture = property.imageFuture;

    // 2. If the Future hasn't been set, show placeholder
    if (imageFuture == null) {
      return Container(
        width: 80,
        height: 80,
        color: Colors.grey[300],
        child: const Icon(Icons.home, color: Colors.grey),
      );
    }

    // 3. Use FutureBuilder with the CACHED Future
    return FutureBuilder<Uint8List?>(
      // 🔥 CRITICAL FIX: Use the Future initialized by the Controller
      future: imageFuture,
      builder: (context, snapshot) {
        const double size = 80.0;

        // 4. Handle connection states
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            width: size,
            height: size,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }

        // 5. Handle error or null data
        if (snapshot.hasError || snapshot.data == null) {
          return Container(
            width: size,
            height: size,
            color: Colors.grey[300],
            child: const Icon(Icons.broken_image, color: Colors.red),
          );
        }

        // 6. Success: Use Image.memory to display the Uint8List bytes
        return Container(
          width: size,
          height: size,
          color: Colors.grey[300],
          child: Image.memory(
            snapshot.data!,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}