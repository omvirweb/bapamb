// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CustomNavigatorObserver extends NavigatorObserver {
  String? lastRoute;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    lastRoute = previousRoute?.settings.name;
    super.didPush(route, previousRoute);
  }
}
