import 'package:flutter/material.dart';
import 'package:quotes/utils/route.dart';

import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(GetMaterialApp(
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      getPages: Routes.routes));
}
