import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jewelbook_calculator/ui/issue_item_screen/issue_item_screen.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class qrCodeScanner extends StatefulWidget {
  @override
  _qrCodeScannerState createState() => _qrCodeScannerState();
}

class _qrCodeScannerState extends State<qrCodeScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isProcessing = false;

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      if (mounted) {
        controller!.pauseCamera();
        controller!.resumeCamera();
      }
    }
  }

  Future<void> fetchAndNavigate(String qrCodeValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionToken = prefs.getString('auth_token');

    try {
      var response = await http.get(
        Uri.parse(
            'http://20.244.92.124/bapaapi/public/api/item-stock-rfid/$qrCodeValue?party_id=4214'),
        headers: {
          'Authorization': 'Bearer $sessionToken',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        print(responseBody);

        if (responseBody['status'] == true) {
          Map<String, dynamic> data = responseBody['data'];
          print(data);

          Get.snackbar(
            "Success",
            "Scanned successfully!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );

          // ✅ First Pause & Stop the Camera
          await controller?.pauseCamera();

          // ✅ Navigate to next screen
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => IssueItemScreen(data: data),
            ),
          );

          // ✅ Resume camera ONLY if user comes back
          await controller?.resumeCamera();
        } else {
          _showError('Error: ${responseBody['message']}');
        }
      } else {
        _showError('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      _showError('An error occurred: $e');
    } finally {
      setState(() => isProcessing = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10.0,
        backgroundColor: Colors.white,
        titleSpacing: 0,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_new_rounded, size: 25),
        ),
        title: const Text(
          'Scan QR Code',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
        ),
      ),
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.red,
              borderWidth: 4,
              borderRadius: 10,
              borderLength: 30,
              cutOutSize: MediaQuery.of(context).size.width * 0.7,
            ),
          ),
          const Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Align the QR code within the frame to scan',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (isProcessing) return; // Prevent multiple scans
      setState(() => isProcessing = true);

      final qrCodeValue = scanData.code ?? '';
      print("Scanned QR Code: $qrCodeValue");

      // ✅ Scan complete -> Fetch API & navigate
      await fetchAndNavigate(qrCodeValue);
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
