// lib/src/features/property/screens/property_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loginappv2/src/features/properties/controllers/property_controller.dart';
import 'dart:typed_data';

import '../../../properties/models/model_property.dart';


class PropertyDetailScreen extends StatelessWidget {
  final String propertyId;
  final PropertyModel? initialProperty;

  const PropertyDetailScreen({
    super.key,
    required this.propertyId,
    this.initialProperty,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: FutureBuilder<PropertyModel>(
        future: PropertyController().getPropertyById(propertyId),
        builder: (context, snapshot) {
          // Use initial data while loading, then update with fresh data
          final property = snapshot.hasData ? snapshot.data! : initialProperty;

          if (property == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // Property Image
              Expanded(
                flex: 2,
                child: _buildPropertyImage(property),
              ),
              // Property Details
              Expanded(
                flex: 3,
                child: _buildPropertyDetails(property, snapshot.connectionState == ConnectionState.waiting),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPropertyImage(PropertyModel property) {
    final imageFuture = property.imageFuture;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
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

          return Image.memory(
            snapshot.data!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          );
        },
      ),
    );
  }

  Widget _buildPropertyDetails(PropertyModel property, bool isLoading) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property Title
            Text(
              property.propertyTitle ?? "No Title",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Rent and Availability
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rs.${property.rent ?? 'N/A'} /per month',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple),
                ),
                _buildAvailabilityStatus(property.isActive ?? true),
              ],
            ),
            const SizedBox(height: 8),

            // Location
            Text(
              property.location?.city ?? 'Unknown Location',
              style: TextStyle(color: Colors.grey[600]),
            ),

            // Property Type
            Text(
              _getPropertyType(property.propertyTitle ?? ""),
              style: TextStyle(color: Colors.grey[600]),
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // Contact Info
            // Row(
            //   children: [
            //     const Icon(Icons.phone, color: Colors.grey),
            //     const SizedBox(width: 8),
            //     Text(
            //       property.user?.phoneNumber ?? 'Not available',
            //       style: const TextStyle(fontSize: 16),
            //     ),
            //     const Spacer(),
            //     Text(
            //       'Property Owned By: ${property.user?.fullName ?? 'Unknown'}',
            //       style: TextStyle(color: Colors.grey[600]),
            //     ),
            //   ],
            // ),

            const SizedBox(height: 16),

            // Description
            const Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              property.detailedDescription ?? 'No description available',
              style: TextStyle(color: Colors.grey[700]),
            ),

            const Spacer(),

            // Book Now Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle book now action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Book Now',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.home, color: Colors.grey, size: 50),
        SizedBox(height: 8),
        Text(
          "No Image",
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildLoadingImage() {
    return const Center(
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4C3E71)),
      ),
    );
  }

  Widget _buildErrorImage() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.broken_image, color: Colors.red, size: 50),
        SizedBox(height: 8),
        Text(
          "Failed to load image",
          style: TextStyle(color: Colors.red, fontSize: 12),
        ),
      ],
    );
  }

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