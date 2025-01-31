import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewelbook_calculator/ui/ledger_2_screen/ledger_2_screen.dart';
import 'package:jewelbook_calculator/ui/touchwise_balance_screen/touchwise_balance_controller.dart';

class TouchwiseBalanceScreen extends StatelessWidget {
  const TouchwiseBalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TouchwiseBalanceController>(builder: (controller) {
      return Scaffold(
          appBar: _appBar(context),
          body: Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            } else if (controller.touchwiseBalances.isEmpty) {
              return Center(child: Text('No data available'));
            } else {
              return _body(context, controller);
            }
          }));
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
        'Touchwise Balance',
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
      ),
    );
  }

  Widget _body(BuildContext context,
      TouchwiseBalanceController _touchwiseBalanceController) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: ListView.builder(
        itemCount: _touchwiseBalanceController.touchwiseBalances.length,
        itemBuilder: (context, index) {
          final partyData =
              _touchwiseBalanceController.touchwiseBalances[index];
          return InkWell(
            onTap: () {
              String partyId = _touchwiseBalanceController
                          .touchwiseBalances[index]["party_id"] !=
                      null
                  ? _touchwiseBalanceController.touchwiseBalances[index]
                          ["party_id"]
                      .toString()
                  : '0'; // Example parameter
              Get.to(() => Ledger2Screen(), arguments: int.parse(partyId));
            },
            child: Card(
              margin: EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      partyData["party"],
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          partyData["total"],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            /*color: partyData["total"] < 0
                                ? Colors.red
                                : Colors.black,*/
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Divider(color: Colors.grey),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: partyData["entries"].length,
                      itemBuilder: (context, subIndex) {
                        final entry = partyData["entries"][subIndex];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(entry["touch"].toString()),
                              Text(
                                entry["fine"],
                                style: TextStyle(
                                  /* color: entry["fine"] < 0
                                      ? Colors.red
                                      : Colors.black,*/
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
