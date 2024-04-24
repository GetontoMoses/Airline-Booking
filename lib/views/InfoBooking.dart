import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quotes/views/edit.dart';
import 'package:quotes/views/ticket.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingInfo extends StatefulWidget {
  const BookingInfo({Key? key}) : super(key: key);

  @override
  State<BookingInfo> createState() => _BookingInfoState();
}

class _BookingInfoState extends State<BookingInfo> {
  late List<dynamic> bookingInfo = [];
  late String flightNumber = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final userInfo = await _getUserInfo();
      flightNumber = userInfo['flight_number'] ?? '';
      int userId = userInfo['userId'] ?? 1;

      final response = await http
          .get(Uri.parse('http://10.0.2.2:8000/flight/booking/$userId/'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse.isNotEmpty) {
          setState(() {
            bookingInfo = jsonResponse;
          });
          // Save booking info to local storage
          saveBookingInfo(jsonResponse);
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

  Future<void> saveBookingInfo(List<dynamic> jsonResponse) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('booking_info', json.encode(jsonResponse));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Information'),
        centerTitle: true,
      ),
      body: bookingInfo.isEmpty
          ? Center(child: Text('No booked flights.'))
          : SingleChildScrollView(
              child: Column(
                children: bookingInfo.map((booking) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(
                        'Flight Number: $flightNumber',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4),
                          Text('ID: ${booking['id']}'),
                          Text(
                            'Departure City: ${booking['departure_city'] ?? 'N/A'}',
                          ),
                          Text(
                            'Destination City: ${booking['destination_city'] ?? 'N/A'}',
                          ),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
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
                              SizedBox(width: 5),
                              ElevatedButton(
                                onPressed: () {
                                  cancelBooking(booking['id']);
                                },
                                child: Text('Cancel'),
                              ),
                              SizedBox(width: 5),
                              ElevatedButton(
                                onPressed: () {
                                  fetchAdditionalInfoAndNavigate(
                                      context, booking);
                                },
                                child: Text('Complete Booking'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
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
              title: Text('Booking canceled successfully'),
              actions: [
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
      } else {
        throw Exception('Failed to cancel booking');
      }
    } catch (e) {
      print('Error canceling booking: $e');
    }
  }

  Future<void> fetchAdditionalInfoAndNavigate(
      BuildContext context, dynamic bookingInfo) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? passportNumber = prefs.getString('passport_number') ?? 'N/A';
      String? phoneNumber = prefs.getString('phone_number') ?? 'N/A';
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Ticket(),
        ),
      );
    } catch (e) {
      print('Error fetching additional info: $e');
    }
  }
}
