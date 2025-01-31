import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewelbook_calculator/controllers/autofill_data_controller.dart';
import 'package:jewelbook_calculator/routes/app_pages.dart';

import '../../controllers/ledger_controller.dart';

class Ledger2Screen extends StatelessWidget {
  final LedgerController _ledgerController = Get.find();
  final AutofillDataController _partyController = Get.find();

  @override
  Widget build(BuildContext context) {
    int partyId = Get.arguments as int;
    _ledgerController.selectedPartyId.value = partyId;
    _ledgerController.fetchLedgerData(partyId);

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    return WillPopScope(
      onWillPop: () async {
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
        return true;
      },
      child: Scaffold(
        appBar: _appBar(context),
        body: Obx(() {
          if (_ledgerController.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          } else if (_ledgerController.transactions.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            return Column(
              children: [
                _partyDropdown(),
                Expanded(
                  child: ListView.builder(
                    itemCount: _ledgerController.transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = _ledgerController.transactions[index];
                      return ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        title: Row(
                          children: [
                            Text(
                              '${transaction['party']} - ${transaction['item']}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 8.0),
                            _buildTransactionTypeLabel(transaction['type']),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Date: ${transaction['date']}'),
                            SizedBox(height: 4.0),
                            Text(
                                'Net Weight: ${transaction['net_weight']} | Fine: ${transaction['fine']}'),
                          ],
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                                'Weight: ${transaction['weight']} | Less: ${transaction['less']} | Add: ${transaction['add']}'),
                            SizedBox(height: 4.0),
                            Text(
                                'Touch: ${transaction['touch']} | Wastage: ${transaction['wastage']}'),
                          ],
                        ),
                        onTap: () async {
                          SystemChrome.setPreferredOrientations([
                            DeviceOrientation.portraitUp,
                            DeviceOrientation.portraitDown
                          ]);

                          final result =
                              await Get.toNamed(Routes.itemdetails, arguments: {
                            'issueItem': _ledgerController.transactions[index]
                          });

                          if (result == true) {
                            SystemChrome.setPreferredOrientations([
                              DeviceOrientation.landscapeLeft,
                              DeviceOrientation.landscapeRight
                            ]);
                            _ledgerController.fetchLedgerData(
                                _ledgerController.selectedPartyId.value);
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
        }),
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
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown
              ]);
              Get.back();
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
            // Make the dropdown take the full width of its container
            value: _ledgerController.selectedPartyId.value,
            onChanged: (int? newValue) {
              _ledgerController.selectedPartyId.value = newValue!!;
              _ledgerController.fetchLedgerData(newValue);
            },
            items: [
              DropdownMenuItem<int?>(
                value: 0, // Represents "All Parties" or no selection
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

  // Method to build the transaction type label
  Widget _buildTransactionTypeLabel(String type) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
      decoration: BoxDecoration(
        color: type == 'receive' ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        type,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }
}
