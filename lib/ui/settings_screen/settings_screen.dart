import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewelbook_calculator/ui/settings_screen/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final SettingsController controller = Get.find<SettingsController>();

    return WillPopScope(
      onWillPop: () async {
        Get.back(result: true);
        return true;
      },
      child: Scaffold(
        appBar: _appBar(context),
        body: _body(context, controller), // Pass the controller to the body
      ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      elevation: 10.0,
      backgroundColor: Colors.white,
      titleSpacing: 0,
      leading: Builder(
        builder: (context) {
          return InkWell(
            onTap: () {
              Get.back(result: true);
            },
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 25,
            ),
          );
        },
      ),
      title: Text(
        'Settings',
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
      ),
    );
  }

  Widget _body(BuildContext context, SettingsController controller) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Auto Complete Touch Checkbox
          Obx(() => CheckboxListTile(
            title: Text('Auto Complete Touch'),
            value: controller.autoCompleteTouch.value,
            onChanged: (bool? value) {
              controller.onTouchChanged(value ?? false);
            },
          )),
          // Auto Complete Notes Checkbox
          Obx(() => CheckboxListTile(
            title: Text('Auto Complete Notes'),
            value: controller.autoCompleteNotes.value,
            onChanged: (bool? value) {
              controller.onNotesChanged(value ?? false);
            },
          )),
        ],
      ),
    );
  }
}
