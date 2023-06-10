import 'package:flutter/material.dart';
import 'homepage.dart';
import 'google_sheets_api.dart';
import 'package:logger/logger.dart';

final logger = Logger();

void main(List<String> args) async {
  // GoogleSheetsClient().connectAndSendNewData();
  runApp(Homepage());
}
