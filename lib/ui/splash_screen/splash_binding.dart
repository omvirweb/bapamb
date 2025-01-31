import 'package:get/get.dart';
import 'package:jewelbook_calculator/ui/splash_screen/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SplashController>(SplashController());
  }
}