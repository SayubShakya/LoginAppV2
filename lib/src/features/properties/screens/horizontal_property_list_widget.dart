import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:typed_data';
import '../controllers/property_controller.dart';

class HorizontalPropertyListWidget extends StatelessWidget {
  final PropertyController controller;

  const HorizontalPropertyListWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with title and view all button
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 0,
          ),

        ),

        // Horizontal property list
        Obx(() {
          // Loading State
          if (controller.isLoading.value) {
            return const SizedBox(
              height: 50,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          // Error State
          if (controller.hasError.value) {
            return SizedBox(
              height: 320,
              child: Center(
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
              ),
            );
          }

          // Empty State
          if (controller.propertyList.isEmpty) {
            return SizedBox(
              height: 320,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      "No properties found.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }

          // Horizontal Property List
          return SizedBox(
            height: 260,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.propertyList.length,
              itemBuilder: (context, index) {
                final property = controller.propertyList[index];
                return SizedBox(
                  width: 280,
                  child: _buildPropertyCard(property),
                );
              },
            ),
          );
        }),
      ],
    );
  }

  // Property Card Component (modified for horizontal layout)
  Widget _buildPropertyCard(property) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property image
            _buildPropertyImage(property),

            // Property details section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Property Title
                  Text(
                    property.propertyTitle ?? "No Title",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 0),

                  // Location
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          property.location?.city ?? 'Unknown Location',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Property Type
                  Text(
                    _getPropertyType(property.propertyTitle ?? ""),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Rent and Availability row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Monthly Rent
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Rs.${property.rent ?? 'N/A'}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const Text(
                            "/per month",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),

                      // Availability Status
                      _buildAvailabilityStatus(true),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Property Image Component
  Widget _buildPropertyImage(property) {
    final imageFuture = property.imageFuture;

    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        color: Colors.grey[300],
      ),
      child: imageFuture == null
          ? _buildPlaceholderImage()
          : FutureBuilder<Uint8List?>(
        future: imageFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingImage();
          }

          if (snapshot.hasError || snapshot.data == null) {
            return _buildErrorImage();
          }

          return _buildPropertyImageContent(snapshot.data!);
        },
      ),
    );
  }

  Widget _buildPropertyImageContent(Uint8List imageData) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      child: Image.memory(
        imageData,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 160,
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return const ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.home, color: Colors.grey, size: 40),
          SizedBox(height: 8),
          Text(
            "No Image",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingImage() {
    return const ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4C3E71)),
        ),
      ),
    );
  }

  Widget _buildErrorImage() {
    return const ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image, color: Colors.red, size: 40),
          SizedBox(height: 8),
          Text(
            "Failed to load image",
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // Availability Status Component
  Widget _buildAvailabilityStatus(bool isAvailable) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: isAvailable ? Colors.green : Colors.red,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          isAvailable ? "Available" : "Booked",
          style: TextStyle(
            fontSize: 12,
            color: isAvailable ? Colors.green : Colors.red,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Helper method to determine property type from title
  String _getPropertyType(String title) {
    if (title.toLowerCase().contains('hall')) {
      return 'Commercial Hall';
    } else if (title.toLowerCase().contains('flat')) {
      return 'Residential Flat';
    } else if (title.toLowerCase().contains('house')) {
      return 'Residential House';
    } else if (title.toLowerCase().contains('apartment')) {
      return 'Residential Apartment';
    } else {
      return 'Property';
    }
  }
}