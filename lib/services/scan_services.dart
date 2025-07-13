import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:pos_scan/utils/sounds.dart';

class Scanner {
  Sounds sound = Sounds();
  Future<String> scanBarcode() async {
    String scanBarCodeRes = '';
    try {
      scanBarCodeRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print('scanBarCodeRes');
    } catch (e) {
      await sound.playWrongSound();
      print(e);
    }
    await sound.playBeepSound();
    print('barcodeValue$scanBarCodeRes');
    return scanBarCodeRes;
  }

  Future<String> scanQr() async {
    String scanQrCodeRes = '';

    try {
      scanQrCodeRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print('scanQrCodeRes');
    } catch (e) {
      print(e);
    }
    return scanQrCodeRes;
  }
}
