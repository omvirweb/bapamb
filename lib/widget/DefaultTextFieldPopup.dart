import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DefaultTextFieldPopup extends StatefulWidget {
  const DefaultTextFieldPopup(
      {Key? key,
        this.label_txt,
        this.hint_txt,
        this.keyboard_type,
        this.txtController,
        this.inputFormatters,
        this.textInputAction,
        this.focusNode})
      : super(key: key);

  final String? label_txt, hint_txt;
  final TextInputType? keyboard_type;
  final TextEditingController? txtController;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;

  @override
  _DefaultTextFieldPopupState createState() => _DefaultTextFieldPopupState();
}

class _DefaultTextFieldPopupState extends State<DefaultTextFieldPopup> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
      child: TextField(
        controller: widget.txtController,
        keyboardType: widget.keyboard_type,
        inputFormatters: widget.inputFormatters,
        textInputAction: widget.textInputAction,
        focusNode: widget.focusNode,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: widget.label_txt,
            hintText: widget.hint_txt),
      ),
    );
  }
}
