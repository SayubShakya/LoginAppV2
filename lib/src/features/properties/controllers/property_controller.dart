import 'package:get/get.dart';
import '../Repositories/property_repo.dart';
import '../models/model_property.dart';


class PropertyController extends GetxController {
  final PropertyService _service = PropertyService();

  var propertyList = <PropertyModel>[].obs; // matches view
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProperties(); // fetch on controller init
  }

  void fetchProperties({int page = 1, int limit = 5}) async {
    try {
      isLoading.value = true;
      propertyList.value = await _service.getProperties(page: page, limit: limit);
    } catch (e) {
      print("Controller error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
