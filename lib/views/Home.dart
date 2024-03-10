import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quotes/controllers/HomeController.dart';
import 'package:quotes/views/Dashboard.dart';

import 'package:quotes/views/tickets.dart';
import 'package:quotes/views/search.dart';

HomeController homeController = Get.put(HomeController());
var Screen = [Dashboard(), Search(), Tickets()];

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: homeController.selectedPage.value,
        onTap: (index) {
          homeController.selectedPage.value = index;
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.download_rounded),
            label: 'tickets',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => Center(child: Screen[homeController.selectedPage.value]),
            ),
          ),
        ],
      ),
    );
  }
}
