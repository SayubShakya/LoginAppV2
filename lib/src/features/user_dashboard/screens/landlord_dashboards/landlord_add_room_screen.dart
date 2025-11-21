// lib/src/features/properties/screens/add_listing_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loginappv2/src/features/user_dashboard/controllers/add_listing_controller.dart';

class AddListingScreen extends StatelessWidget {
  const AddListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller when the screen is built
    final AddListingController controller = Get.put(AddListingController());
    final _formKey = GlobalKey<FormState>(); // For form validation

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Room/Property'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Obx(
            () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // --- Property Title ---
                TextFormField(
                  controller: controller.propertyTitleController,
                  decoration: const InputDecoration(
                    labelText: 'Property Title',
                    hintText: 'e.g., Spacious 2BHK Apartment',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.title),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a property title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // --- Detailed Description ---
                TextFormField(
                  controller: controller.detailedDescriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Detailed Description',
                    hintText: 'Describe the property, amenities, etc.',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a detailed description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // --- Rent ---
                TextFormField(
                  controller: controller.rentController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Rent Amount',
                    hintText: 'e.g., 15000',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.money),
                    suffixText: 'NPR', // Or your local currency
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the rent amount';
                    }
                    if (double.tryParse(value) == null || double.parse(value) <= 0) {
                      return 'Please enter a valid positive number for rent';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // --- Property Status Dropdown ---
                Obx(
                      () => DropdownButtonFormField<String>(
                    value: controller.selectedStatus.value,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.info_outline),
                    ),
                    items: controller.propertyStatuses.map((String status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(status.capitalizeFirst!), // capitalizeFirst is a GetX extension
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        controller.selectedStatus.value = newValue;
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a status';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16.0),

                // --- Property Type Dropdown ---
                Obx(
                      () => DropdownButtonFormField<String>(
                    value: controller.selectedPropertyType.value,
                    decoration: const InputDecoration(
                      labelText: 'Property Type',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.category),
                    ),
                    items: controller.propertyTypes.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type.capitalizeFirst!),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        controller.selectedPropertyType.value = newValue;
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a property type';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16.0),

                // --- Address Input & Geocoding ---
                TextFormField(
                  controller: controller.addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    hintText: 'e.g., Street 123, City, Country',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.location_on),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        if (controller.addressController.text.isNotEmpty) {
                          controller.geocodeAddress();
                        } else {
                          Get.snackbar('Input Error', 'Please enter an address to search', snackPosition: SnackPosition.BOTTOM);
                        }
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the property address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8.0),
                Obx(() => Text(
                  controller.latitude.value != 0.0 && controller.longitude.value != 0.0
                      ? 'Lat: ${controller.latitude.value.toStringAsFixed(6)}, Long: ${controller.longitude.value.toStringAsFixed(6)}'
                      : 'Enter address and tap search to get Latitude/Longitude',
                  style: TextStyle(
                    fontSize: 12,
                    color: controller.latitude.value != 0.0 ? Colors.green : Colors.grey.shade600,
                  ),
                )),
                const SizedBox(height: 16.0),

                // --- Cover Image Picker ---
                const Text('Cover Image', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8.0),
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Obx(
                        () => controller.coverImage.value == null
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image, size: 50, color: Colors.grey.shade600),
                        const SizedBox(height: 8),
                        const Text('No Image Selected'),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => controller.pickCoverImage(ImageSource.gallery),
                              icon: const Icon(Icons.photo_library),
                              label: const Text('Gallery'),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton.icon(
                              onPressed: () => controller.pickCoverImage(ImageSource.camera),
                              icon: const Icon(Icons.camera_alt),
                              label: const Text('Camera'),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    )
                        : Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            controller.coverImage.value!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            icon: const Icon(Icons.delete_forever, color: Colors.red, size: 30),
                            onPressed: () => controller.coverImage.value = null, // Clear image
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),

                // --- Submit Button ---
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Ensure lat/long has been set, or prompt user
                        if (controller.latitude.value == 0.0 && controller.longitude.value == 0.0 && controller.addressController.text.isNotEmpty) {
                          Get.snackbar('Location Error', 'Please tap the search icon next to the address to get Latitude/Longitude.', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange.shade400, colorText: Colors.white);
                          return;
                        }
                        controller.addProperty();
                      }
                    },
                    icon: const Icon(Icons.upload_file),
                    label: const Text('LIST PROPERTY NOW'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}