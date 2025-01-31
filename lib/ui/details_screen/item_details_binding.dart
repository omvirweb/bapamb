import 'package:get/get.dart';
import 'package:jewelbook_calculator/ui/dashboard/dashboard_controller.dart';
import 'package:jewelbook_calculator/ui/details_screen/item_details_controller.dart';

class ItemDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ItemDetailsController>(ItemDetailsController());
  }
}