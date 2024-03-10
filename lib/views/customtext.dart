import 'package:flutter/material.dart';
import 'package:quotes/configs/constants.dart';

class CustomText extends StatelessWidget {
  final String label;
  final double fontsize;
  final Color labelcolor;
  final FontWeight fontWeight;
  final VoidCallback? onTap;

  const CustomText({
    super.key,
    required this.label,
    this.fontsize = 20,
    this.labelcolor = appBlackColor,
    this.fontWeight = FontWeight.normal,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Text(
          label,
          style: TextStyle(
            fontSize: fontsize,
            color: labelcolor,
            fontWeight: fontWeight,
          ),
        ));
  }
}
 