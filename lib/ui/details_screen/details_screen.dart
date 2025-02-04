import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewelbook_calculator/ui/issue_item_screen/issue_item_screen.dart';
import 'package:jewelbook_calculator/ui/received_item_screen/received_item_screen.dart';

import 'item_details_controller.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ItemDetailsController>(builder: (controller) {
      return WillPopScope(
        onWillPop: () async {
          print("Back button pressed!");
          Get.back(result: true);
          return true;
        },
        child: Scaffold(
          appBar: _buildAppBar(context, controller),
          body: _buildBody(controller.itemDetails),
        ),
      );
    });
  }

  AppBar _buildAppBar(BuildContext context, ItemDetailsController controller) {
    return AppBar(
      elevation: 10.0,
      backgroundColor: Colors.white,
      title: const Text(
        'Item Details',
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 25),
        onPressed: () => Get.back(result: true),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () async {
            // _handleEdit(controller);
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            _showDeleteConfirmationDialog(context, controller);
          },
        ),
      ],
    );
  }

  // Future<void> _handleEdit(ItemDetailsController controller) async {
  //   final result = await Get.to(() => controller.itemDetails['type'] == 'issue'
  //       ?  IssueItemScreen()
  //       :  ReceivedItemScreen(), arguments: controller.itemDetails);

  //   if (result != null) {
  //     controller.updateItem(result);
  //   }
  // }

  void _showDeleteConfirmationDialog(
      BuildContext context, ItemDetailsController _itemDetailsController) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Future.delayed(Duration(milliseconds: 300), () {
                  Navigator.of(context).pop();
                });

                Future.delayed(Duration(milliseconds: 600), () {
                  _itemDetailsController.deleteItem(
                      _itemDetailsController.itemDetails['id'].toString());
                  if (_itemDetailsController.isSuccess.value) {
                    Get.snackbar(
                        'Success', "" + _itemDetailsController.msg.value);
                  }
                });

                Future.delayed(Duration(milliseconds: 1000), () {
                  _itemDetailsController.deleteItem(
                      _itemDetailsController.itemDetails['id'].toString());
                  if (_itemDetailsController.isSuccess.value) {
                    Get.back(result: true);
                  }
                });
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBody(Map<String, dynamic> itemDetails) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(itemDetails),
            const SizedBox(height: 20),
            _buildDetailsSection(itemDetails),
            const SizedBox(height: 20),
            _buildFineCalculationSection(itemDetails),
            const SizedBox(height: 20),
            _buildNotesSection(itemDetails),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(Map<String, dynamic> itemDetails) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          itemDetails['party'] ?? 'N/A',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(
          itemDetails['date'] ?? 'N/A',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 10),
        Text(
          'Type: ${itemDetails['type'] ?? 'N/A'}',
          style: const TextStyle(fontSize: 16, color: Colors.blueAccent),
        ),
      ],
    );
  }

  Widget _buildDetailsSection(Map<String, dynamic> itemDetails) {
    return _buildCard(
      children: [
        _buildDetailRow('Item', itemDetails['item']),
        _buildDetailRow('Weight', itemDetails['weight']),
        _buildDetailRow('Less', itemDetails['less']),
        _buildDetailRow('Add', itemDetails['add']),
        _buildDetailRow('Net Weight', itemDetails['net_weight']),
      ],
    );
  }

  Widget _buildFineCalculationSection(Map<String, dynamic> itemDetails) {
    return _buildCard(
      children: [
        _buildDetailRow('Touch', itemDetails['touch']),
        _buildDetailRow('Wastage', itemDetails['wastage']),
        _buildDetailRow('Fine', itemDetails['fine']),
      ],
    );
  }

  Widget _buildNotesSection(Map<String, dynamic> itemDetails) {
    return _buildCard(
      children: [
        const Text(
          'Notes',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        Text(
          itemDetails['notes'] ?? 'No notes available.',
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Text(value?.toString() ?? 'N/A',
              style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
