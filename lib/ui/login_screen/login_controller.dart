import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jewelbook_calculator/routes/app_pages.dart';

import '../../services/http_service.dart';

class LoginController extends GetxController {
  final TextEditingController mobilenumber = TextEditingController();
  final HTTPService _httpService = HTTPService();

  Future<void> login() async {
    if (mobilenumber.text.isNotEmpty) {
      final data = {
        'mobile_number': mobilenumber.text,
      };

      try {
        final response = await _httpService.make_api_call('/login', data);

        if (response.data['status'] == 1) {
          Get.toNamed(Routes.otp, arguments: {
            'mobile_number': mobilenumber.text,
            'otp': response.data['otp'].toString()
          });
        } else {
          Get.snackbar('Error', 'Login failed. Please try again.');
        }
      } catch (e) {
        print('Login failed: $e');
        Get.snackbar('Error', 'Failed to login. Please try again.');
      }
    } else {
      Get.snackbar('Error', 'Please enter a mobile number.');
    }
  }
}
