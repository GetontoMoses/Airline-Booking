import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BookingPage extends StatefulWidget {
  final int flightId;

  const BookingPage({Key? key, required this.flightId}) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  late int adults;
  late int children;
  late int infants;
  late String flightClass;
  late int userId;

  @override
  void initState() {
    super.initState();
    adults = 1;
    children = 0;
    infants = 0;
    flightClass = 'economy';
    getUserId();
  }

  Future<int?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Flight'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Number of Adults:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
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
            SizedBox(height: 16),
            Text(
              'Number of Children:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
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
            SizedBox(height: 16),
            Text(
              'Number of Infants:',
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
            SizedBox(height: 16),
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
              items: ['economy', 'business', 'first'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _saveBooking();
              },
              child: Text('Confirm Booking'),
            ),
          ],
        ),
      ),
    );
  }

 Future<void> _saveBooking() async {
    // Retrieve user ID from shared preferences
    
     int? userId = await getUserId();

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
