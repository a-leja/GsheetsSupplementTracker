import 'package:flutter/material.dart';
import 'supplement_list_screen.dart';
import 'package:logger/logger.dart';

final logger = Logger();

void main() async {
  runApp(SupplementTrackerApp());
}

class SupplementTrackerApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supplement Tracker',
      home: SupplementListScreen(),
      theme: ThemeData(
        primarySwatch: Colors.blueGrey
      ),
    );
  }
}
