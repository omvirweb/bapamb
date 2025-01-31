import 'package:get/get.dart';
import 'package:jewelbook_calculator/utils/preferences_service.dart';

import '../../services/http_service.dart';

class CurrentStockController extends GetxController {
  final HTTPService _httpService = Get.find();
  var currentStock = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  final PreferencesService _preferencesService = PreferencesService();

  @override
  void onInit() {
    fetchCurrentStock();
    super.onInit();
  }

  Future<void> fetchCurrentStock() async {
    final String api_token =
        await _preferencesService.getString('api_token', "") ?? "";
    print(api_token);

    try {
      final response = await _httpService.make_api_call_new('curret_stock', {
        'api_token': api_token,
      });

      if (response.data['status'] == 1) {
        currentStock.value =
            List<Map<String, dynamic>>.from(response.data['records']['data']);
      } else {
        Get.snackbar('Error', 'Failed to fetch current stock');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
