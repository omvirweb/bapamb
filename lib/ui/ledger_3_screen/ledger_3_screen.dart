import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewelbook_calculator/routes/app_pages.dart';
import 'package:jewelbook_calculator/ui/ledger_3_screen/ledger_3_controller.dart';
import 'package:jewelbook_calculator/ui/ledger_3_screen/widget/PartyDropDownScreen.dart';

import 'widget/FilterDialog.dart';

class Ledger3Screen extends StatelessWidget {
  const Ledger3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Ledger3Controller>(builder: (controller) {
      return Scaffold(
        appBar: _appBar(context, controller),
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          } else if (controller.transactions.isEmpty) {
            return Column(
                children: [
                  GetBuilder<Ledger3Controller>(
                      id: controller.partyDropdown,
                      builder: (controller) {
                        return const PartyDropDownScreen();
                      }),
                      Expanded(child: Center(child: Text('No data available')))
                ]
            );
            // return Center(child: Text('No data available'));
          } else {
            List<Map<String, dynamic>> issueTransactions = controller
                .transactions.value
                .where((transaction) => transaction['type'] == 'issue')
                .toList()
              ..sort((a, b) {
                DateTime dateA = DateFormat('dd-MM-yyyy').parse(a['date']);
                DateTime dateB = DateFormat('dd-MM-yyyy').parse(b['date']);
                return dateA.compareTo(dateB);
              });

            List<Map<String, dynamic>> receiveTransactions = controller
                .transactions.value
                .where((transaction) => transaction['type'] == 'receive')
                .toList()
              ..sort((a, b) {
                DateTime dateA = DateFormat('dd-MM-yyyy').parse(a['date']);
                DateTime dateB = DateFormat('dd-MM-yyyy').parse(b['date']);
                return dateA.compareTo(dateB);
              });

            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  GetBuilder<Ledger3Controller>(
                      id: controller.partyDropdown,
                      builder: (controller) {
                        return const PartyDropDownScreen();
                      }),
                  _buildListHeaders(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: issueTransactions.length + 1 + (receiveTransactions.isNotEmpty ? 1 : 0) + receiveTransactions.length,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          // Header for Issue Transactions
                          if (issueTransactions.length > 0){
                            return Container(
                              padding: EdgeInsets.all(8.0),
                              color: Colors.blueAccent, // Header color
                              width: double.infinity,
                              child: Text(
                                'Issue Transactions',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            );
                        }else{
                          return Text("");
                        }
                        } else if (index <= issueTransactions.length) {
                          // Issue transaction tiles
                          final transaction = issueTransactions[index - 1];
                          return _buildTransactionTile(transaction, controller);
                        } else if (receiveTransactions.isNotEmpty &&
                            index == issueTransactions.length + 1) {
                          // Header for Receive Transactions
                          return Container(
                            padding: EdgeInsets.all(8.0),
                            color: Colors.blueAccent, // Header color
                            width: double.infinity,
                            child: Text(
                              'Receive Transactions',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          );
                        } else {
                          // Receive transaction tiles
                          final transaction = receiveTransactions[
                              index - issueTransactions.length - 2];
                          return _buildTransactionTile(transaction, controller);
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        }),
      );
    });
  }

  PreferredSizeWidget _appBar(
      BuildContext context, Ledger3Controller controller) {
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
        'Ledger 3',
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.download),
          onPressed: () async {
            print("Download button clicked");
            await controller.generateAndSavePdf();
          },
        ),
        IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog(controller);
            } // Call the filter dialog method
            ),
      ],
    );
  }

  Widget _buildListHeaders() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(color: Colors.grey.shade300),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              flex: 2,
              child:
                  Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
              flex: 2,
              child:
                  Text('Gross', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
              flex: 2,
              child:
                  Text('Fine', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
              flex: 2,
              child: Text('Balance',
                  style: TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildTransactionTile(
      Map<String, dynamic> transaction, Ledger3Controller _ledgerController) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8.0),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              flex: 3,
              child: Text(transaction["date"], style: TextStyle(fontSize: 12))),
          Expanded(
              flex: 2,
              child:
                  Text(transaction["gross"], style: TextStyle(fontSize: 12))),
          Expanded(
              flex: 2,
              child: Text(transaction["fine"], style: TextStyle(fontSize: 12))),
          Expanded(
              flex: 2,
              child: Text(transaction["balance"].toString(),
                  style: TextStyle(fontSize: 12))),
          Checkbox(
            value: transaction['is_checked'] == 1, // Convert 1/0 to true/false
            onChanged: (value) {
              int isChecked = value! ? 1 : 0; // Convert true/false to 1/0
              _ledgerController.updateTransactionCheckedStatus(transaction, isChecked);
            },
          ),
        ],
      ),
      onTap: () async {
        await Get.toNamed(Routes.itemdetails,
            arguments: {'issueItem': transaction});

        _ledgerController
            .fetchLedgerData();
      },
    );
  }

  _showFilterDialog(Ledger3Controller controller) {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      builder: (context) {
        return FilterDialog(controller: controller);
      },
    );
  }
}
