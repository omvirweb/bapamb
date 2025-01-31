import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewelbook_calculator/controllers/autofill_data_controller.dart';

class Notesautocompletewidget extends StatelessWidget {
  final String name_txt;
  final AutofillDataController _autofillDataController = Get.find();
  final TextEditingController txtController;

  Notesautocompletewidget({Key? key, required this.name_txt, required this.txtController}) : super(key: key);

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
            return _autofillDataController.notesListAuto
                .map((party) => party['note'] as String)
                .where((partyName) => partyName
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase()));
          },
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            controller.text = name_txt;
            controller.addListener(() {
              txtController.text = controller.text;
            });

            return TextField(
              controller: controller,
              focusNode: focusNode,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Notes',
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
              ),
            );
          },
          onSelected: (String selection) {
            txtController.text = selection; // Update txtController when a selection is made
          },
        ),
      ),
    );
  }
}
