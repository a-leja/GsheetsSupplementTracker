import 'dart:convert';
import 'dart:io';
import 'package:gsheets/gsheets.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;

abstract class Constants {
  static const String _credentials = String.fromEnvironment('CRED');
  static const String _spreadsheetId = String.fromEnvironment('SID');
}

final logger = Logger();

class GoogleSheetsClient {

  connectAndSendNewData() {
    try {
      var credentials = readFileContent();
      sendDataToSpreadsheet(credentials);
    } catch (e, stackTrace) {
      logger.e("Failed to execute - the app will be terminated. $e");
      logErrorToFile(e.toString(), stackTrace);
      exit(1);
    }
  }

  Map readFileContent() {
    try {
      var filePath = getFilePath();
      final file = File(filePath);
      logger.i('Checking if the file exists');
      if (file.existsSync()) {
        logger.i('Reading file content...');
        return json.decode(file.readAsStringSync());
      } else {
        throw Exception("File not found for filePath: $filePath");
      }
    } catch (ex) {
      throw Exception("Failed to read file content, $ex");
    }
  }

  void sendDataToSpreadsheet(Map<dynamic, dynamic> credentials) async {
    logger.i("Sending data to GSheets");
    try {
      logger.d("Initializing GSheets");
      final gsheets = GSheets(credentials);
      logger.d("Fetching the spreadsheet");
      final spreadsheet = await gsheets.spreadsheet(getSpreadsheetId());
      logger.d("Getting the worksheet");
      final worksheet = spreadsheet.worksheetByTitle("test");
      await worksheet!.values.insertValue("new data", column: 1, row: 1);
    } catch (ex) {
      throw Exception("Failed to send data to the spreadsheet. $ex");
    }
  }

  String getArgument(dynamic arg) {
    if (arg.isNotEmpty) {
      logger.i("Found arg: $arg");
      return arg;
    } else {
      throw Exception("Command line argument was not provided!");
    }
  }

  String getFilePath() {
    logger.i("Getting argument for the file path to credentials");
    return getArgument(Constants._credentials);
  }

  String getSpreadsheetId() {
    logger.i("Getting argument for the spreadsheetId");
    return getArgument(Constants._spreadsheetId);
  }


  void logErrorToFile(String error, StackTrace stackTrace) {
    final logDirectory = Directory(path.join(Directory.current.path, 'logs'));
    logDirectory.createSync(recursive: true);
    final logFile = File(path.join(logDirectory.path, 'log.txt'));
    final timestamp = DateTime.now().toString();
    final logMessage = '$timestamp\nError: $error\nStack trace:\n$stackTrace\n\n';

    try {
      logFile.writeAsStringSync('$logMessage\n', mode: FileMode.append);
      logger.e('Error logged to file: ${logFile.path}');
    } catch (e) {
      logger.e('Failed to log error: $e');
    }
  }
}