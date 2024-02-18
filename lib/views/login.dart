import 'package:flutter/material.dart';
import 'package:quotes/views/customtext.dart';
import 'package:quotes/configs/constants.dart';
import 'package:quotes/views/customtextField.dart';
import 'package:quotes/views/customButton.dart';

class LogIn extends StatelessWidget {
  const LogIn({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    return Scaffold(
        appBar: AppBar(
            title: Center(
              child: CustomText(
                label: 'AIRLINE BOOKING',
                labelcolor: appWhiteColor,
              ),
            ),
            backgroundColor: Color.fromARGB(255, 56, 181, 150)),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomText(
                      label: 'Log In',
                      fontsize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomText(label: "Email", labelcolor: Colors.blue),
                ),
                CustomTextField(
                  controller: usernameController,
                  hintText: "Enter Email",
                  prefixIcon: Icon(Icons.person),
                  suffixIcon: Icon(null),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomText(label: "Password", labelcolor: Colors.blue),
                ),
                CustomTextField(
                  controller: usernameController,
                  hintText: "Enter Password",
                  prefixIcon: Icon(Icons.person),
                  suffixIcon: Icon(Icons.remove_red_eye),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  label: "Sign In",
                  onPressed: () {},
                  buttonColor: Color.fromARGB(255, 56, 181, 150),
                  width: 18,
                ),
              ],
            ),
          ),
        ));
  }
}
