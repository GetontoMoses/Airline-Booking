import 'package:flutter/material.dart';
import 'package:quotes/configs/constants.dart';
import 'package:quotes/views/customtext.dart';
import 'package:quotes/views/customTextField.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const CustomText(
            label: "Airline Booking",
            labelColor: appWhiteColor,
            fontSize: 28,
          ),
        ),
        backgroundColor: Colors.redAccent,
        foregroundColor: appWhiteColor,
      ),
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: CustomText(
                    label: "Login Screen",
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CustomText(
                  label: "Username",
                  labelColor: Colors.blue,
                ),
              ),
              CustomTextField(
                  Controller: usernameController,
                  hintText: "Enter your username",
                  prefixIcon: const Icon(Icons.person)),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CustomText(label: "Password"),
              ),
              CustomTextField(
                Controller: passwordController,
                hintText: "Enter your password",
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: const Icon(Icons.visibility),
              ),
              const SizedBox(height: 20),
              // const CustomTextButton(
              //   buttonName: "Log In",
              // )
            ]),
      ),
    );
  }
}
