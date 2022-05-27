import 'dart:async';
import 'dart:convert';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart'as http;

class Scanner extends StatefulWidget {
  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {

  String qrCode = "";

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Color(0xFF313131),
    appBar: AppBar(
      title: Text("Qr Code Scanner"),
      backgroundColor: Colors.black12,
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Scan Result',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white54,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '$qrCode',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 50),
          Container(
          child: FlatButton(
            child: Text('Start QR scan'),
            color: Colors.black26,
            textColor: Colors.white,
            onPressed: () => scanQRCode(),
          ),
          ),
        ],
      ),
    ),
  );

  Future<void> scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (!mounted) return;

      setState(() {
        this.qrCode = qrCode.isEmpty ? '' : qrCode == '-1' ? '' : qrCode;
      });

      final storage = new FlutterSecureStorage();
      var number = await storage.read(key: "studentNumber");

      final response = await http.post(
          Uri.parse('http://10.0.2.2:8081/api/v1/attendance/insertAttendanceByStudent'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'IdSchedule': int.parse(qrCode),
            'IdStudent': number
          }));

      print(response.body);

    } on PlatformException {
      qrCode = 'Failed to get platform version.';
    }
  }
}