import 'package:get/get.dart';
import 'package:jewelbook_calculator/ui/splash_screen/splash_controller.dart';
import 'package:jewelbook_calculator/ui/touchwise_balance_screen/touchwise_balance_controller.dart';

class TouchwiseBalanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<TouchwiseBalanceController>(TouchwiseBalanceController());
  }
}