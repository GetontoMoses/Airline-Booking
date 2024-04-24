import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Ticket extends StatefulWidget {
  const Ticket({Key? key}) : super(key: key);

  @override
  _TicketState createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  late Future<List<Map<String, dynamic>>> _bookingInfoFuture;

  @override
  void initState() {
    super.initState();
    _bookingInfoFuture = _getBookingInfo();
  }

  Future<List<Map<String, dynamic>>> _getBookingInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    if (userId != null) {
      try {
        final response = await http.get(
          Uri.parse('http://10.0.2.2:8000/flight/booking/$userId/'),
        );

        if (response.statusCode == 200) {
          List<dynamic> jsonResponse = json.decode(response.body);
          List<Map<String, dynamic>> bookings = [];
          for (var booking in jsonResponse) {
            // Fetch flight info
            Map<String, dynamic> flightInfo =
                await _getFlightInfo(booking['flight']);
            // Mapping the booking data
            Map<String, dynamic> mappedBooking = {
              'id': booking['id'],
              'flightInfo': flightInfo, // Add flight info to the map
              'flightNumber': flightInfo['flight_number'],
              'departureCity': flightInfo['departure_city'],
              'destinationCity': flightInfo['destination_city'],
              'departureTime': flightInfo['departure_time'],
              'terminal': flightInfo['terminal'],
              'price': flightInfo['price'],
              'adults': booking['adults'],
              'children': booking['children'],
              'infants': booking['infants'],
              'flightClass': booking['flight_class'],
              'passportNumber': booking['Passport_number'],
              'phoneNumber': booking['Phone_number'],
            };
            bookings.add(mappedBooking);
          }
          return bookings;
        } else {
          throw Exception('Failed to load booking info');
        }
      } catch (e) {
        throw Exception('Error fetching booking info: $e');
      }
    } else {
      throw Exception('User ID not found in SharedPreferences');
    }
  }

  Future<Map<String, dynamic>> _getFlightInfo(int flightId) async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/flight/flight/$flightId/'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load flight info');
      }
    } catch (e) {
      throw Exception('Error fetching flight info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Tickets For All Flights Booked')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _bookingInfoFuture,
          builder: (BuildContext context,
              AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                List<Map<String, dynamic>> bookingInfoList = snapshot.data!;
                if (bookingInfoList.isEmpty) {
                  return Center(
                      child: Text('No tickets. Please book a flight.'));
                } else {
                  return ListView.builder(
                    itemCount: bookingInfoList.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map<String, dynamic> bookingInfo = bookingInfoList[index];
                      Map<String, dynamic>? flightInfo =
                          bookingInfo['flightInfo'];
                      String passportNumber =
                          bookingInfo['passportNumber'] ?? 'N/A';
                      String phoneNumber = bookingInfo['phoneNumber'] ?? 'N/A';
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey[200],
                        ),
                        child: ListTile(
                          title: Center(
                            child: Text('Ticket Number: ${bookingInfo['id']}'),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: Text('Flight Information'),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              if (flightInfo != null) ...[
                                Text(
                                    'Flight Number: ${flightInfo['flightNumber']}'),
                                Text(
                                    'Departure City: ${flightInfo['departureCity'] ?? 'N/A'}'),
                                Text(
                                    'Destination City: ${flightInfo['destinationCity'] ?? 'N/A'}'),
                                Text(
                                    'Departure Time: ${flightInfo['departureTime'] ?? 'N/A'}'),
                                Text(
                                    'Terminal: ${flightInfo['terminal'] ?? 'N/A'}'),
                                Text('Price: ${flightInfo['price'] ?? 'N/A'}'),
                              ] else ...[
                                Text('Flight information not available')
                              ],
                              SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: Text('Customer Information'),
                              ),
                              Text('Adults: ${bookingInfo['adults'] ?? 'N/A'}'),
                              Text(
                                  'Children: ${bookingInfo['children'] ?? 'N/A'}'),
                              Text(
                                  'Infants:${bookingInfo['infants'] ?? 'N/A'}'),
                              Text(
                                  'Cabin Class: ${bookingInfo['flightClass'] ?? 'N/A'}'),
                              Text('Passport Number:${passportNumber}'),
                              Text('Phone Number:${phoneNumber}'),
                              // Add other flight details as needed
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              }
            }
          },
        ),
      ),
    );
  }
}
