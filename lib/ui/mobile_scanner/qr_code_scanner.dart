import 'package:flutter/material.dart';
import 'package:jewelbook_calculator/ui/issue_item_screen/issue_item_screen.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:jewelbook_calculator/ui/issue_item/issue_Item_screen.dart';

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
          // Add instructions or animations if necessary
          Positioned(
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
      if (isProcessing) return;
      setState(() => isProcessing = true);

      final code = scanData.code ?? 'Unknown QR Code';
      print("Scanned QR Code: $code");

      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => IssueItemScreen(),
        ),
      );

      setState(() => isProcessing = false);
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
