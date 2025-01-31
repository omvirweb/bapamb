import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewelbook_calculator/controllers/autofill_data_controller.dart';

class ItemAutocompleteWidget extends StatelessWidget {
  final String name_txt;
  final bool isEdit;
  final AutofillDataController _itemController = Get.find();

  ItemAutocompleteWidget(
      {Key? key, required this.name_txt, required this.isEdit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey), // Border color
          borderRadius: BorderRadius.circular(4.0), // Border radius
        ),
        child: Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<String>.empty();
            }
            // Map party names to a list of strings and filter based on input text
            return _itemController.items
                .map((party) => party['item_name'] as String)
                .where((partyName) => partyName
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase()));
          },
          onSelected: (String value) {
            // Find the selected party
            final selectedParty = _itemController.items.firstWhere(
              (party) => party['item_name'] == value,
              orElse: () => {'id': -1, 'item_name': value},
            );

            _itemController.selectedItemName.value = '';
            _itemController.selectedItemId.value =
                selectedParty['id'].toString();
          },
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            controller.text = name_txt;
            return TextField(
              controller: controller,
              focusNode: focusNode,
              enabled: isEdit,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Item',
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 10.0),
              ),
              onChanged: (String value) {
                _itemController.selectedItemName.value = value;
                _itemController.selectedItemId.value = '';
              },
            );
          },
        ),
      ),
    );
  }
}
