import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:csv/csv.dart';
import 'package:permission_handler/permission_handler.dart';

// Highlight: Updated function to accept selectedDate as a parameter
Future<void> downloadUpdates(BuildContext context, Map<String, List<String>> stockUpdates, DateTime? selectedDate) async {
  if (selectedDate == null) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Please select a date to download updates.'),
    ));
    return;
  }

  // Highlight: Format selectedDate to match the date keys in stockUpdates
  String formattedDate = "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";

  // Highlight: Filter stock updates by the selected date
  if (!stockUpdates.containsKey(formattedDate)) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('No updates available for the selected date.'),
    ));
    return;
  }

  List<List<String>> csvData = [
    ['Date', 'Update'],
    for (var update in stockUpdates[formattedDate]!) [formattedDate, update]
  ];

  String csv = const ListToCsvConverter().convert(csvData);

  try {
    // Allow user to select a directory
    final String? selectedDirectory = await getDirectoryPath(confirmButtonText: 'Select Folder');

    if (selectedDirectory == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Folder selection canceled.'),
      ));
      return;
    }

    final file = File('$selectedDirectory/stock_updates_$formattedDate.csv');
    await file.writeAsString(csv);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('File downloaded to ${file.path}'),
    ));
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Failed to save file: $e'),
    ));
    print('Error saving file: $e');
  }
}
