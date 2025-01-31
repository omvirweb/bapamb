import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewelbook_calculator/ui/current_stock_screen/current_stock_controller.dart';

class CurrentStockScreen extends StatelessWidget {
  const CurrentStockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CurrentStockController>(builder: (controller) {
      return Scaffold(
        appBar: _appBar(context),
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          } else if(controller.currentStock.isEmpty){
            return Center(child: Text('No data available'));
          }else {
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
              Get.back(); // Go back to the previous screen
            },
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 25,
            ),
          );
        },
      ),
      title: Text(
        'Current Stock',
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
      ),
    );
  }

  Widget _body(
      BuildContext context, CurrentStockController _currentStockController) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildListHeaders(), // Add this method to display headers
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _currentStockController.currentStock.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    title: Text(
                      _currentStockController.currentStock[index]["item"],
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _currentStockController.currentStock[index]["gross"],
                          style: TextStyle(fontSize: 14),
                          textAlign: TextAlign.end,
                        ),
                        SizedBox(width: 20),
                        Text(
                          _currentStockController.currentStock[index]["touch"],
                          style: TextStyle(fontSize: 14),
                          textAlign: TextAlign.end,
                        ),
                        SizedBox(width: 20),
                        Text(
                          _currentStockController.currentStock[index]["fine"],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

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
              'Item',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Gross',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.end,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Touch',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.end,
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
