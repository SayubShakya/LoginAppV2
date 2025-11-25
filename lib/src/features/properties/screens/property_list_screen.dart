// dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/property_controller.dart';

class PropertyListScreen extends StatelessWidget {
  final PropertyController controller = Get.put(PropertyController());

  PropertyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Property Listings")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.propertyList.isEmpty) {
          return const Center(child: Text("No properties found."));
        }

        return ListView.builder(
          itemCount: controller.propertyList.length,
          itemBuilder: (context, index) {
            final property = controller.propertyList[index];

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              elevation: 3,
              child: ListTile(
                contentPadding: const EdgeInsets.all(8),
                leading: property.image.path.isNotEmpty
                    ? Image.network(
                  property.image.path.replaceAll('\\', '/'),
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                )
                    : Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[300],
                  child: const Icon(Icons.home),
                ),
                title: Text(property.propertyTitle),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Rent: \$${property.rent}"),
                    Text("City: ${property.location.city}"),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
