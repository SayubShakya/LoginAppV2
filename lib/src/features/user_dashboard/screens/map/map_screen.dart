import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:loginappv2/src/features/properties/screens/horizontal_property_list_widget.dart';
import 'package:loginappv2/src/features/properties/screens/property_list_screen.dart';
import 'package:loginappv2/src/features/properties/controllers/property_controller.dart';

class Mapspage extends StatefulWidget {
  const Mapspage({super.key});

  @override
  State<Mapspage> createState() => MapspageState();
}

class MapspageState extends State<Mapspage> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();
  final PropertyController propertyController = Get.put(PropertyController());
  String _mapStyle = '';

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(27.700769, 85.300140),
    zoom: 12.0,
  );

  @override
  void initState() {
    super.initState();
    _loadMapStyles();
  }

  Future<void> _loadMapStyles() async {
    try {
      final String style = await rootBundle.loadString('assets/map_style.json');
      setState(() {
        _mapStyle = style;
      });

      if (_controller.isCompleted) {
        final controller = await _controller.future;
        controller.setMapStyle(_mapStyle);
      }
    } catch (e) {
      print('Error loading map style: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              if (_mapStyle.isNotEmpty) {
                controller.setMapStyle(_mapStyle);
              }
            },
            markers: {
              const Marker(
                markerId: MarkerId("PCPS"),
                position: LatLng(27.684549324135066, 85.31698266182121),
                infoWindow: InfoWindow(
                  title: "PCPS College",
                  snippet: "pcps.edu.np",
                ),
              )
            },
          ),

          // Simple bottom sheet (not draggable but reliable)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 220, // Fixed height
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Drag handle (visual only)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Nearby Properties',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            // You could hide the sheet here if needed
                          },
                        ),
                      ],
                    ),
                  ),
                  // Horizontal Property List
                  Expanded(
                    child: HorizontalPropertyListWidget(
                      controller: propertyController,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Floating Action Button positioned above the sheet
          Positioned(
            right: 16,
            bottom: 240 + bottomPadding, // Position above the fixed sheet
            child: FloatingActionButton.extended(
              onPressed: () {
                Get.to(() => PropertyListScreen());
              },
              label: const Text('List View'),
              icon: const Icon(Icons.list_alt_outlined),
            ),
          ),
        ],
      ),
    );
  }
}