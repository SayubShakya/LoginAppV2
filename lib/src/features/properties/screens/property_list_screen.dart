// lib/src/features/property/screens/property_list_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:typed_data';
import '../controllers/property_controller.dart';

class PropertyListScreen extends StatelessWidget {
  final PropertyController controller = Get.put(PropertyController());

  PropertyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Marketplace',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF4C3E71), // Dark indigo
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            // Handle menu button press
          },
        ),
      ),
      body: Column(
        children: [
          // Condensed Header with Location & Chips
          Stack(
            children: [
              // Dark indigo background
              Container(
                height:160,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF4C3E71),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),

              // White card with location and chips
              Positioned(
                bottom:15,
                left: 20,
                right: 20,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Location input only
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Lalitpur, Kathmandu',
                            hintStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            prefixIcon: Icon(
                              Icons.location_pin,
                              color: Colors.grey[600],
                              size:20
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Filter chips row
                      SizedBox(
                        height: 35,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildFilterChip('Residential'),
                            const SizedBox(width: 3),
                            _buildFilterChip('Commercial'),
                            const SizedBox(width: 3),
                            _buildFilterChip('Industrial'),
                            const SizedBox(width: 3),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 0), // Space for the overlapping card

          // Property List Section with smooth transition
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Obx(() {
                // Loading State
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Error State
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

                // Empty State
                if (controller.propertyList.isEmpty) {
                  return const Center(
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
                  );
                }

                // Property List with "Showing Results" header
                return Column(
                  children: [
                    // Showing Results Header
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Showing Results',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          TextButton(
                            onPressed: controller.retryFetch,
                            child: const Text(
                              'Show more',
                              style: TextStyle(
                                color: Color(0xFF4C3E71),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Property List
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: controller.propertyList.length,
                        itemBuilder: (context, index) {
                          final property = controller.propertyList[index];
                          return _buildPropertyCard(property);
                        },
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // Filter Chip Component
  Widget _buildFilterChip(String label) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3E5F5), // Light purple background
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF7B1FA2), // Purple accent border
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF7B1FA2), // Purple accent text
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // Property Card Component
  Widget _buildPropertyCard(property) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Prominent full-width property image
            _buildPropertyImage(property),

            // Property details section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left side - Property info
                  Expanded(
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
                        const SizedBox(height: 8),

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
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Right side - Rent and Availability
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Monthly Rent
                      Text(
                        "Rs.${property.rent ?? 'N/A'}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Per month text
                      const Text(
                        "/per month",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Availability Status
                      _buildAvailabilityStatus(true), // Change to false for 'Booked'
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
      height: 200,
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
        height: 200,
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
          Icon(Icons.home, color: Colors.grey, size: 50),
          SizedBox(height: 8),
          Text(
            "No Image",
            style: TextStyle(color: Colors.grey),
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
          Icon(Icons.broken_image, color: Colors.red, size: 50),
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