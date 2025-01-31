import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewelbook_calculator/controllers/autofill_data_controller.dart';
import 'package:jewelbook_calculator/controllers/received_item_controller.dart';
import 'package:jewelbook_calculator/widget/ItemAutocompleteWidget.dart';
import 'package:jewelbook_calculator/widget/NotesAutocompleteWidget.dart';
import 'package:jewelbook_calculator/widget/PartyAutocompleteWidget.dart';

import '../../widget/DefaultButton.dart';
import '../../widget/DefaultTextField.dart';
import '../../widget/TouchAutocompleteWidget.dart';

class ReceivedItemScreen extends StatelessWidget {
  String t_id = "";
  bool isEdit = true;
  final TextEditingController weightTxtController = TextEditingController();
  final TextEditingController lessTxtController = TextEditingController();
  final TextEditingController addTxtController = TextEditingController();
  final TextEditingController touchTxtController = TextEditingController();
  final TextEditingController wastageTxtController = TextEditingController();
  final TextEditingController dateTxtController = TextEditingController();
  final TextEditingController notesTxtController = TextEditingController();

  final ReceivedItemController _receivedItemController = Get.find();
  final AutofillDataController _autofillDataController = Get.find();

  ReceivedItemScreen({super.key}) {
    if (Get.arguments != null) {
      final reciveItem = Get.arguments;
      isEdit = false;
      t_id = (reciveItem['id']?.toString()) ?? '';
      weightTxtController.text = (reciveItem['weight']?.toString()) ?? '';
      lessTxtController.text = (reciveItem['less']?.toString()) ?? '';
      addTxtController.text = (reciveItem['add']?.toString()) ?? '';
      touchTxtController.text = (reciveItem['touch']?.toString()) ?? '';
      wastageTxtController.text = (reciveItem['wastage']?.toString()) ?? '';
      dateTxtController.text =
          (reciveItem['date'] ?? _getCurrentDate()); // Use current date if null
      notesTxtController.text = reciveItem['notes'] ?? '';

      _autofillDataController.selectedPartyId.value =
          (reciveItem['party_id']?.toString()) ?? '';
      _autofillDataController.selectedPartyName.value =
          reciveItem['party'] ?? '';
      _autofillDataController.selectedItemId.value =
          (reciveItem['item_id']?.toString()) ?? '';
      _autofillDataController.selectedItemName.value = reciveItem['item'] ?? '';

      _receivedItemController.net_weight.value =
          double.tryParse(reciveItem['net_weight']?.toString() ?? '0.0')!;
      _receivedItemController.final_fine.value =
          double.tryParse(reciveItem['fine']?.toString() ?? '0.0')!;
    } else {
      dateTxtController.text = _getCurrentDate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _autofillDataController.selectedPartyName.value = '';
        _autofillDataController.selectedItemName.value = '';
        return true;
      },
      child: Scaffold(
        appBar: _appBar(context),
        body: _body(context), // Replaced ReceivedItem with _body method
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
              _autofillDataController.selectedPartyName.value = '';
              _autofillDataController.selectedItemName.value = '';
              Get.back(); // Navigate back
            },
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 25,
            ),
          );
        },
      ),
      title: const Text(
        'Receive Item',
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
      ),
    );
  }

  Widget _body(BuildContext context) {
    dateTxtController.text = _getCurrentDate();

    weightTxtController.addListener(() {
      _updateNetWeight(
          _receivedItemController,
          weightTxtController,
          lessTxtController,
          addTxtController,
          touchTxtController,
          wastageTxtController);
    });

    lessTxtController.addListener(() {
      _updateNetWeight(
          _receivedItemController,
          weightTxtController,
          lessTxtController,
          addTxtController,
          touchTxtController,
          wastageTxtController);
    });

    addTxtController.addListener(() {
      _updateNetWeight(
          _receivedItemController,
          weightTxtController,
          lessTxtController,
          addTxtController,
          touchTxtController,
          wastageTxtController);
    });

    touchTxtController.addListener(() {
      _updateFine(
          _receivedItemController, touchTxtController, wastageTxtController);
    });

    wastageTxtController.addListener(() {
      _updateFine(
          _receivedItemController, touchTxtController, wastageTxtController);
    });

    return SingleChildScrollView(
      child: Column(
        children: [
          PartyAutocompleteWidget(
            name_txt: _autofillDataController.selectedPartyName.value,
            isEdit: isEdit,
          ),
          ItemAutocompleteWidget(
            name_txt: _autofillDataController.selectedItemName.value,
            isEdit: isEdit,
          ),
          DefaultTextField(
              hint_txt: "Enter Weight",
              label_txt: "Weight",
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}'))
              ],
              keyboard_type: TextInputType.number,
              txtController: weightTxtController,
              textInputAction: TextInputAction.next),
          DefaultTextField(
              hint_txt: "Enter Less",
              label_txt: "Less",
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}'))
              ],
              keyboard_type: TextInputType.number,
              txtController: lessTxtController,
              textInputAction: TextInputAction.next),
          DefaultTextField(
              hint_txt: "Enter Add",
              label_txt: "Add",
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}'))
              ],
              keyboard_type: TextInputType.number,
              txtController: addTxtController,
              textInputAction: TextInputAction.next),
          Obx(() => DefaultTextField(
              hint_txt: "Net Wt.",
              label_txt: "Net Wt.",
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}'))
              ],
              keyboard_type: TextInputType.number,
              txtController: TextEditingController(
                text:
                    _receivedItemController.net_weight.value.toStringAsFixed(3),
              ),
              enabled: false,
              textInputAction: TextInputAction.next)),
          TouchAutocompleteWidget(
            name_txt: touchTxtController.text,
            txtController: touchTxtController,
          ),
          DefaultTextField(
              hint_txt: "Enter Wastage",
              label_txt: "Wastage",
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
              ],
              keyboard_type: TextInputType.number,
              txtController: wastageTxtController,
              textInputAction: TextInputAction.next),
          Obx(() => DefaultTextField(
              hint_txt: "Fine",
              label_txt: "Fine",
              keyboard_type: TextInputType.number,
              txtController: TextEditingController(
                text:
                    _receivedItemController.final_fine.value.toStringAsFixed(3),
              ),
              enabled: false,
              textInputAction: TextInputAction.next)),
          InkWell(
            onTap: () => _selectDate(context, dateTxtController),
            child: IgnorePointer(
              child: DefaultTextField(
                hint_txt: "Date",
                label_txt: "Date",
                keyboard_type: TextInputType.number,
                txtController: dateTxtController,
              ),
            ),
          ),
          Notesautocompletewidget(
            name_txt: notesTxtController.text,
            txtController: notesTxtController,
          ),
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: DefaultButton(
              text: "Save",
              press: () => _saveData(context),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  void _updateNetWeight(
      ReceivedItemController controller,
      TextEditingController weightController,
      TextEditingController lessController,
      TextEditingController addController,
      TextEditingController touchController,
      TextEditingController wastageController) {
    double weight = double.tryParse(weightController.text) ?? 0.0;
    double less = double.tryParse(lessController.text) ?? 0.0;
    double add = double.tryParse(addController.text) ?? 0.0;

    double netWeight = weight - less + add;

    controller.net_weight.value = double.parse(netWeight.toStringAsFixed(3));

    _updateFine(controller, touchController, wastageController);
  }

  void _updateFine(
      ReceivedItemController controller,
      TextEditingController touchController,
      TextEditingController wastageController) {
    double netWeight = controller.net_weight.value;
    double touch = double.tryParse(touchController.text) ?? 0.0;
    double wastage = double.tryParse(wastageController.text) ?? 0.0;

    double fine = netWeight * (touch + wastage) / 100;

    controller.final_fine.value = double.parse(fine.toStringAsFixed(3));
  }

  String _getCurrentDate() {
    DateTime now = DateTime.now();
    return DateFormat('dd-MM-yyyy').format(now);
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController dateController) async {
    DateTime now = DateTime.now();
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (selectedDate != null) {
      dateController.text = DateFormat('dd-MM-yyyy').format(selectedDate);
    }
  }

  Future<void> _saveData(BuildContext context) async {
    String partyName = _autofillDataController.selectedPartyName.value;
    String partyId = _autofillDataController.selectedPartyId.value;
    String item = _autofillDataController.selectedItemName.value;
    String itemId = _autofillDataController.selectedItemId.value;
    String weight = weightTxtController.text;
    String less = lessTxtController.text;
    String add = addTxtController.text;
    String netWeight = _receivedItemController.net_weight.value.toString();
    String touch = touchTxtController.text;
    String wastage = wastageTxtController.text;
    String fine = _receivedItemController.final_fine.value.toString();
    String date = DateFormat('yyyy-MM-dd')
        .format(DateFormat('dd-MM-yyyy').parse(dateTxtController.text));
    String notes = notesTxtController.text;

    if (partyName.trim() == "" && partyId.trim() == "") {
      Get.snackbar('Warning', "Please enter party");
      return;
    }

    if (item.trim() == "" && itemId.trim() == "") {
      Get.snackbar('Warning', "Please enter item");
      return;
    }

    if (partyId != null && partyId != "") {
      partyName = "";
    }

    if (itemId != null && itemId != "") {
      item = "";
    }

    await _receivedItemController.submitRecieveItemData(
      tId: t_id,
      partyName: partyName,
      partyId: partyId,
      item: item,
      itemId: itemId,
      weight: weight,
      less: less,
      add: add,
      netWeight: netWeight,
      touch: touch,
      wastage: wastage,
      fine: fine,
      date: date,
      notes: notes,
      onSuccess: () {
        // Display the snackbar first

        final issueItem = {
          'id': t_id,
          'party': _autofillDataController.selectedPartyName.value,
          'party_id': partyId,
          'item': _autofillDataController.selectedItemName.value,
          'item_id': itemId,
          'weight': double.tryParse(weight)?.toStringAsFixed(3) ?? '0.000',
          // 3 decimal places
          'less': double.tryParse(less)?.toStringAsFixed(3) ?? '0.000',
          // 3 decimal places
          'add': double.tryParse(add)?.toStringAsFixed(3) ?? '0.000',
          // 3 decimal places
          'net_weight':
              double.tryParse(netWeight)?.toStringAsFixed(3) ?? '0.000',
          // 3 decimal places
          'touch': double.tryParse(touch)?.toStringAsFixed(2) ?? '0.00',
          // 2 decimal places
          'wastage': double.tryParse(wastage)?.toStringAsFixed(2) ?? '0.00',
          // 2 decimal places
          'fine': double.tryParse(fine)?.toStringAsFixed(3) ?? '0.000',
          // 3 decimal places
          'date': dateTxtController.text,
          'notes': notes,
          'type': 'receive',
        };

        if (t_id.isEmpty) {
          Navigator.of(context).pop();
        } else {
          Get.back(result: issueItem);
        }

        Future.delayed(Duration(milliseconds: 300), () {
          _clearAllFields();
          Get.snackbar('Success', "" + _receivedItemController.msg.toString());
          _autofillDataController.fetchAutofillData();
        });
      },
    );
  }

  void _clearAllFields() {
    _autofillDataController.selectedPartyId.value = '';
    _autofillDataController.selectedPartyName.value = '';
    _autofillDataController.selectedItemId.value = '';
    _autofillDataController.selectedItemName.value = '';
    weightTxtController.clear();
    lessTxtController.clear();
    addTxtController.clear();
    touchTxtController.clear();
    wastageTxtController.clear();
    dateTxtController.text =
        _getCurrentDate(); // Reset date to the current date
    notesTxtController.clear();
    _receivedItemController.net_weight.value = 0.0; // Reset net weight
    _receivedItemController.final_fine.value = 0.0; // Reset fine
  }
}
