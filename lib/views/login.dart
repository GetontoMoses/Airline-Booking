import 'package:flutter/material.dart';
import 'package:quotes/views/customButton.dart';
import 'package:quotes/views/customtext.dart';
import 'package:quotes/views/customTextField.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isPasswordVisible = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
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
                      child: Image.asset(
                        "assets/images/airline2.jpeg",
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height * 0.3,
                      ))
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: screenHeight * 0.27,
                left: MediaQuery.of(context).size.width * 0.04,
                right: MediaQuery.of(context).size.width * 0.04,
              ),
              width: screenWidth,
              child: Form(
                key: _formKey,
                child: Container(
                  height: 550,
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
                    color: Color.fromRGBO(176, 200, 200, 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        Center(
                          child: CustomText(
                            label: 'Login to your account',
                            fontsize: 25,
                            fontWeight: FontWeight.bold,
                            labelcolor: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CustomTextField(
                          controller: emailController,
                          hintText: "Enter Email",
                          prefixIcon: Icon(Icons.person),
                          suffixIcon: Icon(null),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!_isValidEmail(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          onPressed: () {
                            if (_formKey.currentState != null) {
                              _login();
                            }
                          },
                          label: ("Login"),
                          buttonColor: Color(0xff368983),
                          width: 25,
                          
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

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final String email = emailController.text;
      final String password = passwordController.text;

      // login API endpoint URL
      final String apiUrl = 'http://10.0.2.2:8000/flight/login/';

      // Prepare the login data
      final Map<String, dynamic> loginData = {
        'email': email,
        'password': password,
      };

      // Convert login data to JSON
      final String jsonData = jsonEncode(loginData);

      try {
        // Make POST request to login endpoint
        final http.Response response = await http.post(
          Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonData,
        );

        //  ifis successful
        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          var userId = responseData['user_id'];
          var username = responseData['username'];

          print('user id $userId');
          print("username $username");
          await saveUserData(userId, username);
          // Navigate to the dashboard page
          navigateToDashboard();
        } else {
          print('Failed to login: ${response.body}');
          // Display error message to the user
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Center(child: Text('Login Failed')),
                content: Text('Please check your credentials and try again.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } catch (error) {
        // Handle errors (e.g., connection error)
        // For example:
        print('Error logging in: $error');
        // Display error message to the user
        // showDialog(...);
      }
    }
  }

  Future<void> saveUserData(int userId, String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId);
    await prefs.setString(
        'username', username); // Save username to shared preferences
  }

  Future<int?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  bool _isValidEmail(String email) {
    // validation using RegExp
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
}
