import 'package:get/get.dart';
import 'package:jewelbook_calculator/controllers/autofill_data_controller.dart';
import 'package:jewelbook_calculator/controllers/received_item_controller.dart';

import '../controllers/issue_item_controller.dart';
import '../controllers/ledger_controller.dart';
import '../services/http_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

Future<void> registerServices() async {
  Get.put(
    HTTPService(),
  );
}

Future<void> registerControllers() async {
  Get.put(IssueItemController());
  Get.put(ReceivedItemController());

  Get.put(LedgerController());
  Get.put(AutofillDataController());
}

Future<String?> getDeviceId() async {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    // Get Android-specific device information
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.id;
  } else if (Platform.isIOS) {
    // Get iOS-specific device information
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    return iosInfo.identifierForVendor;
  }
  return null;
}
