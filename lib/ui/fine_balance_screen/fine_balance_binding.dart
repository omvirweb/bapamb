import 'package:get/get.dart';
import 'package:jewelbook_calculator/ui/fine_balance_screen/fine_balance_controller.dart';
import 'package:jewelbook_calculator/ui/splash_screen/splash_controller.dart';

class FineBalanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<FineBalanceController>(FineBalanceController());
  }
}