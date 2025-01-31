import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/android_id.dart';

class HTTPService {
  final dio.Dio _dio = dio.Dio();

  HTTPService() {
    _configureDio();
  }

  void _configureDio() {
    _dio.options = dio.BaseOptions(
      baseUrl: "http://139.59.82.50/karigarapi/public/api/",
    );
  }

  Future<dio.Response<dynamic>> make_api_call_new(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    String? device_id = await AndroidId.getAndroidId();

    print("device_id : " + device_id!!);
    print("make_api_call : " + endpoint);
    try {
      data['device_name'] = device_id;
      final response = await _dio.post(endpoint, data: data);
      return response;
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }

  Future<dio.Response<dynamic>> make_api_call(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    String? device_id = await AndroidId.getAndroidId();
    print("device_id : " + device_id!!);
    print("make_api_call : " + endpoint);
    try {
      data['device_name'] = device_id;
      _showLoader();
      final response = await _dio.post(endpoint, data: data);

      _hideLoader();

      return response;
    } catch (e) {
      _hideLoader();
      print('Error: $e');
      throw e;
    }
  }

  void _showLoader() {
    Get.dialog(
      Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
  }

  void _hideLoader() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}
