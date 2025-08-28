import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;

class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({Key? key}) : super(key: key);

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  String? _htmlContent;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    fetchHtml();
  }

  Future<void> fetchHtml() async {
    try {
      final response = await http.get(
        Uri.parse("https://pos.dftech.in/x-report"),
        headers: {
          "Authorization": "R2YmALStDTvx",
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _htmlContent = utf8.decode(response.bodyBytes);
          _loading = false;
        });
      } else {
        setState(() {
          _error = "Error: ${response.statusCode}";
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = "Failed to load receipt: $e";
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
   // super.build(context);

    return Scaffold(
      appBar: AppBar(title: const Text("X-Report Receipt")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : InAppWebView(
                  initialData: InAppWebViewInitialData(data: _htmlContent!),
                  initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                      useShouldOverrideUrlLoading: true,
                      javaScriptEnabled: true,
                      supportZoom: true,
                    ),
                    android: AndroidInAppWebViewOptions(
                      useWideViewPort: true,
                      loadWithOverviewMode: true,
                    ),
                  ),
                  onLoadStart: (controller, url) {
                    debugPrint("Load started: $url");
                  },
                  onLoadStop: (controller, url) {
                    debugPrint("Load finished: $url");
                  },
                  onLoadError: (controller, url, code, message) {
                    debugPrint("Error $code: $message");
                  },
                ),
    );
  }
}
