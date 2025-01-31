import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DefaultTextField extends StatelessWidget {
  const DefaultTextField(
      {Key? key,
        this.label_txt,
        this.hint_txt,
        this.keyboard_type,
        this.txtController,
        this.enabled = true,
        this.inputFormatters,
        this.textInputAction,
        this.focusNode})
      : super(key: key);

  final String? label_txt, hint_txt;
  final TextInputType? keyboard_type;
  final TextEditingController? txtController;
  final bool enabled;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: TextField(
        controller: txtController,
        keyboardType: keyboard_type,
        enabled: enabled,
        inputFormatters: inputFormatters,
        textInputAction: textInputAction,
        focusNode: focusNode,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: label_txt,
            hintText: hint_txt),
      ),
    );
  }
}
