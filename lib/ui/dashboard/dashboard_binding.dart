import 'package:get/get.dart';
import 'package:jewelbook_calculator/ui/dashboard/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<DashboardController>(DashboardController());
  }
}