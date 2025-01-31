import 'package:get/get.dart';
import 'package:jewelbook_calculator/utils/preferences_service.dart';
import '../../services/http_service.dart';

class FineBalanceController extends GetxController {
  final HTTPService _httpService = Get.find();
  var fineBalances = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  final PreferencesService _preferencesService = PreferencesService();

  @override
  void onInit() {
    fetchFineBalances();
    super.onInit();
  }

  Future<void> fetchFineBalances() async {
    final String api_token = await _preferencesService.getString('api_token', "") ?? "";

    try {
      final response = await _httpService.make_api_call_new('fine_balance', {
        'api_token': api_token,
      });

      if (response.data['status'] == 1) {
        fineBalances.value = List<Map<String, dynamic>>.from(response.data['records']['data']);
      } else {
        Get.snackbar('Error', 'Failed to fetch fine balances');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
