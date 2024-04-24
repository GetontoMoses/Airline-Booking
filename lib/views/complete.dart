import 'package:flutter/material.dart';

class CompleteBookingPage extends StatelessWidget {
  final Map<String, dynamic> bookingInfo;

  CompleteBookingPage({Key? key, required this.bookingInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complete Booking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Flight Number: ${bookingInfo['flight_number'] ?? 'N/A'}'),
            Text('Departure City: ${bookingInfo['departure_city'] ?? 'N/A'}'),
            Text(
                'Destination City: ${bookingInfo['destination_city'] ?? 'N/A'}'),
            Text('Departure Time: ${bookingInfo['departure_time'] ?? 'N/A'}'),
            Text('Arrival Time: ${bookingInfo['arrival_time'] ?? 'N/A'}'),
            SizedBox(height: 20),
            Text(
              'Price: \$${bookingInfo['price']?.toStringAsFixed(2) ?? 'N/A'}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
