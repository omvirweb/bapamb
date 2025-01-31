import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewelbook_calculator/routes/app_pages.dart';
import 'package:jewelbook_calculator/services/http_service.dart';
import 'package:jewelbook_calculator/utils/preferences_service.dart';

import '../../utils/utils.dart';

class OTPController extends GetxController {
  List<TextEditingController> otpControllers =
      List.generate(6, (index) => TextEditingController());

  final Map<String, dynamic> args = Get.arguments;

  String get mobileNumber => args['mobile_number'];

  String get api_otp => args['otp'];

  var start = 60.obs;
  late Timer _timer;
  final HTTPService _httpService = HTTPService();
  final PreferencesService _preferencesService = PreferencesService();

  @override
  void onInit() {
    super.onInit();
    startTimer();
    setOTP(api_otp);
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      if (start.value == 0) {
        timer.cancel();
      } else {
        start.value--;
      }
    });
  }

  void verifyOTP() async {
    String enteredOTP =
        otpControllers.map((controller) => controller.text).join();

    final data = {
      'mobile_number': mobileNumber,
      'otp': enteredOTP,
    };
    try {
      final response = await _httpService.make_api_call('/verify-otp', data);

      if (response.data['status'] == 1) {
        await _preferencesService.saveBool('checkLogin', true);
        await _preferencesService.saveString(
            'api_token', response.data['api_token']);
        Get.snackbar('Success', 'OTP Verified!');
        registerControllers();
        Get.offAllNamed(Routes.dashboard);
      } else {
        Get.snackbar('Error', 'Incorrect OTP. Please try again.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to verify OTP. Please try again later.');
    }
  }

  void resendOTP() async {
    start.value = 60; // Reset timer to 60 seconds
    startTimer(); // Restart the timer

    try {
      final response = await _httpService.make_api_call_new('/login', {
        'mobile_number': mobileNumber,
      });
      if (response.data['status'] == 1) {
        Get.snackbar(
            'OTP Sent', 'A new OTP has been sent to your mobile number.');
        setOTP(response.data['otp']);
      } else {
        Get.snackbar('Error', 'Failed to resend OTP. Please try again later.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to resend OTP. Please try again later.');
    }
  }

  // New method to set OTP
  void setOTP(String otp) {
    for (int i = 0; i < otp.length; i++) {
      otpControllers[i].text = otp[i];
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    otpControllers.forEach((controller) => controller.dispose());
    super.onClose();
  }
}
