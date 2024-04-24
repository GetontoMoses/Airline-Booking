import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:quotes/views/customtext.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class BookingPage extends StatefulWidget {
  final int flightId;

  const BookingPage({Key? key, required this.flightId}) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  int adults = 1;
  int children = 0;
  int infants = 0;
  String flightClass = 'economy';
  int userId = 0; // Provide a default value
  String flightNumber = ''; // Provide a default value
  String departureCity = ''; // Provide a default value
  String destinationCity = ''; // Provide a default value
  String departureTime = ''; // Provide a default value
  String arrivalTime = ''; // Provide a default value
  double price = 0.0; // Provide a default value
  TextEditingController passportController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    // Retrieve user ID and flight information from shared preferences
    Map<String, dynamic> userInfo = await _getUserInfo();
    setState(() {
      userId = userInfo['userId'] ?? 0;
      flightNumber = userInfo['flight_number'] ?? '';
      departureCity = userInfo['departure_city'] ?? '';
      destinationCity = userInfo['destination_city'] ?? '';
      departureTime = userInfo['departure_time'] ?? '';
      arrivalTime = userInfo['arrival_time'] ?? '';
      price = userInfo['price'] ?? 0.0;
    });
  }

  @override
  void didPop() {
    // Reset data when the user navigates back to this page
    _resetData();
  }

  void _resetData() {
    setState(() {
      adults = 1;
      children = 0;
      infants = 0;
      flightClass = 'economy';
      passportController.clear();
      phoneController.clear();
    });
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
        title: Text('Book Flight'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 235, 233, 233),
              border: Border.all(color: Color.fromARGB(255, 57, 57, 57)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: CustomText(
                          label: "Flight Number: ${flightNumber ?? 'N/A'}")),
                  SizedBox(height: 10),
                  Center(
                      child:
                          CustomText(label: "Departure City: $departureCity")),
                  SizedBox(height: 10),
                  Center(
                      child: CustomText(
                          label: "Destination City: $destinationCity")),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Text(
                                'Adults:',
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(width: 10),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (adults > 1) adults--;
                                      });
                                    },
                                    icon: Icon(Icons.remove),
                                  ),
                                  Text('$adults'),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        adults++;
                                      });
                                    },
                                    icon: Icon(Icons.add),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 80),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Text(
                                'Children:',
                                style: TextStyle(fontSize: 18),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (children > 0) children--;
                                      });
                                    },
                                    icon: Icon(Icons.remove),
                                  ),
                                  Text('$children'),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        children++;
                                      });
                                    },
                                    icon: Icon(Icons.add),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                ' Infants:',
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (infants > 0) infants--;
                                      });
                                    },
                                    icon: Icon(Icons.remove),
                                  ),
                                  Text('$infants'),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        infants++;
                                      });
                                    },
                                    icon: Icon(Icons.add),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 80),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Flight Class:',
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 8),
                              DropdownButton<String>(
                                value: flightClass,
                                onChanged: (value) {
                                  setState(() {
                                    flightClass = value!;
                                  });
                                },
                                items: ['economy', 'business', 'first']
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: passportController,
                    decoration: InputDecoration(
                      labelText: 'Passport Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        _saveBooking();
                      },
                      child: Text('Confirm Booking'),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveBooking() async {
    // Retrieve user ID from shared preferences
    Map<String, dynamic> userInfo = await _getUserInfo();
    int? userId = userInfo['userId'];

    if (userId == null) {
      // Handle case where user ID is not found in shared preferences
      print('User ID not found in shared preferences.');
      return;
    }

    // Construct the booking data
    Map<String, dynamic> bookingData = {
      'adults': adults,
      'children': children,
      'infants': infants,
      'flight_class': flightClass,
      'flight': widget.flightId,
      'user': userId,
      'passport_number': passportController.text,
      'phone_number': phoneController.text,
    };

    // Send POST request to the API endpoint
    var url = Uri.parse('http://10.0.2.2:8000/flight/book/');
    var headers = {'Content-Type': 'application/json'};
    var body = json.encode(bookingData);

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 201) {
        // Booking successfully saved
        // You can handle success response here if needed

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Center(child: Text('Booking Saved successfully')),
            );
          },
        );

        // Delay navigation to dashboard by 2 seconds (adjust as needed)
        await Future.delayed(Duration(seconds: 1));
        navigateToMyBooking();
      } else if (response.statusCode == 400) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Center(
                  child: Text(
                      'Already booked this flight proceed to edit booking information')),
            );
          },
        );
        await Future.delayed(Duration(seconds: 2));
        navigateToMyBooking();
      } else {
        // Failed to save booking
        // You can handle error response here if needed
        print('Failed to save booking: ${response.body}');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to save booking'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Exception occurred while making the API call
      // You can handle the exception here if needed
      print('Exception occurred: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to save booking. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void navigateToMyBooking() {
    Get.toNamed("/mybooking");
  }
}
