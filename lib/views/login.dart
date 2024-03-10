import 'package:flutter/material.dart';
import 'package:quotes/views/Headplain.dart';
import 'package:quotes/views/customButton.dart';
import 'package:quotes/views/customtext.dart';
import 'package:quotes/views/customTextField.dart';

import 'package:get/get.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isPasswordVisible = false;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned.fill(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: double.infinity,
                    height: 300,
                    decoration: const BoxDecoration(
                      color: Color(0xff368983),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: screenHeight * 0.1, left: screenWidth * 0.3),
                      child: CustomText(
                        label: "Airline booking",
                        fontWeight: FontWeight.bold,
                        fontsize: 30,
                        labelcolor: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding:
                  EdgeInsets.only(top: screenHeight * 0.2, left: 15, right: 15),
              width: screenWidth,
              child: Container(
                height: 600,
                width: 385,
                margin: EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(47, 125, 121, 0.3),
                      offset: Offset(0, 6),
                      blurRadius: 12,
                      spreadRadius: 6,
                    ),
                  ],
                  color: Color.fromRGBO(221, 235, 235, 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: CustomText(
                            label: 'Login to your account',
                            fontsize: 25,
                            fontWeight: FontWeight.bold,
                            labelcolor: Colors.black,
                          ),
                        ),
                        CustomTextField(
                          controller: usernameController,
                          hintText: "Enter Email",
                          prefixIcon: Icon(Icons.person),
                          suffixIcon: Icon(null),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                          controller: passwordController,
                          hintText: "Enter Password",
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: Icon(isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          obscureText: !isPasswordVisible,
                          togglePasswordVisibility: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          onPressed: () {},
                          label: ("Login"),
                          buttonColor: Color(0xff368983),
                          width: 25,
                          action: navigateToDashboard,
                        ),
                        SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.only(left: 50),
                          child: Row(
                            children: [
                              CustomText(
                                  label: "Don't have an account? ",
                                  labelcolor: Colors.black),
                              CustomText(
                                label: "Signup",
                                labelcolor: Color.fromARGB(255, 6, 124, 221),
                                onTap: navigateToSignup,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToSignup() {
    Get.toNamed("/signup");
  }

  void navigateToDashboard() {
    Get.offNamed("/home");
  }
}
