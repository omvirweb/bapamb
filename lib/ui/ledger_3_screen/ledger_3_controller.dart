import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewelbook_calculator/utils/preferences_service.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../controllers/autofill_data_controller.dart';
import '../../services/http_service.dart';

class Ledger3Controller extends GetxController {

  final TextEditingController wastageTxtController = TextEditingController();
  final TextEditingController weightTxtController = TextEditingController();

  static Ledger3Controller get instance => Get.find();
  final AutofillDataController autofillDataController = Get.find();

  final String partyDropdown = "partyDropdown";
  final String itemDropdown = "itemDropdown";
  final String touchDropdown = "touchDropdown";
  final String noteDropdown = "noteDropdown";

  final HTTPService _httpService = Get.find();
  final PreferencesService _preferencesService = PreferencesService();
  var transactions = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  var selectedPartyId = 0.obs;
  var selectedItemId = 0.obs;
  var selectedNote = ''.obs;
  var selectedTouch = ''.obs;
  var selectedWeight = ''.obs;
  var selectedWastage = ''.obs;
  var parties = <Map<String, dynamic>>[].obs;
  var fromDate = ''.obs;
  var toDate = ''.obs;
  var isCheckedOnly = true.obs;
  var isUncheckedOnly = true.obs;

  @override
  void onInit() {
    fetchLedgerData();
     weightTxtController.text = selectedWeight.value;
    wastageTxtController.text = selectedWastage.value;
    super.onInit();
  }

