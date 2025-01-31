import 'package:get/get.dart';
import 'package:jewelbook_calculator/services/http_service.dart';
import 'package:jewelbook_calculator/utils/preferences_service.dart';

class SettingsController extends GetxController {
  RxBool autoCompleteTouch = false.obs;
  RxBool autoCompleteNotes = false.obs;

  final HTTPService _httpService = Get.find<HTTPService>();
  final PreferencesService _preferencesService = PreferencesService();

  @override
  void onInit() {
    super.onInit();
    loadInitialSettings();
  }

  Future<void> loadInitialSettings() async {
    autoCompleteTouch.value =
        await _preferencesService.getBool('autoCompleteTouch', true);
    autoCompleteNotes.value =
        await _preferencesService.getBool('autoCompleteNotes', false);
  }

  Future<void> updateSetting() async {
    try {
      final String apiToken =
          await _preferencesService.getString('api_token', "") ?? "";

      if (apiToken.isEmpty) {
        print('API token is missing.');
        return;
      }

      final response = await _httpService.make_api_call('settings', {
        'api_token': apiToken,
        'touch': autoCompleteTouch.value ? 1 : 0,
        'notes': autoCompleteNotes.value ? 1 : 0,
      });

      if (response.statusCode == 200) {
        print(response);
        if (response.data['status'] == 1) {
          await _preferencesService.saveBool(
              "autoCompleteTouch", autoCompleteTouch.value);
          await _preferencesService.saveBool(
              "autoCompleteNotes", autoCompleteNotes.value);
        } else {
          Get.snackbar('Error code : ' + response.data['status'].toString(),
              '' + response.data['message']);
        }
      } else {
        print('Failed to update setting: ${response.data}');
      }
    } catch (e) {
      print('Error while updating setting: $e');
    }
  }

  void onTouchChanged(bool value) {
    autoCompleteTouch.value = value;
    updateSetting();
  }

  void onNotesChanged(bool value) {
    autoCompleteNotes.value = value;
    updateSetting();
  }
}
