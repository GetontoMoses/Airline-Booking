import 'package:flutter/material.dart';
import 'package:quotes/views/customButton.dart';
import 'package:quotes/views/customtext.dart';
import 'package:quotes/views/customTextField.dart';
import 'package:get/get.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<SignUp> {
  bool isPasswordVisible = false;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phonenumberController = TextEditingController();
  final TextEditingController emailcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
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
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Container(
                width: double.infinity,
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
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: CustomText(
                          label: 'Create an account',
                          fontsize: 25,
                          fontWeight: FontWeight.bold,
                          labelcolor: Colors.black,
                        ),
                      ),
                      CustomTextField(
                        controller: usernameController,
                        hintText: "Enter Username",
                        prefixIcon: Icon(Icons.person),
                        suffixIcon: Icon(null),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        controller: emailcontroller,
                        hintText: "Enter email",
                        prefixIcon: Icon(Icons.email),
                        suffixIcon: Icon(null),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        controller: phonenumberController,
                        hintText: "Enter phone Number",
                        prefixIcon: Icon(Icons.phone),
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
                      SizedBox(height: 20),
                      CustomTextField(
                        controller: confirmPasswordController,
                        hintText: "Confirm Password",
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
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
                        label: ("Create Account"),
                        buttonColor: Color(0xff368983),
                        width: double.infinity,
                        action: navigateToDashboard,
                      ),
                      SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.only(left: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              label: "Already have an account? ",
                              labelcolor: Colors.black,
                            ),
                            GestureDetector(
                              onTap: navigateToSignup,
                              child: CustomText(
                                label: "Login",
                                labelcolor: Color.fromARGB(255, 6, 124, 221),
                              ),
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
          ],
        ),
      ),
    );
  }

  void navigateToSignup() {
    Get.toNamed("/login");
  }

  void navigateToDashboard() {
    Get.offNamed("/home");
  }
}
