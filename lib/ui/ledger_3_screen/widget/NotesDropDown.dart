import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewelbook_calculator/ui/ledger_3_screen/ledger_3_controller.dart';

class NotesDropDown extends GetView<Ledger3Controller> {
  const NotesDropDown({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
      ),
      child: DropdownButtonHideUnderline(
        child: Obx(() => DropdownButton<String?>(
          isExpanded: true,
          value: controller.selectedNote.value,
          onChanged: (String? newValue) {
            if (newValue != null) {
              controller.selectedNote.value = newValue;
            }
          },
          items: [
            DropdownMenuItem<String?>(
                value: '',
                child: Text('All Notes', style: TextStyle(fontSize: 16))),
            ...controller.autofillDataController.notesList.map((party) {
              return DropdownMenuItem<String?>(
                  value: party['id'].toString(),
                  child: Text(party['note'],
                      style: const TextStyle(fontSize: 16)));
            }).toList(),
          ],
          style: const TextStyle(fontSize: 16, color: Colors.black),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
        )),
      ),
    );
  }
}
