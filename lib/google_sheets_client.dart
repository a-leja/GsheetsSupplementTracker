import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:gsheets/gsheets.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class GoogleSheetsClient {

  static Worksheet? _worksheet;

  Future insertData(String supplement, String intake, String date) async {
    try {
      await GoogleSheetsClient().connect();
      _worksheet!.values.appendRow([
        supplement, intake, date
      ]);
      logger.i("Data successfully saved in G-Sheets!");
    } catch (ex) {
      throw Exception("Failed to insert data. $ex");
    }
  }

  connect() async {
    final credentials = await readCredentialsFileContent();
    await getWorksheet(credentials);
  }

  Future<Map> readCredentialsFileContent() async {
    try {
      logger.d("Reading credentials from file...");
      final jsonString = await rootBundle.loadString('assets/credentials.json');
      final jsonData = jsonDecode(jsonString);
      return jsonData;
    } catch (ex) {
      throw Exception("Failed to read file content, $ex");
    }
  }

  Future getWorksheet(Map<dynamic, dynamic> credentials) async {
    logger.i("Sending data to GSheets");
    try {
      logger.d("Initializing GSheets");
      final gsheets = GSheets(credentials);
      logger.d("Fetching the spreadsheet");
      final spreadsheet = await gsheets.spreadsheet(
          "<spreadsheetId>"
      );
      logger.d("Getting the worksheet");
      return _worksheet = spreadsheet.worksheetByTitle("test");
    } catch (ex) {
      throw Exception("Failed to get the worksheet. $ex");
    }
  }
}