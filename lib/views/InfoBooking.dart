import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quotes/views/complete.dart';
import 'package:quotes/views/edit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingInfo extends StatefulWidget {
  const BookingInfo({Key? key}) : super(key: key);

  @override
  State<BookingInfo> createState() => _BookingInfoState();
}

class _BookingInfoState extends State<BookingInfo> {
  late List<dynamic> bookingInfo = [];
  late String flightNumber = ''; // Initialize flightNumber

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final userInfo = await _getUserInfo();
      flightNumber = userInfo['flight_number'] ?? ''; // Update flightNumber
      int userId = userInfo['userId'] ?? 1;

      final response = await http
          .get(Uri.parse('http://10.0.2.2:8000/flight/booking/$userId/'));

      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse.isNotEmpty) {
          setState(() {
            bookingInfo = jsonResponse;
          });
        } else {
          throw Exception('No bookings found for the user');
        }
      } else {
        throw Exception(
            'Failed to load booking info. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching booking info: $e');
    }
  }

  Future<Map<String, dynamic>> _getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    String? flightNumber = prefs.getString('flight_number');
    String? departureCity = prefs.getString('departure_city');
    String? destinationCity = prefs.getString('destination_city');
    String? departureTime = prefs.getString('departure_time');
    String? arrivalTime = prefs.getString('arrival_time');
    double? price = prefs.getDouble('price');
    return {
      'userId': userId,
      'flight_number': flightNumber,
      'departure_city': departureCity,
      'destination_city': destinationCity,
      'departure_time': departureTime,
      'arrival_time': arrivalTime,
      'price': price,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Booking Information')),
      ),
      body: bookingInfo.isEmpty
          ? Center(child: Text('No booked flights.'))
          : ListView.builder(
              itemCount: bookingInfo.length,
              itemBuilder: (context, index) {
                var booking = bookingInfo[index];
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text('Flight Number: $flightNumber'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ID: ${booking['id']}'),
                            Text(
                                'Departure City: ${booking['departure_city'] ?? 'N/A'}'),
                            Text(
                                'Destination City: ${booking['destination_city'] ?? 'N/A'}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [],
                        ),
                      ),
                      SizedBox(height: 10), // Add some spacing
                      Row(
                        children: [
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              // Navigate to the update page with the booking ID
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UpdateInfo(bookingId: booking['id']),
                                ),
                              );
                            },
                            child: Text('Edit'),
                          ),
                          SizedBox(width: 15),
                          ElevatedButton(
                            onPressed: () {
                              // Implement cancel booking functionality
                              // Including deletion from both Flutter and backend
                              cancelBooking(booking['id']);
                            },
                            child: Text('Cancel'),
                          ),
                          SizedBox(width: 15),
                          ElevatedButton(
                            onPressed: () {
                              // Navigate to the complete booking page
                              CompleteBookingPage(bookingInfo: booking)
                                  .build(context);
                            },
                            child: Text('Complete Booking'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Future<void> cancelBooking(int bookingId) async {
    try {
      final response = await http.delete(
          Uri.parse('http://10.0.2.2:8000/flight/bookingedit/$bookingId/'));

      if (response.statusCode == 200) {
        setState(() {
          bookingInfo.removeWhere((booking) => booking['id'] == bookingId);
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Center(child: Text('Booking canceled successfully')),
            );
          },
        );
      } else {
        throw Exception('Failed to cancel booking');
      }
    } catch (e) {
      print('Error canceling booking: $e');
    }
  }
}
