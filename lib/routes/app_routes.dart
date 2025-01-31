part of 'app_pages.dart';

abstract class Routes {
  static const String splash = _Paths.splash;
  static const String dashboard = _Paths.dashboard;
  static const String register = _Paths.register;
  static const String login = _Paths.login;
  static const String otp = _Paths.otp;
  static const String currentstock = _Paths.currentstock;
  static const String finebalance = _Paths.finebalance;
  static const String touchwisebalance = _Paths.touchwisebalance;
  static const String itemdetails = _Paths.itemdetails;
  static const String settings = _Paths.settings;
  static const String ledger3 = _Paths.ledger3;
}

abstract class _Paths {
  static const String splash = '/';
  static const String dashboard = '/dashboard';
  static const String register = '/register';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String currentstock = '/currentstock';
  static const String finebalance = '/finebalance';
  static const String touchwisebalance = '/touchwisebalance';
  static const String itemdetails = '/itemdetails';
  static const String settings = '/settings';
  static const String ledger3 = '/ledger3';
}
