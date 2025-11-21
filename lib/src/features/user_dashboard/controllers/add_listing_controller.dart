// lib/src/features/properties/controllers/add_listing_controller.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:loginappv2/src/features/user_dashboard/services/property_service.dart';
import '../models/property_model.dart';

class AddListingController extends GetxController {
  final PropertyService _propertyService = Get.put(PropertyService()); // Inject service

  // Form Field Controllers
  final TextEditingController propertyTitleController = TextEditingController();
  final TextEditingController detailedDescriptionController = TextEditingController();
  final TextEditingController rentController = TextEditingController();
  final TextEditingController addressController = TextEditingController(); // For user input address

  // Reactive variables for form state
  Rx<File?> coverImage = Rx<File?>(null); // For the picked image file
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  RxString selectedStatus = 'available'.obs; // Default status
  RxString selectedPropertyType = 'apartment'.obs; // Default property type (you'll fetch real types)
  RxBool isLoading = false.obs;

  // Example lists for dropdowns (you'd fetch these from backend in a real app)
  final List<String> propertyStatuses = ['available', 'rented', 'under_maintenance'];
  final List<String> propertyTypes = ['apartment', 'house', 'room', 'commercial']; // These would have IDs in backend

  // --- Image Picking Logic ---
  Future<void> pickCoverImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source, imageQuality: 80);

    if (pickedFile != null) {
      coverImage.value = File(pickedFile.path);
    } else {
      Get.snackbar('Error', 'No image selected', snackPosition: SnackPosition.BOTTOM);
    }
  }

  // --- Geocoding Logic (Address to Lat/Long) ---
  Future<void> geocodeAddress() async {
    isLoading.value = true;
    try {
      List<Location> locations = await locationFromAddress(addressController.text);
      if (locations.isNotEmpty) {
        latitude.value = locations.first.latitude;
        longitude.value = locations.first.longitude;
        Get.snackbar(
          'Location Found',
          'Lat: ${latitude.value}, Long: ${longitude.value}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade400,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar('Error', 'Could not find coordinates for the given address.', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red.shade400, colorText: Colors.white);
        latitude.value = 0.0;
        longitude.value = 0.0;
      }
    } catch (e) {
      Get.snackbar('Error', 'Geocoding failed: $e', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red.shade400, colorText: Colors.white);
      latitude.value = 0.0;
      longitude.value = 0.0;
    } finally {
      isLoading.value = false;
    }
  }

  // --- Form Submission Logic ---
  Future<void> addProperty() async {
    if (isLoading.value) return; // Prevent multiple submissions

    isLoading.value = true;
    String? uploadedImageUrl;

    try {
      // 1. Upload Image (if selected)
      if (coverImage.value != null) {
        uploadedImageUrl = await _propertyService.uploadImage(coverImage.value!.path);
        if (uploadedImageUrl == null) {
          Get.snackbar('Error', 'Failed to upload cover image.', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red.shade400, colorText: Colors.white);
          return; // Stop if image upload fails
        }
      }

      // 2. Create Property Model
      // TODO: Replace 'landlordUserId123' with actual logged-in user ID
      // TODO: Replace 'propertyTypeId_apartment' with actual ID based on selectedPropertyType
      final newProperty = PropertyModel(
        propertyTitle: propertyTitleController.text,
        detailedDescription: detailedDescriptionController.text,
        rent: double.tryParse(rentController.text) ?? 0.0,
        coverImageUrl: uploadedImageUrl,
        locationId: addressController.text, // For now, using address as location_id, ideally this is an ID
        latitude: latitude.value,
        longitude: longitude.value,
        status: selectedStatus.value,
        userId: 'landlordUserId123', // **IMPORTANT: Replace with actual logged-in user's ID**
        propertyTypesId: 'propertyTypeId_${selectedPropertyType.value}', // **IMPORTANT: Replace with actual ID based on selection**
      );

      // 3. Send to Backend
      final createdProperty = await _propertyService.createProperty(newProperty);

      if (createdProperty != null) {
        Get.snackbar(
          'Success',
          'Property "${createdProperty.propertyTitle}" listed successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.shade400,
          colorText: Colors.white,
        );
        clearForm(); // Clear form after successful submission
        Get.back(); // Go back to previous screen (e.g., landlord dashboard)
      } else {
        Get.snackbar(
          'Error',
          'Failed to list property. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade400,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
      print('Error submitting property: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // --- Form Reset ---
  void clearForm() {
    propertyTitleController.clear();
    detailedDescriptionController.clear();
    rentController.clear();
    addressController.clear();
    coverImage.value = null;
    latitude.value = 0.0;
    longitude.value = 0.0;
    selectedStatus.value = 'available';
    selectedPropertyType.value = 'apartment';
  }

  @override
  void onClose() {
    propertyTitleController.dispose();
    detailedDescriptionController.dispose();
    rentController.dispose();
    addressController.dispose();
    super.onClose();
  }
}