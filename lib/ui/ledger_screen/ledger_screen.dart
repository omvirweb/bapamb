import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewelbook_calculator/controllers/autofill_data_controller.dart';
import 'package:jewelbook_calculator/controllers/ledger_controller.dart';
import 'package:jewelbook_calculator/routes/app_pages.dart';
import 'package:pdf/widgets.dart' as pw;

class LedgerScreen extends StatelessWidget {
  final LedgerController _ledgerController = Get.find();
  final AutofillDataController _partyController = Get.find();

  @override
  Widget build(BuildContext context) {
    int partyId = Get.arguments as int;
    _ledgerController.selectedPartyId.value = partyId;
    _ledgerController.fetchLedgerData(partyId);

    return Scaffold(
      appBar: _appBar(context),
      body: Obx(() {
        if (_ledgerController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (_ledgerController.transactions.isEmpty) {
          return Center(child: Text('No data available'));
        } else {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                _partyDropdown(),
                _buildListHeaders(),
                Expanded(
                  child: ListView.builder(
                    itemCount: _ledgerController.transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = _ledgerController.transactions[index];
                      return ListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                flex: 2,
                                child: Text(transaction["date"],
                                    style: TextStyle(fontSize: 12))),
                            Expanded(
                                flex: 2,
                                child: Text(transaction["gross"],
                                    style: TextStyle(fontSize: 12))),
                            Expanded(
                                flex: 2,
                                child: Text(transaction["fine"],
                                    style: TextStyle(fontSize: 12))),
                            Expanded(
                                flex: 2,
                                child: Text(transaction["balance"].toString(),
                                    style: TextStyle(fontSize: 12))),
                          ],
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _buildTransactionTypeLabel(transaction['type']),
                          ],
                        ),
                        onTap: () async {
                          await Get.toNamed(Routes.itemdetails, arguments: {
                            'issueItem': _ledgerController.transactions[index]
                          });

                          _ledgerController.fetchLedgerData(
                              _ledgerController.selectedPartyId.value);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
      }),
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
              Get.back(); // Navigate back
            },
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 25,
            ),
          );
        },
      ),
      title: Text(
        'Ledger',
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.download),
          onPressed: () async {
            print("Download button clicked");
            await _generateAndSavePdf();
          },
        ),
      ],
    );
  }

  Widget _partyDropdown() {
    return Obx(() {
      return Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.grey.shade300, width: 1.5),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<int?>(
            isExpanded: true,
            value: _ledgerController.selectedPartyId.value,
            onChanged: (int? newValue) {
              _ledgerController.selectedPartyId.value = newValue!;
              _ledgerController.fetchLedgerData(newValue);
            },
            items: [
              DropdownMenuItem<int?>(
                value: 0,
                child: Text('All Parties', style: TextStyle(fontSize: 16)),
              ),
              ..._partyController.parties.map((party) {
                return DropdownMenuItem<int?>(
                  value: party['id'],
                  child:
                      Text(party['party_name'], style: TextStyle(fontSize: 16)),
                );
              }).toList(),
            ],
            style: TextStyle(fontSize: 16, color: Colors.black),
            icon: Icon(Icons.arrow_drop_down, color: Colors.black),
          ),
        ),
      );
    });
  }

  Widget _buildListHeaders() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 2,
            child: Text('Gross', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 2,
            child: Text('Fine', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 2,
            child:
                Text('Balance', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionTypeLabel(String type) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
      decoration: BoxDecoration(
        color: type == 'receive' ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        type,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 8,
        ),
      ),
    );
  }

  Future<void> _generateAndSavePdf() async {
    try {
      final pdf = pw.Document();

      // Load the logo image
      final logoImage = await _loadImage('assets/images/app_icon.png');

      // Add content to the PDF
      pdf.addPage(
        pw.Page(
          build: (context) {
            return pw.Stack(
              children: [
                // Watermark logo
                pw.Center(
                  child: pw.Opacity(
                    opacity: 0.1, // Set opacity for the watermark
                    child: pw.Image(logoImage),
                  ),
                ),
                // Main content
                pw.Column(
                  children: [
                    pw.Text('Ledger Transactions',
                        style: pw.TextStyle(
                            fontSize: 24, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 10),
                    pw.Table.fromTextArray(
                      headers: [
                        'Date',
                        'Type',
                        'Gross',
                        'Touch',
                        'Fine',
                        'Balance'
                      ],
                      data: _ledgerController.transactions.map((transaction) {
                        return [
                          transaction['date'],
                          transaction['type'].toString(),
                          transaction['gross'].toString(),
                          transaction['touch'].toString(),
                          transaction['fine'].toString(),
                          transaction['balance'].toString(),
                        ];
                      }).toList(),
                      cellAlignment: pw.Alignment.centerRight,
                    ),
                    pw.Spacer(), // Add some space to push footer to bottom
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

      // Create a directory to save the PDF file
      final directory =
          Directory('/storage/emulated/0/Download'); // Downloads folder
      if (!(await directory.exists())) {
        await directory.create(recursive: true);
      }

      // Specify the file path
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);

      // Save the PDF file
      await file.writeAsBytes(await pdf.save());
      Get.snackbar("Download Complete", "PDF saved to ${file.path}");
    } catch (e) {
      print("Error generating or saving PDF: $e");
      Get.snackbar("Error", "Failed to save PDF");
    }
  }

// Load the image from assets
  Future<pw.MemoryImage> _loadImage(String path) async {
    final ByteData bytes = await rootBundle.load(path);
    final Uint8List imageData = bytes.buffer.asUint8List();
    return pw.MemoryImage(imageData);
  }
}
