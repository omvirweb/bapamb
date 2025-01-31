import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewelbook_calculator/ui/ledger_3_screen/ledger_3_controller.dart';

class PartyDropDownScreen extends GetView<Ledger3Controller> {
  const PartyDropDownScreen({super.key});

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
        child: Obx(() => DropdownButton<int?>(
              isExpanded: true,
              value: controller.selectedPartyId.value,
              onChanged: (int? newValue) {
                if (newValue != null) {
                  controller.selectedPartyId.value = newValue;
                  controller.fetchLedgerData();
                }
              },
              items: [
                DropdownMenuItem<int?>(
                    value: 0,
                    child: Text('All Parties', style: TextStyle(fontSize: 16))),
                ...controller.autofillDataController.parties.map((party) {
                  return DropdownMenuItem<int?>(
                      value: party['id'],
                      child: Text(party['party_name'],
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
