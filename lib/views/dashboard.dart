import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:quotes/views/booking.dart';
import 'package:quotes/views/customTextField.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  final TextEditingController departureController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
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

  Future<void> searchFlights() async {
    setState(() {
      isLoading = true;
    });
    final String fromQuery = departureController.text;
    final String toQuery = destinationController.text;

    // Encode query parameters
    final String encodedfromQuery = Uri.encodeComponent(fromQuery);
    final String encodedtoQuery = Uri.encodeComponent(toQuery);

    final response = await http.get(Uri.parse(
        'http://10.0.2.2:8000/flight/search/?departure_city=$encodedfromQuery&destination_city=$encodedtoQuery&price=&departure_time='));
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
          height: 200,
          width: double.infinity,
          color: Color.fromARGB(255, 8, 160, 155),
          child: Column(
            children: [
              SizedBox(height: 50),
              Center(
                child: Text(
                  "Search for Flights",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  "Book your next flight!",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(
                    "Search for a Flight",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: departureController,
                    decoration: InputDecoration(
                      hintText: "FROM:",
                      prefixIcon: Icon(Icons.calendar_today),
                      suffixIcon: Icon(null),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(
                            15)), // Adjust the radius to your preference
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 10), // Adjust the padding as needed
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: destinationController,
                    decoration: InputDecoration(
                      hintText: "To",
                      prefixIcon: Icon(Icons.calendar_today),
                      suffixIcon: Icon(null),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(
                            15)), // Adjust the radius to your preference
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 10), // Adjust the padding as needed
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            )),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: searchFlights,
              child: Text('Search'),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          "Best Picks for You & Search Results:",
          style: TextStyle(
            fontSize: 20,
          ),
        ),

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
          Center(
            child: ElevatedButton(
              onPressed: () {
                _bookFlight(context, flight);
              },
              child: Text('Book this flight'),
            ),
          ),
        ],
      ),
    );
  }

  void _bookFlight(BuildContext context, Map<String, dynamic> flight) async {
    // Save flight details to shared preferences
    await saveFlightToSharedPreferences(flight);

    // Navigate to booking page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingPage(flightId: flight['id']),
      ),
    );
  }

  Future<void> saveFlightToSharedPreferences(
      Map<String, dynamic> flight) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('flight_id', flight['id']);
    await prefs.setString('flight_number', flight['flight_number']);
    await prefs.setString('departure_city', flight['departure_city']);
    await prefs.setString('destination_city', flight['destination_city']);
    await prefs.setString('departure_time', flight['departure_time']);
    await prefs.setString('arrival_time', flight['arrival_time']);
    await prefs.setDouble('price', double.parse(flight['price']));
  }
}
