import 'package:get/get.dart';
import 'package:jewelbook_calculator/ui/current_stock_screen/current_stock_controller.dart';
import 'package:jewelbook_calculator/ui/dashboard/dashboard_controller.dart';

class CurrentStockBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CurrentStockController>(CurrentStockController());
  }
}