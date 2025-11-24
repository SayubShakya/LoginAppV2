import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loginappv2/src/features/user_dashboard/controllers/add_listing_controller.dart';

class AddListingScreen extends StatelessWidget {
  const AddListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AddListingController controller = Get.put(AddListingController());
    final _formKey = GlobalKey<FormState>();

    // Load dropdown data once
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadDropdownData();
    });

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
              children: [
                // -------------------------------
                // Property Title
                // -------------------------------
                TextFormField(
                  controller: controller.propertyTitleController,
                  decoration: const InputDecoration(
                    labelText: 'Property Title',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.title),
                  ),
                  validator: (value) =>
                  value!.isEmpty ? 'Enter property title' : null,
                ),
                const SizedBox(height: 16),

                // -------------------------------
                // Description
                // -------------------------------
                TextFormField(
                  controller: controller.detailedDescriptionController,
                  minLines: 3,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Detailed Description',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                  ),
                  validator: (value) =>
                  value!.isEmpty ? 'Enter description' : null,
                ),
                const SizedBox(height: 16),

                // -------------------------------
                // Rent
                // -------------------------------
                TextFormField(
                  controller: controller.rentController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Rent Amount',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.money),
                    suffixText: 'NPR',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter rent amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Enter valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // -------------------------------
                // STATUS DROPDOWN
                // -------------------------------
                Obx(() => DropdownButtonFormField<String>(
                  value: controller.selectedStatus.value.isEmpty
                      ? null
                      : controller.selectedStatus.value,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.info_outline),
                  ),
                  items: controller.statusList
                      .map((s) => DropdownMenuItem(
                    value: s.id,
                    child: Text(s.name),
                  ))
                      .toList(),
                  onChanged: (value) =>
                  controller.selectedStatus.value =
                      value ?? '',
                  validator: (value) =>
                  value == null ? 'Select status' : null,
                )),

                const SizedBox(height: 16),

                // -------------------------------
                // PROPERTY TYPE DROPDOWN
                // -------------------------------
                Obx(() => DropdownButtonFormField<String>(
                  value: controller.selectedPropertyType.value.isEmpty
                      ? null
                      : controller.selectedPropertyType.value,
                  decoration: const InputDecoration(
                    labelText: 'Property Type',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: controller.propertyTypeList
                      .map((t) => DropdownMenuItem(
                    value: t.id,
                    child: Text(t.name),
                  ))
                      .toList(),
                  onChanged: (value) =>
                  controller.selectedPropertyType.value =
                      value ?? '',
                  validator: (value) =>
                  value == null ? 'Select property type' : null,
                )),

                const SizedBox(height: 16),

                // -------------------------------
                // LOCATION DROPDOWN
                // -------------------------------
                Obx(() => DropdownButtonFormField<String>(
                  value: controller.selectedLocation.value.isEmpty
                      ? null
                      : controller.selectedLocation.value,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  items: controller.locationList
                      .map((loc) => DropdownMenuItem(
                    value: loc.id,
                    child: Text('${loc.city} ${loc.areaName}'),
                  ))
                      .toList(),
                  onChanged: (value) =>
                  controller.selectedLocation.value =
                      value ?? '',
                  validator: (value) =>
                  value == null ? 'Select location' : null,
                )),

                const SizedBox(height: 20),

                // -------------------------------
                // COVER IMAGE PICKER
                // -------------------------------
                const Text(
                  "Cover Image",
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                Obx(() {
                  return Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: controller.coverImage.value == null
                        ? Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => controller
                                .pickCoverImage(ImageSource.gallery),
                            icon: const Icon(Icons.photo),
                            label: const Text("Gallery"),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton.icon(
                            onPressed: () => controller
                                .pickCoverImage(ImageSource.camera),
                            icon: const Icon(Icons.camera_alt),
                            label: const Text("Camera"),
                          ),
                        ],
                      ),
                    )
                        : Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            controller.coverImage.value!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          right: 10,
                          top: 10,
                          child: IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.red),
                            onPressed: () =>
                            controller.coverImage.value = null,
                          ),
                        )
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 25),

                // -------------------------------
                // SUBMIT BUTTON
                // -------------------------------
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        controller.addProperty();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      "LIST PROPERTY NOW",
                      style: TextStyle(
                          fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
