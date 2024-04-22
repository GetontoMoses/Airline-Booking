import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:quotes/controllers/HomeController.dart';
import 'package:quotes/views/Dashboard.dart';
import 'package:quotes/views/tickets.dart';
import 'package:quotes/views/booking.dart';

HomeController homeController = Get.put(HomeController());
var Screen = [
  Dashboard(),
  BookingPage(flightId: 0),
  Tickets()
]; // Provide a default value for flightId

class Home extends StatelessWidget {
  const Home({Key? key});

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
            label: 'Tickets',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Obx(
                () {
                  // Determine which screen to display based on the selected page
                  Widget screen = Screen[homeController.selectedPage.value];
                  // If the selected page is the BookingPage, use the FutureBuilder
                  if (screen is BookingPage) {
                    return FutureBuilder<int?>(
                      future: getFlightIdFromSharedPreferences(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          int? flightId = snapshot.data;
                          return BookingPage(flightId: flightId ?? 0);
                        }
                      },
                    );
                  } else {
                    return screen;
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<int?> getFlightIdFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('flight_id');
  }
}
