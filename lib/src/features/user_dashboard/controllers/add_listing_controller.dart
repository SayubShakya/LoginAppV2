import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loginappv2/src/features/user_dashboard/services/property_service.dart';
import '../models/property_model.dart';

class AddListingController extends GetxController {
  final PropertyService _propertyService = Get.put(PropertyService());

  // Form controllers
  final TextEditingController propertyTitleController = TextEditingController();
  final TextEditingController detailedDescriptionController = TextEditingController();
  final TextEditingController rentController = TextEditingController();

  // Reactive variables
  Rx<File?> coverImage = Rx<File?>(null);
  RxBool isLoading = false.obs;

  // Dropdown selections
  RxString selectedStatus = ''.obs;
  RxString selectedPropertyType = ''.obs;
  RxString selectedLocation = ''.obs;

  // Dropdown lists
  RxList<DropdownItem> statusList = <DropdownItem>[].obs;
  RxList<DropdownItem> propertyTypeList = <DropdownItem>[].obs;
  RxList<LocationModel> locationList = <LocationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDropdownData();
  }

  // Load dropdown data
  void loadDropdownData() {
    // Example: Fetch from backend or static data
    statusList.assignAll([
      DropdownItem(id: 'available', name: 'Available'),
      DropdownItem(id: 'rented', name: 'Rented'),
      DropdownItem(id: 'under_maintenance', name: 'Under Maintenance'),
    ]);

    propertyTypeList.assignAll([
      DropdownItem(id: 'apartment', name: 'Apartment'),
      DropdownItem(id: 'house', name: 'House'),
      DropdownItem(id: 'room', name: 'Room'),
      DropdownItem(id: 'commercial', name: 'Commercial'),
    ]);

    // Fetch locations from backend
    fetchLocations();
  }

  // --- Image Picker ---
  Future<void> pickCoverImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source, imageQuality: 80);
    if (pickedFile != null) {
      coverImage.value = File(pickedFile.path);
    } else {
      Get.snackbar('Error', 'No image selected', snackPosition: SnackPosition.BOTTOM);
    }
  }

  // --- Fetch Locations from backend ---
  Future<void> fetchLocations() async {
    try {
      isLoading.value = true;
      final fetchedLocations = await _propertyService.getLocations(page: 1, limit: 50);
      locationList.assignAll(fetchedLocations as Iterable<LocationModel>);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch locations: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // --- Add Property ---
  Future<void> addProperty() async {
    if (isLoading.value) return;

    if (selectedStatus.value.isEmpty ||
        selectedPropertyType.value.isEmpty ||
        selectedLocation.value.isEmpty) {
      Get.snackbar('Error', 'Please select all dropdown fields',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;

    try {
      String? imageId;

      if (coverImage.value != null) {
        final uploadedImage = await _propertyService.uploadImage(coverImage.value!.path);
        if (uploadedImage != null && uploadedImage['image_id'] != null) {
          imageId = uploadedImage['image_id'];
        } else {
          Get.snackbar('Error', 'Failed to upload image',
              snackPosition: SnackPosition.BOTTOM);
          isLoading.value = false;
          return;
        }
      }

      // Get selected location for lat/lng
      final selectedLoc = locationList.firstWhere((loc) => loc.id == selectedLocation.value);

      final newProperty = PropertyModel(
        propertyTitle: propertyTitleController.text,
        detailedDescription: detailedDescriptionController.text,
        rent: double.tryParse(rentController.text) ?? 0.0,
        coverImageUrl: imageId,
        status: selectedStatus.value,
        propertyTypesId: selectedPropertyType.value,
        locationId: selectedLocation.value,
        latitude: selectedLoc.latitude,
        longitude: selectedLoc.longitude,
        userId: 'landlordUserId123', // Replace with actual logged-in user
      );

      final createdProperty = await _propertyService.createProperty(newProperty);

      if (createdProperty != null) {
        Get.snackbar('Success', 'Property listed successfully!',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green.shade400,
            colorText: Colors.white);
        clearForm();
        Get.back();
      } else {
        Get.snackbar('Error', 'Failed to list property', snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Unexpected error: $e', snackPosition: SnackPosition.BOTTOM);
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    propertyTitleController.clear();
    detailedDescriptionController.clear();
    rentController.clear();
    coverImage.value = null;
    selectedStatus.value = '';
    selectedPropertyType.value = '';
    selectedLocation.value = '';
  }

  @override
  void onClose() {
    propertyTitleController.dispose();
    detailedDescriptionController.dispose();
    rentController.dispose();
    super.onClose();
  }
}

// --- Simple models for dropdowns ---
class DropdownItem {
  final String id;
  final String name;
  DropdownItem({required this.id, required this.name});
}

class LocationModel {
  final String id;
  final String city;
  final String areaName;
  final double latitude;
  final double longitude;

  LocationModel({
    required this.id,
    required this.city,
    required this.areaName,
    required this.latitude,
    required this.longitude,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'],
      city: json['city'] ?? '',
      areaName: json['area_name'] ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}
