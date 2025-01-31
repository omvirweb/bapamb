import 'package:get/get.dart';
import 'package:jewelbook_calculator/utils/preferences_service.dart';
import '../services/http_service.dart';

class LedgerController extends GetxController {
  final HTTPService _httpService = Get.find();
  final PreferencesService _preferencesService = PreferencesService();
  var transactions = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  var selectedPartyId = 0.obs; // Nullable Rxn for party selection

  void fetchLedgerData(int? partyId) async {
    try {
      final String api_token = await _preferencesService.getString('api_token', "") ?? "";

      isLoading(true);
      final params = {'api_token': api_token};
      if (partyId != null) {
        params['party_id'] = partyId.toString();
      } else {
        params['party_id'] = ""; // Pass blank if no party is selected
      }

      print(params);

      final response = await _httpService.make_api_call_new('ledger', params);

      if (response.data['status'] == 1) {
        transactions.value = List<Map<String, dynamic>>.from(response.data['records']['data']);
      } else {
        Get.snackbar('Error', response.data['message']);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load data');
    } finally {
      isLoading(false);
    }
  }
}
