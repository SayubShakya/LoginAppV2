import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:loginappv2/src/features/properties/screens/dashboard.dart';

class Mapspage extends StatefulWidget {
  const Mapspage({super.key});

  @override
  State<Mapspage> createState() => MapspageState();
}

class MapspageState extends State<Mapspage> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  // Stores the loaded JSON string.
  String _mapStyle = '';

  static const CameraPosition _kGooglePlex = CameraPosition(
    // Coordinates for Kathmandu (approx. city center)
    target: LatLng(27.700769, 85.300140),
    zoom: 12.0, // A zoom level of 12.0 is usually good for a city view
  );

  // --- Map Style Loading Implementation ---

  @override
  void initState() {
    super.initState();
    _loadMapStyles();
  }

  // Asynchronously loads the style JSON.
  Future<void> _loadMapStyles() async {
    try {

      final String style = await rootBundle.loadString('assets/map_style.json');

      // Use setState to store the style and trigger a rebuild if necessary.
      setState(() {
        _mapStyle = style;
      });

      // If the map has already been created, apply the style immediately.
      if (_controller.isCompleted) {
        final controller = await _controller.future;
        controller.setMapStyle(_mapStyle);
      }
    } catch (e) {
      // Handle the error if the file is not found or cannot be loaded
      print('Error loading map style: $e');
    }
  }

  // --- Widget Build ---

  @override
  Widget build(BuildContext context) { // 👈 FIX: Must return a Widget synchronously
    return Scaffold(
      body: GoogleMap(
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);

          // Apply the loaded style string here, if it is available.
          if (_mapStyle.isNotEmpty) {
            controller.setMapStyle(_mapStyle);
          }
        },
        markers: {
          const Marker(
              markerId: MarkerId("PCPS"),
              position: LatLng(27.684549324135066, 85.31698266182121),
              infoWindow: InfoWindow(
                  title: "PCPS College", snippet: "pcps.edu.np"))
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        // FIX: onPressed must be a synchronous function that performs the navigation
        onPressed: () {
          Get.to(() => const dashboard());
        },
        label: const Text('List View'),
        icon: const Icon(Icons.list_alt_outlined),
      ),

    );
  }
}