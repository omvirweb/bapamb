import 'package:get/get.dart';
import 'package:jewelbook_calculator/ui/otp_screen/otp_controller.dart';

class OtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<OTPController>(OTPController());
  }
}
