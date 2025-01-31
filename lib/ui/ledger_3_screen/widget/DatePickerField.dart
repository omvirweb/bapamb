import 'package:flutter/material.dart';

class DatePickerField extends StatelessWidget {
  final String label;
  final ValueChanged<DateTime?> onDateSelected; // Callback for date selection

  DatePickerField({required this.label, required this.onDateSelected});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        TextButton(
          onPressed: () async {
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            onDateSelected(selectedDate); // Pass selected date to parent
          },
          child: Text('Select Date'),
        ),
      ],
    );
  }
}
