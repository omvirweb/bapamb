import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewelbook_calculator/utils/preferences_service.dart';
import '../services/http_service.dart';

class AutofillDataController extends GetxController {
  final HTTPService _httpService = Get.find();
  final PreferencesService _preferencesService = PreferencesService();

  var parties = <Map<String, dynamic>>[].obs;
  var items = <Map<String, dynamic>>[].obs;
  var touchList = <Map<String, dynamic>>[].obs;
  var notesList = <Map<String, dynamic>>[].obs;

  var touchListAuto = <Map<String, dynamic>>[].obs;
  var notesListAuto = <Map<String, dynamic>>[].obs;

  var settingsList = <Map<String, dynamic>>[].obs;

  var selectedPartyName = ''.obs;
  var selectedPartyId = ''.obs;

  var selectedItemName = ''.obs;
  var selectedItemId = ''.obs;

  var autoCompleteTouch = false.obs;
  var autoCompleteNotes = false.obs;


  Future<void> fetchAutofillData() async {
    final String apiToken =
        await _preferencesService.getString('api_token', "") ?? "";

    try {
      final response = await _httpService.make_api_call_new('common_data', {
        'api_token': apiToken,
      });

      if (response.data['status'] == 1) {
        final data = response.data['data'];
        if (data != null) {
          parties.value =
              List<Map<String, dynamic>>.from(data['parties'] ?? []);
          items.value = List<Map<String, dynamic>>.from(data['items'] ?? []);
          touchList.value =
              List<Map<String, dynamic>>.from(data['touch'] ?? []);
          notesList.value =
              List<Map<String, dynamic>>.from(data['notes'] ?? []);
          settingsList.value =
              List<Map<String, dynamic>>.from(data['settings'] ?? []);

          if (settingsList != null && settingsList.length > 0) {
            var isTouch = settingsList[0]["touch"] == 0 ? false : true;
            var isNotes = settingsList[0]["notes"] == 0 ? false : true;
            await _preferencesService.saveBool("autoCompleteTouch", isTouch);
            await _preferencesService.saveBool("autoCompleteNotes", isNotes);

            if(isTouch){
              touchListAuto.value =
              List<Map<String, dynamic>>.from(data['touch'] ?? []);
            }else{
              touchListAuto.value.clear();
            }
            if(isNotes){
              notesListAuto.value =
              List<Map<String, dynamic>>.from(data['notes'] ?? []);
            }else{
              notesListAuto.value.clear();
            }
          }
        }
      } else {
        Get.dialog(
          AlertDialog(
            title: const Text('Error'),
            content: Text(
              'Error code: ${response.data['status'].toString()}\n'
              '${response.data['message'].toString()}',
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('OK'),
              ),
            ],
          ),
          barrierDismissible: false,
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }
}
