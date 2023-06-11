import 'package:flutter/material.dart';
import 'package:supplementtracker/google_sheets_client.dart';

class PopupDialog extends StatefulWidget {
  final String selectedSupplement;

  PopupDialog(this.selectedSupplement);

  @override
  _PopupDialogState createState() => _PopupDialogState();
}

class _PopupDialogState extends State<PopupDialog> {
  DateTime? selectedDate;
  final TextEditingController _selectedSupplementController = TextEditingController();
  final TextEditingController _intakeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    _dateController.text = _formatDate(DateTime.now());
    _selectedSupplementController.text = widget.selectedSupplement;
  }

  @override
  void dispose() {
    _selectedSupplementController.dispose();
    _intakeController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)}';
  }

  String _twoDigits(int n) {
    if (n >= 10) {
      return "$n";
    }
    return "0$n";
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 400,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _selectedSupplementController,
              decoration: InputDecoration(labelText: 'Supplement'),
            ),
            TextField(
              controller: _intakeController,
              decoration: InputDecoration(labelText: 'Intake Input'),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _dateController,
                    decoration: InputDecoration(labelText: 'Date'),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  child: Text('Select Date'),
                  onPressed: () {
                    _selectDate(context);
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Save'),
                  onPressed: () {
                    // Perform save operation
                    _saveData(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = _formatDate(selectedDate!);
      });
    }
  }

  void _saveData(BuildContext context) async {
    bool isSuccess = false;
    try {
      await GoogleSheetsClient().insertData(
          _selectedSupplementController.text,
          _intakeController.text,
          _dateController.text
      );
      isSuccess = true;
    } catch (ex) {
      isSuccess = false;
      logger.d("Something went wrong, $ex");
    }

    setState(() {
      isSaved = isSuccess;
    });

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(isSuccess ? Icons.check : Icons.error, color: isSuccess ? Colors.green : Colors.red),
            SizedBox(width: 8),
            Text(isSuccess ? 'Data saved successfully!' : 'Failed to save data.'),
          ],
        ),
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
