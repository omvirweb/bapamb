import 'package:get/get.dart';
import 'package:jewelbook_calculator/utils/preferences_service.dart';

import '../../services/http_service.dart';

class TouchwiseBalanceController extends GetxController {
  @override
  void onInit() {
    fetchTouchwiseBalances();
    super.onInit();
  }

  final HTTPService _httpService = Get.find();
  var touchwiseBalances = [].obs;
  var isLoading = true.obs;
  final PreferencesService _preferencesService = PreferencesService();

  Future<void> fetchTouchwiseBalances() async {
    try {
      final String api_token =
          await _preferencesService.getString('api_token', "") ?? "";

      final response =
          await _httpService.make_api_call_new('touchwise_balance', {
        'api_token': api_token,
      });

      if (response.data['status'] == 1) {
        touchwiseBalances.value =
            List<Map<String, dynamic>>.from(response.data['records']['data']);
      } else {
        Get.snackbar('Error', 'Failed to fetch touchwise balances');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
