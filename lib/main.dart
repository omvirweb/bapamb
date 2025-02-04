import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewelbook_calculator/controllers/issue_item_controller.dart';
import 'package:jewelbook_calculator/routes/customNavigator.dart';
import 'package:jewelbook_calculator/ui/login_screen/login_screen.dart';
import 'package:jewelbook_calculator/ui/splash_screen/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // Get.lazyPut(() => IssueItemController());
  runApp(MaterialApp(
    navigatorKey: navigatorKey,
    debugShowCheckedModeBanner: false,
    navigatorObservers: [CustomNavigatorObserver()],
    initialRoute: 'splash',
    routes: {
      'splash': (context) => SplashScreen(prefs: prefs),
      'loginScreen': (context) => const LoginScreen(),
    },
  ));
}
