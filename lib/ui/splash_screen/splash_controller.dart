import 'package:get/get.dart';
import 'package:jewelbook_calculator/routes/app_pages.dart';
import 'package:jewelbook_calculator/utils/preferences_service.dart';

class SplashController extends GetxController{
@override
  void onInit() {
    super.onInit();
    _checkLoginStatus();
  }

Future<void> _checkLoginStatus() async {
  final PreferencesService preferencesService = PreferencesService();
  bool isLoggedIn = await preferencesService.getBool('checkLogin', false);
  String apiToken = await preferencesService.getString('api_token', "") ?? "";

  print(apiToken);
  await Future.delayed(const Duration(seconds: 3));
  if (isLoggedIn) {
    Get.offAllNamed(Routes.dashboard);
  } else {
    Get.offAllNamed(Routes.login);
  }
}
}