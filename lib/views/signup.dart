import 'package:flutter/material.dart';
import 'package:quotes/views/customtext.dart';
import 'package:quotes/configs/constants.dart';
import 'package:quotes/views/customtextField.dart';
import 'package:quotes/views/customButton.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

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
          backgroundColor: Color.fromARGB(255, 56, 181, 150),
        ),
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
                      label: 'Create Account',
                      fontsize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      CustomText(label: "First Name", labelcolor: Colors.blue),
                ),
                CustomTextField(
                  controller: usernameController,
                  hintText: "Enter Firstname",
                  prefixIcon: Icon(Icons.person),
                  suffixIcon: Icon(null),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      CustomText(label: "Second Name", labelcolor: Colors.blue),
                ),
                CustomTextField(
                  controller: usernameController,
                  hintText: "Enter Secondname",
                  prefixIcon: Icon(Icons.person),
                  suffixIcon: Icon(null),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomText(
                      label: "Phone Number", labelcolor: Colors.blue),
                ),
                CustomTextField(
                  controller: usernameController,
                  hintText: "Enter Phone Number",
                  prefixIcon: Icon(Icons.call),
                  suffixIcon: Icon(null),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomText(label: "Email", labelcolor: Colors.blue),
                ),
                CustomTextField(
                  controller: usernameController,
                  hintText: "Enter email",
                  prefixIcon: Icon(Icons.email_rounded),
                  suffixIcon: Icon(null),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomText(label: "Password", labelcolor: Colors.blue),
                ),
                CustomTextField(
                  controller: passwordController,
                  hintText: "Enter enter password",
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: Icon(Icons.visibility_off),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomText(
                      label: "ReEnter password", labelcolor: Colors.blue),
                ),
                CustomTextField(
                  controller: passwordController,
                  hintText: "Enter password again",
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: Icon(Icons.visibility_off),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  label: "Create Account",
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
