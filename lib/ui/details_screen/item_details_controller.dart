import 'package:get/get.dart';
import 'package:jewelbook_calculator/utils/preferences_service.dart';
import '../../services/http_service.dart';

class ItemDetailsController extends GetxController {
  final HTTPService _httpService = Get.find();
  final PreferencesService _preferencesService = PreferencesService();

  var isSuccess = false.obs;
  var msg = ''.obs;
  Map<String, dynamic> itemDetails = Get.arguments['issueItem']; // Ensure this is mutable

  // Method to delete the item
  Future<void> deleteItem(String transactionId) async {
    final apiToken = await _preferencesService.getString('api_token', "") ?? "";
    try {
      final response = await _httpService.make_api_call_new('delete', {
        'api_token': apiToken,
        'transactions_id': transactionId,
      });
      isSuccess.value = response.data['status'] == 1;
      msg.value = response.data['message'] ?? 'Action completed.';
    } catch (e) {
      msg.value = 'An error occurred.';
      isSuccess.value = false;
    }
  }

  // Method to update item details when a new result is returned
  void updateItem(Map<String, dynamic> result) {
    // Replace the old item details with the new result
    itemDetails = result;

    // Call update() to rebuild the UI with the new data
    update();
  }
}
