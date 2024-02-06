import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: QuoteList(),
  ));
}

class QuoteList extends StatefulWidget {
  const QuoteList({super.key});

  @override
  State<QuoteList> createState() => _QuoteListState();
}

class _QuoteListState extends State<QuoteList> {
  List<String> quotes = [
    'The truth is rarely pure and never simple',
    'God is good all the time',
    'Discipline is the bridge between goals and achievement'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text("Awesome Quotes"),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 50, 228, 207),
        ),
        body: Column(
          children: quotes.map((quote) => Text(quote)).toList(),
        ));
  }
}
