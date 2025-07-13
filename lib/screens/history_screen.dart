import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pos_scan/services/download_update.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StockUpdateHistoryScreen extends StatefulWidget {
  const StockUpdateHistoryScreen({super.key});

  @override
  _StockUpdateHistoryScreenState createState() =>
      _StockUpdateHistoryScreenState();
}

class _StockUpdateHistoryScreenState extends State<StockUpdateHistoryScreen> {
  Map<String, List<String>> stockUpdates = {};
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    loadStockUpdates();
    requestStoragePermission();
  }

  Future<void> loadStockUpdates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final existingData = prefs.getString('stock_updates_map');
    if (existingData != null) {
      Map<String, dynamic> decodedData = json.decode(existingData);
      Map<String, List<String>> updatesMap = {};
      decodedData.forEach((key, value) {
        updatesMap[key] = List<String>.from(value);
      });
      setState(() {
        stockUpdates = updatesMap;
      });
    }
  }

  Future<void> requestStoragePermission() async {
    if (Platform.isAndroid && (await Permission.storage.status.isDenied)) {
      final status = await Permission.storage.request();
      if (status.isPermanentlyDenied) {
        await openAppSettings();
      }
    } else if (Platform.isAndroid &&
        (await Permission.manageExternalStorage.status.isDenied)) {
      final status = await Permission.manageExternalStorage.request();
      if (status.isPermanentlyDenied) {
        await openAppSettings();
      }
    }
  }

  void pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void initiateDownload() async {
    await requestStoragePermission();
    downloadUpdates(context, stockUpdates, selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: true,
        title: const Text(
          'Stock Update History',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today_outlined,
                color: Colors.blueAccent),
            onPressed: () => pickDate(context),
          ),
          IconButton(
            icon: const Icon(Icons.download_rounded,
                color: Colors.blueAccent),
            onPressed: initiateDownload,
          ),
        ],
      ),
      body: stockUpdates.isEmpty
          ? const Center(
              child: Text(
                'No stock updates available',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: stockUpdates.length,
              itemBuilder: (context, index) {
                final entry = stockUpdates.entries.elementAt(index);
                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: ExpansionTile(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    title: Text(
                      entry.key,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    children: entry.value
                        .map((update) => ListTile(
                              title: Text(
                                update,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black54),
                              ),
                            ))
                        .toList(),
                  ),
                );
              },
            ),
    );
  }
}
