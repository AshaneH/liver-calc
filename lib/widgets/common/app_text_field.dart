import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final String suffix;
  final Function(String) onChanged;
  final double width;
  final bool isInteger;
  final String? initialValue;
  final bool isLast;
  final FocusNode? focusNode;

  const AppTextField({
    super.key,
    required this.label,
    required this.suffix,
    required this.onChanged,
    required this.width,
    this.isInteger = false,
    this.initialValue,
    required this.isLast,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        // Key is vital for proper flutter element reuse when units change!
        key: ValueKey("${label}_$suffix"),
        focusNode: focusNode,
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          suffixText: suffix,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          isDense: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        keyboardType: TextInputType.numberWithOptions(decimal: !isInteger),
        textInputAction: isLast ? TextInputAction.done : TextInputAction.next,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
        ],
        onChanged: onChanged,
      ),
    );
  }
}
