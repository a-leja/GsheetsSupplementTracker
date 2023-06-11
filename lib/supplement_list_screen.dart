import 'package:flutter/material.dart';
import 'popup_dialog.dart';

class SupplementListScreen extends StatelessWidget {
  final List<String> supplements = [
    'Calcium',
    'Electrolytes',
    'Magnesium',
    'Omega-3',
    'Potassium',
    'Probiotics',
    'Vitamin B12',
    'Vitamin B6',
    'Vitamin C',
    'Vitamin D',
  ];

  @override
  Widget build(BuildContext context) {
    supplements.sort();
    return Scaffold(
      appBar: AppBar(
        title: Text('Supplement Tracker'),
      ),
      body: ListView.builder(
        itemCount: supplements.length,
        itemBuilder: (context, index) {
          final selectedSupplement = supplements[index];
          return ListTile(
            title: Text(selectedSupplement),
            onTap: () {
              _openPopup(context, selectedSupplement);
            },
          );
        },
      ),
    );
  }

  void _openPopup(BuildContext context, String selectedSupplement) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopupDialog(selectedSupplement);
      },
    );
  }
}