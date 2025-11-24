import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FullScreenDialogLoader {
  // A flag to ensure we don't try to cancel a dialog that isn't showing
  static bool _isDialogShowing = false;

  static void showDialog() {
    if (_isDialogShowing) return; // Prevent showing multiple loaders

    _isDialogShowing = true;
    Get.dialog(
      const Center(
        child: SizedBox(
          width: 80,
          height: 80,
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ),
      barrierDismissible: false, // User must not dismiss it
      // The name of the route is not strictly necessary but helps in navigation context
      name: 'FullScreenLoader',
    ).then((_) {
      // Reset flag when the dialog is dismissed (either manually or via cancelDialog)
      _isDialogShowing = false;
    });
  }

  static void cancelDialog() {
    if (_isDialogShowing) {
      // Use Get.back() to close the dialog, as it is treated as a route
      Get.back();
      _isDialogShowing = false;
    }
  }
}