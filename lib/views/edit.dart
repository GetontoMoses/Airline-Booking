import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdateInfo extends StatefulWidget {
  final int bookingId;

  const UpdateInfo({
    Key? key,
    required this.bookingId,
  }) : super(key: key);

  @override
  State<UpdateInfo> createState() => _UpdateInfoState();
}

class _UpdateInfoState extends State<UpdateInfo> {
  late int adults = 0;
  late int? children = 0;
  late int infants = 0;
  late String flightClass = 'economy';
  late TextEditingController passportController;
  late TextEditingController phoneController;
  late String passportNumber = '';
  late String phoneNumber = '';

  _UpdateInfoState() {
    passportController = TextEditingController();
    phoneController = TextEditingController();
    fetchBookingInfo();
  }

  Future<void> fetchBookingInfo() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://10.0.2.2:8000/flight/bookingedit/${widget.bookingId}/'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          adults = jsonResponse['adults'] ?? 0;
          children = jsonResponse['children'];
          infants = jsonResponse['infants'] ?? 0;
          flightClass = jsonResponse['flight_class'] ?? 'economy';
          passportNumber = jsonResponse['passport_number'] ?? '';
          phoneNumber = jsonResponse['phone_number'] ?? '';
          passportController.text = passportNumber;
          phoneController.text = phoneNumber;
        });
      } else {
        throw Exception('Failed to fetch booking info');
      }
    } catch (e) {
      print('Error fetching booking info: $e');
    }
  }

  Future<void> updateBookingInfo() async {
    try {
      final Map<String, dynamic> updatedData = {
        'adults': adults,
        'children': children,
        'infants': infants,
        'flight_class': flightClass,
        'passport_number': passportController.text,
        'phone_number': phoneController.text,
      };

      final response = await http.patch(
        Uri.parse(
            'http://10.0.2.2:8000/flight/bookingedit/${widget.bookingId}/'),
        body: json.encode(updatedData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Booking info updated successfully'),
        ));
        Navigator.pop(context);
      } else {
        throw Exception('Failed to update booking info');
      }
    } catch (e) {
      print('Error updating booking info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Booking Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Number of Adults:'),
              SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (adults > 0) adults--;
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
              Text('Number of Children:'),
              SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (children != null && children! > 0)
                          children = children! - 1;
                      });
                    },
                    icon: Icon(Icons.remove),
                  ),
                  Text('${children ?? 0}'),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        children = (children ?? 0) + 1;
                      });
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text('Number of Infants:'),
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
              Text('Flight Class:'),
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
              TextField(
                controller: passportController,
                decoration: InputDecoration(
                  labelText: 'Passport Number',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
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
                    updateBookingInfo();
                  },
                  child: Text('Update Booking Info'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    passportController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
