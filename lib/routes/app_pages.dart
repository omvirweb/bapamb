import 'package:get/get.dart';
import 'package:jewelbook_calculator/ui/current_stock_screen/current_stock_binding.dart';
import 'package:jewelbook_calculator/ui/current_stock_screen/current_stock_screen.dart';
import 'package:jewelbook_calculator/ui/dashboard/dashboard.dart';
import 'package:jewelbook_calculator/ui/details_screen/details_screen.dart';
import 'package:jewelbook_calculator/ui/details_screen/item_details_binding.dart';
import 'package:jewelbook_calculator/ui/fine_balance_screen/fine_balance_binding.dart';
import 'package:jewelbook_calculator/ui/fine_balance_screen/fine_balance_screen.dart';
import 'package:jewelbook_calculator/ui/ledger_3_screen/ledger_3_binding.dart';
import 'package:jewelbook_calculator/ui/ledger_3_screen/ledger_3_screen.dart';
import 'package:jewelbook_calculator/ui/login_screen/login_screen.dart';
import 'package:jewelbook_calculator/ui/otp_screen/otp_screen.dart';
import 'package:jewelbook_calculator/ui/settings_screen/settings_binding.dart';
import 'package:jewelbook_calculator/ui/settings_screen/settings_screen.dart';
import 'package:jewelbook_calculator/ui/splash_screen/splash_screen.dart';
import 'package:jewelbook_calculator/ui/touchwise_balance_screen/touchwise_balance_binding.dart';
import 'package:jewelbook_calculator/ui/touchwise_balance_screen/touchwise_balance_screen.dart';

import '../ui/dashboard/dashboard_binding.dart';
import '../ui/login_screen/login_binding.dart';
import '../ui/otp_screen/otp_binding.dart';
import '../ui/splash_screen/splash_binding.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: _Paths.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.otp,
      page: () => const OtpScreen(),
      binding: OtpBinding(),
    ),
    GetPage(
      name: _Paths.dashboard,
      page: () => const Dashboard(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.currentstock,
      page: () => const CurrentStockScreen(),
      binding: CurrentStockBinding(),
    ),
    GetPage(
      name: _Paths.finebalance,
      page: () => const FineBalanceScreen(),
      binding: FineBalanceBinding(),
    ),
    GetPage(
      name: _Paths.touchwisebalance,
      page: () => const TouchwiseBalanceScreen(),
      binding: TouchwiseBalanceBinding(),
    ),
    GetPage(
      name: _Paths.itemdetails,
      page: () => const DetailScreen(),
      binding: ItemDetailsBinding(),
    ),
    GetPage(
      name: _Paths.settings,
      page: () => const SettingsScreen(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.ledger3,
      page: () => const Ledger3Screen(),
      binding: Ledger3Binding(),
    ),
  ];
}
