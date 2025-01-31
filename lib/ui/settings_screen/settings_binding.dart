import 'package:get/get.dart';
import 'package:jewelbook_calculator/ui/settings_screen/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SettingsController>(SettingsController());
  }
}
