import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({Key? key}) : super(key: key);

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  String scannedBarcode = '';
  bool isScanning = false;

  void startScanning() {
    setState(() {
      isScanning = true; // Show the scanner
    });
  }

  void stopScanning() {
    setState(() {
      isScanning = false; // Hide the scanner
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barcode Scanner'),
      ),
      body: Column(
        children: [
          if (isScanning)
            Expanded(
              child: MobileScanner(
                onDetect: (capture) {
                  final barcodes = capture.barcodes;
                  if (barcodes.isNotEmpty) {
                    setState(() {
                      scannedBarcode = barcodes.first.rawValue ?? 'Unknown';
                    });
                    stopScanning(); // Close the scanner after detecting a barcode
                  }
                },
              ),
            ),
          if (!isScanning) // Show button when not scanning
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: startScanning,
                child: const Text('Open Camera to Scan Barcode'),
              ),
            ),
          if (scannedBarcode.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Scanned Barcode: $scannedBarcode',
                style: const TextStyle(fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }
}
