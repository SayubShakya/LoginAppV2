import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loginappv2/src/features/user_dashboard/screens/landlord_dashboards/landloard_dashboard.dart'; // Import GetX


class RoomListingWidget extends StatelessWidget {
  const RoomListingWidget({super.key});

  // A function to handle the tap event and navigate
  void _onTapHandler() {
    // Navigate to the DestinationScreen using GetX routing
    Get.off(() => LandloardDashboard());
    // Alternative for named routes: Get.toNamed('/newListing');
  }

  @override
  Widget build(BuildContext context) {
    // Use GestureDetector to make the entire card tappable
    return GestureDetector(
      onTap: _onTapHandler,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              // This gives the elevated card effect
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // --- Text Content Section ---
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // Title: "ROOM खाली छ? List Now!"
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'ROOM खाली छ?',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: ' List Now!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade700, // Matching the red text
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    // Subtitle: Nepali Text
                    Text(
                      // Placeholder for the Nepali Subtitle
                      'भाडावाल, Room-mate, Guest पाउन Room Sewa App मा कोठा, फ्ल्याट, वा घर राख्नुहोस्।',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16.0),
              // --- Icon Section ---
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  // The House Icon
                  Icon(
                    Icons.house_sharp,
                    size: 50.0,
                    color: Colors.red.shade700, // Matching the red icon
                  ),
                  // The Plus Icon overlay
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2), // White border for separation
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Example usage in main.dart (Requires GetMaterialApp)
/*
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // You MUST use GetMaterialApp for GetX routing to work
    return GetMaterialApp(
      title: 'Room Sewa App',
      home: Scaffold(
        appBar: AppBar(title: Text('Home Screen')),
        body: Center(
          child: RoomListingWidget(),
        ),
      ),
    );
  }
}
*/