  void fetchLedgerData() async {
    try {
      final String api_token = await _preferencesService.getString('api_token', "") ?? "";
      isLoading(true);

      final params = {'api_token': api_token};
      if (selectedPartyId.value != null && selectedPartyId.value != 0) {
        params['party_id'] = selectedPartyId.value.toString();
      }
      if (selectedItemId.value != null && selectedItemId.value != 0) {
        params['item_id'] = selectedItemId.value.toString();
      }
      if (selectedTouch.value.isNotEmpty) {
        params['touch'] = selectedTouch.value;
      }
      if (selectedNote.value.isNotEmpty) {
        params['notes'] = selectedNote.value;
      }
      if (selectedWeight.value.trim()!="") {
        params['weight'] = selectedWeight.value;
      }
      if (selectedWastage.value.isNotEmpty) {
        params['wastage'] = selectedWastage.value;
      }
      if (fromDate.value.isNotEmpty) {
        params['start_date'] = DateFormat('yyyy-MM-dd').format(DateFormat('dd-MM-yyyy').parse(fromDate.value));
      }
      if (toDate.value.isNotEmpty) {
        params['end_date'] = DateFormat('yyyy-MM-dd').format(DateFormat('dd-MM-yyyy').parse(toDate.value));
      }
      if (isCheckedOnly.value) {
        params['is_checked'] = '1';
      }else{
        params['is_checked'] = '0';
      }
      if (isUncheckedOnly.value) {
        params['is_unchecked'] = '1';
      }else{
        params['is_unchecked'] = '0';
      }

      print(params);

      final response = await _httpService.make_api_call_new('ledger', params);

      if (response.data['status'] == 1) {
        transactions.value = List<Map<String, dynamic>>.from(response.data['records']['data']);
       
        print("transactions : " + transactions.value.length.toString());
      } else {
        Get.snackbar('Error', response.data['message']);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load data');
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateTransactionCheckedStatus(Map<String, dynamic> transaction, int isChecked) async {
  try {
      final String api_token = await _preferencesService.getString('api_token', "") ?? "";
      final params = {'api_token': api_token,'transaction_id': transaction['id'],'is_checked': isChecked};

      print(params);

      final response = await _httpService.make_api_call_new('check_status', params);
print(response.data);
      if (response.data['status'] == 1) {
          transaction['is_checked'] = isChecked;
          update();
      } else {
        Get.snackbar('Error', response.data['message']);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to save data');
    } finally {
    }
  }

  Future<void> generateAndSavePdf() async {
    try {
      final pdf = pw.Document();

      final logoImage = await _loadImage('assets/images/app_icon.png');

      List<Map<String, dynamic>> issueTransactions = transactions
          .where((transaction) => transaction['type'] == 'issue')
          .toList();

      List<Map<String, dynamic>> receiveTransactions = transactions
          .where((transaction) => transaction['type'] == 'receive')
          .toList();

      pdf.addPage(
        pw.Page(
          build: (context) {
            return pw.Stack(
              children: [
                pw.Center(
                  child: pw.Opacity(
                    opacity: 0.1,
                    child: pw.Image(logoImage),
                  ),
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Ledger Transactions',
                        style: pw.TextStyle(
                            fontSize: 24, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 10),

                    pw.Text('Issue Transactions',
                        style: pw.TextStyle(
                            fontSize: 20, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 5),
                    pw.Table.fromTextArray(
                      headers: ['Date', 'Gross', 'Touch', 'Fine', 'Balance'],
                      data: issueTransactions.map((transaction) {
                        return [
                          transaction['date'],
                          transaction['gross'].toString(),
                          transaction['touch'].toString(),
                          transaction['fine'].toString(),
                          transaction['balance'].toString(),
                        ];
                      }).toList(),
                      cellAlignment: pw.Alignment.centerRight,
                    ),

                    if (receiveTransactions.isNotEmpty) ...[
                      pw.SizedBox(height: 10),
                      pw.Text('Receive Transactions',
                          style: pw.TextStyle(
                              fontSize: 20, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 5),
                      pw.Table.fromTextArray(
                        headers: ['Date', 'Gross', 'Touch', 'Fine', 'Balance'],
                        data: receiveTransactions.map((transaction) {
                          return [
                            transaction['date'],
                            transaction['gross'].toString(),
                            transaction['touch'].toString(),
                            transaction['fine'].toString(),
                            transaction['balance'].toString(),
                          ];
                        }).toList(),
                        cellAlignment: pw.Alignment.centerRight,
                      ),
                    ],

                    pw.Spacer(),
                    pw.Divider(),
                    pw.SizedBox(height: 10),
                    pw.Text('Powered by JewelBook',
                        style: pw.TextStyle(
                            fontSize: 12, fontStyle: pw.FontStyle.italic)),
                  ],
                ),
              ],
            );
          },
        ),
      );

      final currentTime = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final fileName = 'ledger_$currentTime.pdf';

      final directory = Directory('/storage/emulated/0/Download');
      if (!(await directory.exists())) {
        await directory.create(recursive: true);
      }

      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);

      await file.writeAsBytes(await pdf.save());
      Get.snackbar("Download Complete", "PDF saved to ${file.path}");
    } catch (e) {
      print("Error generating or saving PDF: $e");
      Get.snackbar("Error", "Failed to save PDF");
    }
  }

  Future<pw.MemoryImage> _loadImage(String path) async {
    final ByteData bytes = await rootBundle.load(path);
    final Uint8List imageData = bytes.buffer.asUint8List();
    return pw.MemoryImage(imageData);
  }

  void setFromDate(String date) {
    fromDate.value = date;
    update();
  }

  void setToDate(String date) {
    toDate.value = date;
    update();
  }

  void setCheckedOnly(bool? value) {
    isCheckedOnly.value = value ?? false;
    update();
  }

  void setUncheckedOnly(bool? value) {
    isUncheckedOnly.value = value ?? false;
    update();
  }

  void clearFilters() {
    selectedPartyId.value = 0;
    selectedItemId.value = 0;
    selectedNote.value = '';
    selectedTouch.value = '';
    fromDate.value = '';
    toDate.value = '';
    selectedWeight = ''.obs;
    selectedWastage = ''.obs;
    weightTxtController.text = '';
    wastageTxtController.text = '';
    isCheckedOnly.value = true;
    isUncheckedOnly.value = true;
    update();
    fetchLedgerData();
  }

    @override
  void onClose() {
    weightTxtController.dispose();
    wastageTxtController.dispose();
    super.onClose();
  }

}
