import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final bool obscureText;
  final bool readOnly;
  final VoidCallback? onTap;
  const CustomField({
    super.key,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      readOnly: readOnly,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      validator: (val) {
        if (val!.trim().isEmpty) {
          return 'Please enter $hintText';
        }
        return null;
      },
    );
  }
}
