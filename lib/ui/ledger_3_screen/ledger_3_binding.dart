import 'package:get/get.dart';
import 'package:jewelbook_calculator/ui/dashboard/dashboard_controller.dart';
import 'package:jewelbook_calculator/ui/details_screen/item_details_controller.dart';
import 'package:jewelbook_calculator/ui/ledger_3_screen/ledger_3_controller.dart';

class Ledger3Binding extends Bindings {
  @override
  void dependencies() {
    Get.put<Ledger3Controller>(Ledger3Controller());
  }
}