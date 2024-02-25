import 'package:flutter/material.dart';
import 'package:quotes/views/customtext.dart';
import 'package:quotes/views/customTextField.dart';
import 'package:quotes/views/customButton.dart';

final TextEditingController textController = TextEditingController();
Widget head() {
  return Stack(
    children: [
      Column(
        children: [
          Container(
            width: double.infinity,
            height: 320,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 16, 70, 66),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 40,
                  left: 300,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Container(
                      height: 40,
                      width: 40,
                      color: const Color.fromRGBO(250, 250, 250, 0.1),
                      child: const Icon(
                        Icons.notification_add_rounded,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 40, left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 18,
                        ),
                        child: CustomText(
                          label: "Current Location",
                          labelcolor: Colors.white,
                          fontsize: 20,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.white),
                          CustomText(
                              label: "Athi River, Kenya",
                              labelcolor: Colors.white,
                              fontsize: 20),
                        ],
                      ),
                      SizedBox(
                        height: 70,
                      ),
                      Center(
                        child: CustomText(
                          label: "Book a Flight",
                          fontWeight: FontWeight.bold,
                          fontsize: 25.0,
                          labelcolor: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              hintText: "Enter your destination",
                              hintColor: Colors.white,
                              prefixIcon:
                                  Icon(Icons.search, color: Colors.white),
                              suffixIcon: Icon(null),
                              controller: TextEditingController(),
                            ),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: CustomButton(
                              label: 'Search',
                              buttonColor: Color.fromARGB(255, 68, 117, 70),
                              onPressed: () {},
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}
