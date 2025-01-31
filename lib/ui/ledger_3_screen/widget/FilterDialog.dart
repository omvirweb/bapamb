import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../widget/DefaultButton.dart';
import '../../../widget/DefaultTextFieldPopup.dart';
import '../ledger_3_controller.dart';
import 'CustomCheckbox.dart';
import 'ItemsDropDown.dart';
import 'NotesDropDown.dart';
import 'PartyDropDown.dart';
import 'TouchDropDown.dart';

class FilterDialog extends StatelessWidget {
  final Ledger3Controller controller;
  

  FilterDialog({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      height: MediaQuery.of(context).size.height - 50,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter Transactions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Obx(() {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('From Date:'),
                        TextButton(
                          onPressed: () async {
                            DateTime? initialDate =
                                controller.fromDate.value.isNotEmpty
                                    ? DateFormat('dd-MM-yyyy')
                                        .parse(controller.fromDate.value)
                                    : DateTime.now();

                            DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: initialDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                            );

                            if (selectedDate != null) {
                              controller.fromDate.value =
                                  DateFormat('dd-MM-yyyy').format(selectedDate);
                            }
                          },
                          child: Text(
                            controller.fromDate.value.isNotEmpty
                                ? controller.fromDate.value
                                : 'Select Date',
                          ),
                        ),
                      ],
                    );
                  }),
                  Obx(() {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('To Date:'),
                        TextButton(
                          onPressed: () async {
                            DateTime? initialDate =
                                controller.toDate.value.isNotEmpty
                                    ? DateFormat('dd-MM-yyyy')
                                        .parse(controller.toDate.value)
                                    : DateTime.now();

                            DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: initialDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                            );

                            if (selectedDate != null) {
                              controller.toDate.value =
                                  DateFormat('dd-MM-yyyy').format(selectedDate);
                            }
                          },
                          child: Text(
                            controller.toDate.value.isNotEmpty
                                ? controller.toDate.value
                                : 'Select Date',
                          ),
                        ),
                      ],
                    );
                  }),
                  Obx(() {
                    return CustomCheckbox(
                      label: 'Checked Only',
                      value: controller.isCheckedOnly.value,
                      onChanged: (value) {
                        controller.setCheckedOnly(value);
                      },
                    );
                  }),
                  Obx(() {
                    return CustomCheckbox(
                      label: 'Unchecked Only',
                      value: controller.isUncheckedOnly.value,
                      onChanged: (value) {
                        controller.setUncheckedOnly(value);
                      },
                    );
                  }),
                  DefaultTextFieldPopup(
                    hint_txt: "Enter Weight",
                    label_txt: "Weight",
                    keyboard_type: TextInputType.number,
                    txtController: controller.weightTxtController,
                    textInputAction: TextInputAction.next,
                  ),
                  DefaultTextFieldPopup(
                    hint_txt: "Enter Wastage",
                    label_txt: "Wastage",
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'))
                    ],
                    keyboard_type: TextInputType.number,
                    txtController: controller.wastageTxtController,
                    textInputAction: TextInputAction.next,
                  ),
                  GetBuilder<Ledger3Controller>(
                    id: controller.partyDropdown,
                    builder: (controller) {
                      return PartyDropDown();
                    },
                  ),
                  GetBuilder<Ledger3Controller>(
                    id: controller.itemDropdown,
                    builder: (controller) {
                      return ItemsDropDown();
                    },
                  ),
                  GetBuilder<Ledger3Controller>(
                    id: controller.touchDropdown,
                    builder: (controller) {
                      return TouchDropDown();
                    },
                  ),
                  GetBuilder<Ledger3Controller>(
                    id: controller.noteDropdown,
                    builder: (controller) {
                      return NotesDropDown();
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: DefaultButton(
                    text: "Clear Filters",
                    press: () {
                      controller.clearFilters();
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: DefaultButton(
                    text: "Apply Filters",
                    press: () {
                      controller.selectedWeight.value =
                          controller.weightTxtController.text;
                      controller.selectedWastage.value =
                          controller.wastageTxtController.text;

                      Navigator.pop(context);
                      controller.fetchLedgerData();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
