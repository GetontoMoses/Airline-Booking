import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final String hintText;
  final Color hintColor;
  final Icon suffixIcon;
  final Icon prefixIcon;

  const CustomTextField({
    super.key,
    required this.controller,
    this.hintColor = Colors.black,
    this.obscureText = false,
    required this.hintText,
    required this.suffixIcon,
    required this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          hintText: hintText,
          
          hintStyle: TextStyle(color: hintColor),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
        ),
      ),
    );
  }
}
