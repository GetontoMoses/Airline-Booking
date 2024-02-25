import 'package:flutter/material.dart';
import 'package:quotes/views/customtext.dart';
import 'package:quotes/configs/constants.dart';
import 'package:quotes/views/customtextField.dart';
import 'package:quotes/views/customButton.dart';
import 'package:quotes/views/Headplain.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController textController = TextEditingController();
    return Scaffold(
        body: Column(
      children: [
        SizedBox(
          height: 350,
          child: head(),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            CustomText(label: "Categories", fontWeight: FontWeight.bold),
          ],
        ),
      ],
    ));
  }
}
