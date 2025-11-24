import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackbar {
  // We'll use GetX's utility, which doesn't require BuildContext,
  // but we keep the parameters for consistency with your request.
  // The BuildContext context parameter is intentionally unused here
  // because Get.snackbar handles this globally.

  static void showInfoSnackbar({
    BuildContext? context,
    required String title,
    required String message,
  }) {
    Get.snackbar(
      title,
      message,
      icon: const Icon(Icons.info, color: Colors.blue),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.withOpacity(0.1),
      colorText: Colors.blue,
      borderRadius: 8,
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 3),
    );
  }

  static void showSuccessSnackbar({
    BuildContext? context,
    required String title,
    required String message,
  }) {
    Get.snackbar(
      title,
      message,
      icon: const Icon(Icons.check_circle, color: Colors.green),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.1),
      colorText: Colors.green.shade700,
      borderRadius: 8,
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 3),
    );
  }

  static void showErrorSnackbar({
    BuildContext? context,
    required String title,
    required String message,
  }) {
    Get.snackbar(
      title,
      message,
      icon: const Icon(Icons.error, color: Colors.red),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.1),
      colorText: Colors.red.shade700,
      borderRadius: 8,
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 5), // Longer duration for errors
    );
  }
}