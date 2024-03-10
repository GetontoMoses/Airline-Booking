import 'package:flutter/material.dart';
import 'package:quotes/views/customtext.dart';
import 'package:quotes/configs/constants.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final Function onPressed;
  final VoidCallback? action;
  final Color buttonColor;
  final double width;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.buttonColor = appGrayColor,
    this.width = 18,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: action,
      child: CustomText(
        label: label,
        labelcolor: Colors.white,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        minimumSize: Size(width, 50),
      ),
    );
  }
}
