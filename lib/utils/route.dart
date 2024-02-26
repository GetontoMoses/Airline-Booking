import "package:get/get.dart";
import 'package:quotes/views/Dashboard2.dart';

import 'package:quotes/views/login.dart';
import 'package:quotes/views/signup.dart';
import 'package:quotes/views/dashboard.dart';
import 'package:quotes/views/home.dart';

class Routes {
  static var routes = [
    GetPage(name: '/', page: () => LogIn()),
    GetPage(name: '/home', page: () => Home()),
    GetPage(name: '/signup', page: () => SignUp()),
    GetPage(name: '/dashboard', page: () => Dashboard2()),
  ];
}
