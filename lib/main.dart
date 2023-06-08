import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:logger/logger.dart';

final logger = Logger();

void main() async {

  var fileContent = readFileContent(Constants.credentials);
  // init Google Spreadsheets
  final gsheets = GSheets(fileContent);
  // fetch spreadsheet by id
  final spreadsheet = await gsheets.spreadsheet(Constants.spreadsheetId);
  // get specific worksheet
  final worksheet = spreadsheet.worksheetByTitle("test");
  await worksheet!.values.insertValue("new data", column: 1, row: 1);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

abstract class Constants {
  static const String credentials = String.fromEnvironment('CRED');
  static const String spreadsheetId = String.fromEnvironment('SID');
}

String? readFileContent(String filePath) {
  final file = File(filePath);
  if (file.existsSync()) {
    logger.d('Reading file...');
    return file.readAsStringSync();
  } else {
    logger.d('File not found for filePath: $filePath');
  }
}


