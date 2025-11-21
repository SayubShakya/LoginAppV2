import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:loginappv2/src/commom_widgets/widgets/change_dashboard.dart';
import 'package:loginappv2/src/features/payment/esewa_pay.dart';
import 'package:loginappv2/src/features/properties/screens/dashboard.dart';
import 'package:loginappv2/src/features/properties/screens/property_list_screen.dart';
import 'package:loginappv2/src/features/user_dashboard/screens/addexpensescreen.dart';
import 'package:loginappv2/src/features/user_dashboard/screens/map/map_screen.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  int _page = 0;

  // The CORRECTED pages list (5 items for 5 icons)
  final List<Widget> _pages = [
    // Index 0: Icons.add

    const Mapspage(),// Index 0
    const EsewaApp(title: 'esewa Aayush',),// Index 1
    const dashboard(),// Index 2
    const PropertyListScreen(),// Index 3
    const RoomListingWidget(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: _page,
          // Your 5 icons
          items: const <Widget>[
            Icon(Icons.maps_home_work_outlined, size: 30),
            Icon(Icons.message_outlined, size: 30),
            Icon(Icons.perm_identity, size: 30),
            Icon(Icons.help_outline_outlined, size: 30),
            Icon(Icons.logout_outlined, size: 30),
          ],
          color: Colors.white,
          buttonBackgroundColor: Colors.white,
          backgroundColor: Colors.blueAccent,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 600),
          onTap: (index) {
            setState(() {
              _page = index;
            });
          },
          letIndexChange: (index) => true,
        ),
        body: Container(
          color: Colors.blueAccent,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Wrap the page in Expanded so it fills the available space
                Expanded(
                  child: _pages[_page],
                ),

                // Button to demonstrate programmatic control
                // ElevatedButton(
                //   child: const Text('Go To Page of index 1 (Map View)'),
                //   onPressed: () {
                //     final CurvedNavigationBarState? navBarState =
                //         _bottomNavigationKey.currentState;
                //     // This will now navigate to MapViewPage
                //     navBarState?.setPage(1);
                //   },
                // ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ));
  }
}