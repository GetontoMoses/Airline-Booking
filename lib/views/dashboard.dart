import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quotes/views/booking.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  late List<Map<String, dynamic>> flights;
  late String searchQuery;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize flights list and search query
    flights = [];
    searchQuery = '';
    // Fetch initial flight data
    fetchFlights();
  }

  Future<void> fetchFlights() async {
    setState(() {
      isLoading = true;
    });
    // Replace this URL with your API endpoint for fetching all flights
    final response =
        await http.get(Uri.parse('http://10.0.2.2:8000/flight/flights/'));
    if (response.statusCode == 200) {
      // Decode JSON response
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        flights = List<Map<String, dynamic>>.from(data);
        isLoading = false;
      });
    } else {
      // Handle API error
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to fetch flight data'),
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

  Future<void> searchFlights(String query) async {
    setState(() {
      isLoading = true;
    });
    // Replace this URL with your API endpoint for searching flights
    final response = await http
        .get(Uri.parse('http://10.0.2.2:8000/flight//search/?departure_city=&destination_city=&price=&departure_time='));
    if (response.statusCode == 200) {
      // Decode JSON response
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        flights = List<Map<String, dynamic>>.from(data);
        isLoading = false;
      });
    } else {
      // Handle API error
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to search for flights'),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         Container(
          height: 90,
          width: double.infinity,
          color: Color.fromARGB(255, 82, 171, 37),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                "Search for Papers",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        TextField(
          decoration: InputDecoration(
            hintText:
                'departure city, or destination city',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
            searchFlights(
                value); // Call searchFlights method when search query changes
          },
        ),
        SizedBox(height: 10),
        // Flight information container
        Expanded(
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : flights.isEmpty
                  ? Center(child: Text('No flights available'))
                  : ListView.builder(
                      itemCount: flights.length,
                      itemBuilder: (context, index) {
                        final flight = flights[index];
                        return FlightItem(flight: flight);
                      },
                    ),
        ),
      ],
    );
  }
}

class FlightItem extends StatelessWidget {
  final Map<String, dynamic> flight;

  const FlightItem({Key? key, required this.flight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Flight Number: ${flight['flight_number']}'),
          Text('Departure City: ${flight['departure_city']}'),
          Text('Destination City: ${flight['destination_city']}'),
          Text('Departure Time: ${flight['departure_time']}'),
          Text('Arrival Time: ${flight['arrival_time']}'),
          Text('Capacity: ${flight['capacity']}'),
          Text('Price: ${flight['price']}'),
            SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              _bookFlight(context, flight['id']);
            },
            child: Text('Book this flight'),
          ),
        ],
      ),
    );
  }
   void _bookFlight(BuildContext context, int flightId) async {
    // Save flight ID to shared preferences
   await saveFlightIdToSharedPreferences(flightId);

    // Navigate to booking page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingPage(flightId: flightId),
      ),
    );
  }
  Future<void> saveFlightIdToSharedPreferences(int flightId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('flight_id', flightId);
  }

// Retrieve flight ID from shared preferences
  Future<int?> getFlightIdFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('flight_id');
  }
}
