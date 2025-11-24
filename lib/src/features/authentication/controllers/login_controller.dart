import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loginappv2/src/features/authentication/services/auth_service.dart';
import 'package:loginappv2/src/features/user_dashboard/screens/main_dashboard_screen.dart';
import 'package:loginappv2/src/utils/custom_snakbar.dart';
import 'package:loginappv2/src/utils/get_storage_key.dart';

import '../../../utils/full_screen_dailog_loader.dart';
import '../../user_dashboard/screens/landlord_dashboards/landloard_dashboard.dart';


class LoginController extends GetxController {
  final AuthService _authService = AuthService();
  final GetStorage _storage = GetStorage();

  void loginUser(String email, String password) async {
    try {
      FullScreenDialogLoader.showDialog(); // Show loader

      final loginResponse = await _authService.loginUser(email, password);

      // Save token in local storage
      await _storage.write(GetStorageKey.accessToken, loginResponse.token);

      FullScreenDialogLoader.cancelDialog(); // Hide loader

      CustomSnackbar.showSuccessSnackbar(
        title: "Success",
        message: "Login Successful!",
      );

      // Navigate based on role
      if (loginResponse.role == "Landlord") {
        Get.offAll(() => LandloardDashboard());
      } else {
        Get.offAll(() => UserDashboard());
      }
    } catch (e) {
      FullScreenDialogLoader.cancelDialog();
      CustomSnackbar.showErrorSnackbar(
        title: "Error",
        message: e.toString(),
      );
    }
  }
}
