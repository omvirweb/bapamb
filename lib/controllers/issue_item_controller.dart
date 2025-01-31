import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewelbook_calculator/services/http_service.dart';
import 'package:jewelbook_calculator/utils/preferences_service.dart';

class IssueItemController extends GetxController {
  var msg = ''.obs;
  var net_weight = 0.0.obs;
  var final_fine = 0.0.obs;
  final PreferencesService _preferencesService = PreferencesService();

  final HTTPService _httpService = HTTPService();

  Future<void> submitIssueItemData({
    required String tId,
    required String partyName,
    required String partyId,
    required String item,
    required String itemId,
    required String weight,
    required String less,
    required String add,
    required String netWeight,
    required String touch,
    required String wastage,
    required String fine,
    required String date,
    required String notes,
    required VoidCallback onSuccess
  }) async {
    try {
      final String api_token = await _preferencesService.getString('api_token', "") ?? "";

      final data = {
        'api_token': api_token,
        'id': tId,
        'party_name': partyName,
        'party_id': partyId,
        'item': item,
        'item_id': itemId,
        'weight': weight,
        'less': less,
        'add': add,
        'net_wt': netWeight,
        'touch': touch,
        'wastage': wastage,
        'fine': fine,
        'date': date,
        'note': notes,
      };

      print(data);  // Debug: Print the data being sent

      final response = await _httpService.make_api_call('issue_item', data);

      // Check the status as a string to avoid type mismatch issues
      if (response.data['status'].toString() == '1') {
        msg.value = response.data['message'].toString();
        onSuccess();
        print("Response Status: ${response.data['status']}");
        print("Response Message: ${response.data['message']}");
      } else {
        Get.snackbar('Error', 'Result 0');
      }
    } catch (e) {
      // Handle error
      Get.snackbar('Error', 'Failed to submit item data: $e');
    }
  }

}
