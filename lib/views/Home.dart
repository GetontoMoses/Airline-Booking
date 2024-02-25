import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dashboard.dart';

import 'package:quotes/controllers/homecontroller.dart';

HomeController homeController = Get.put(HomeController());
var Screen = [Dashboard()];

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Floating NavBar Example',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Floating NavBar Example'),
          centerTitle: true,
        ),
        //If you want to show body behind the navbar, it should be true
        extendBody: true,
        body: Obx(
          () => Center(child: Screen[homeController.selectedPage.value]),
        ),
        bottomNavigationBar: FloatingNavbar(
          onTap: (index) {
            homeController.updateSelectedPage(index);
          },
          items: [
            FloatingNavbarItem(icon: Icons.home, title: 'Home'),
            FloatingNavbarItem(icon: Icons.explore, title: 'Explore'),
            FloatingNavbarItem(icon: Icons.chat_bubble_outline, title: 'Chats'),
            FloatingNavbarItem(icon: Icons.settings, title: 'Settings'),
          ],
        ),
      ),
    );
  }
}
