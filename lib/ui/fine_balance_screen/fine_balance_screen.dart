import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewelbook_calculator/ui/fine_balance_screen/fine_balance_controller.dart';
import 'package:jewelbook_calculator/ui/ledger_screen/ledger_screen.dart';

class FineBalanceScreen extends StatelessWidget {
  const FineBalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FineBalanceController>(builder: (controller) {
      return Scaffold(
        appBar: _appBar(context),
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          } else if (controller.fineBalances.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            return _body(context, controller);
          }
        }),
      );
    });
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
        'Fine Balance',
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
      ),
    );
  }

  Widget _body(
      BuildContext context, FineBalanceController _fineBalanceController) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildListHeaders(), // Add this method to display headers
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _fineBalanceController.fineBalances.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  // Vertical padding for ListTile
                  child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 0),
                      title: Text(
                        _fineBalanceController.fineBalances[index]
                            ["party_name"],
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 14),
                      ),
                      trailing: Text(
                        _fineBalanceController.fineBalances[index]["fine"],
                        style: TextStyle(
                          fontSize: 14, // Consistent text size
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.end,
                      ),
                      onTap: () {
                        String partyId = _fineBalanceController
                                    .fineBalances[index]["party_id"] !=
                                null
                            ? _fineBalanceController.fineBalances[index]
                                    ["party_id"]
                                .toString()
                            : '0'; // Example parameter
                        Get.to(() => LedgerScreen(), arguments: int.parse(partyId));
                      }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Add this method to build the headers for the columns
  Widget _buildListHeaders() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Party',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Fine',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
