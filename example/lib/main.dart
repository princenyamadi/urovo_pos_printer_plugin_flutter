import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pos_printer/pos_printer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _posPrinterPlugin = PosPrinter();
  String _statusMessage = '';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _posPrinterPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<File> getImageFileFromAssets(String path,
      {bool isAsset = true}) async {
    // ! remove null after network image is implemented
    late ByteData? byteData;

    byteData = isAsset ? await rootBundle.load(path) : null;

    final file = await File('${(await getTemporaryDirectory()).path}/$path')
        .create(recursive: true);
    await file.writeAsBytes(byteData!.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  Future<void> _checkPrinterStatus() async {
    try {
      int? status = await _posPrinterPlugin.getStatus();
      String statusText = _getStatusText(status);
      setState(() {
        _statusMessage = 'Printer Status: $statusText (Code: $status)';
      });
      debugPrint('--------Get Status------------');
      debugPrint(statusText);
    } catch (e) {
      setState(() {
        _statusMessage = 'Error getting status: $e';
      });
      debugPrint('Error getting status: $e');
    }
  }

  String _getStatusText(int? status) {
    switch (status) {
      case 0:
        return 'OK';
      case -1:
        return 'Out of paper';
      case -2:
        return 'Over heat';
      case -3:
        return 'Under voltage';
      case -4:
        return 'Device is busy';
      case -256:
        return 'Common error';
      case -257:
        return 'Driver error';
      default:
        return 'Unknown status';
    }
  }

  Future<void> _printSimpleReceipt() async {
    try {
      setState(() {
        _statusMessage = 'Printing receipt...';
      });

      // Check printer status first
      int? status = await _posPrinterPlugin.getStatus();
      if (status != 0) {
        setState(() {
          _statusMessage = 'Printer not ready: ${_getStatusText(status)}';
        });
        return;
      }

      // Setup page
      await _posPrinterPlugin.setupPage(height: 384, width: -1);
      
      // Print header
      await _posPrinterPlugin.drawText(
        data: "=== RECEIPT ===",
        x: 100,
        y: 50,
        fontName: "simsun",
        fontSize: 24,
        isBold: true,
        isItalic: false,
        rotate: 0,
      );

      // Print date/time
      await _posPrinterPlugin.drawText(
        data: "Date: ${DateTime.now().toString().substring(0, 19)}",
        x: 50,
        y: 100,
        fontName: "simsun",
        fontSize: 16,
        isBold: false,
        isItalic: false,
        rotate: 0,
      );

      // Print items
      await _posPrinterPlugin.drawText(
        data: "Item 1: Coffee",
        x: 50,
        y: 150,
        fontName: "simsun",
        fontSize: 16,
        isBold: false,
        isItalic: false,
        rotate: 0,
      );

      await _posPrinterPlugin.drawText(
        data: "Price: \$3.50",
        x: 200,
        y: 150,
        fontName: "simsun",
        fontSize: 16,
        isBold: false,
        isItalic: false,
        rotate: 0,
      );

      await _posPrinterPlugin.drawText(
        data: "Item 2: Sandwich",
        x: 50,
        y: 180,
        fontName: "simsun",
        fontSize: 16,
        isBold: false,
        isItalic: false,
        rotate: 0,
      );

      await _posPrinterPlugin.drawText(
        data: "Price: \$8.99",
        x: 200,
        y: 180,
        fontName: "simsun",
        fontSize: 16,
        isBold: false,
        isItalic: false,
        rotate: 0,
      );

      // Draw separator line
      await _posPrinterPlugin.drawLine(
        x0: 50,
        y0: 220,
        x1: 300,
        y1: 220,
        lineWidth: 2,
      );

      // Print total
      await _posPrinterPlugin.drawText(
        data: "TOTAL: \$12.49",
        x: 150,
        y: 250,
        fontName: "simsun",
        fontSize: 20,
        isBold: true,
        isItalic: false,
        rotate: 0,
      );

      // Print footer
      await _posPrinterPlugin.drawText(
        data: "Thank you for your purchase!",
        x: 80,
        y: 300,
        fontName: "simsun",
        fontSize: 16,
        isBold: false,
        isItalic: false,
        rotate: 0,
      );

      // Print the page
      await _posPrinterPlugin.printPage(0);

      setState(() {
        _statusMessage = 'Receipt printed successfully!';
      });
      debugPrint('-------Receipt printed successfully------------');
    } catch (e) {
      setState(() {
        _statusMessage = 'Error printing receipt: $e';
      });
      debugPrint('Error printing receipt: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Urovo POS Printer Plugin Example'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Running on: $_platformVersion\n'),
              Text(
                _statusMessage,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: _checkPrinterStatus,
                child: const Text('Check Printer Status'),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: _printSimpleReceipt,
                child: const Text('Print Sample Receipt'),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () async {
                  try {
                    final setup = await _posPrinterPlugin.setupPage(height: 348, width: -1);
                    setState(() {
                      _statusMessage = 'Page setup result: $setup';
                    });
                    debugPrint('--------Setup page------------');
                    debugPrint(setup.toString());
                  } catch (e) {
                    setState(() {
                      _statusMessage = 'Error setting up page: $e';
                    });
                    debugPrint('Error setting up page: $e');
                  }
                },
                child: const Text('Setup Page'),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () async {
                  try {
                    await _posPrinterPlugin.setupPage(height: 348, width: -1);
                    await _posPrinterPlugin.drawLine(
                      x0: 30, y0: 20, x1: 300, y1: 20, lineWidth: 3,
                    );
                    await _posPrinterPlugin.printPage(0);
                    setState(() {
                      _statusMessage = 'Line drawn and printed successfully!';
                    });
                    debugPrint('--------drawline------------');
                  } catch (e) {
                    setState(() {
                      _statusMessage = 'Error drawing line: $e';
                    });
                    debugPrint('Error drawing line: $e');
                  }
                },
                child: const Text('Draw Line'),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () async {
                  try {
                    int? dis = await _posPrinterPlugin.dispose();
                    setState(() {
                      _statusMessage = 'Printer disposed with result: $dis';
                    });
                    debugPrint('-------dispose------------');
                    debugPrint(dis.toString());
                  } catch (e) {
                    setState(() {
                      _statusMessage = 'Error disposing printer: $e';
                    });
                    debugPrint('Error disposing printer: $e');
                  }
                },
                child: const Text('Dispose Printer'),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () async {
                  try {
                    await _posPrinterPlugin.paperFeed(100);
                    setState(() {
                      _statusMessage = 'Paper fed forward 100 units';
                    });
                    debugPrint('-------forward------------');
                  } catch (e) {
                    setState(() {
                      _statusMessage = 'Error feeding paper: $e';
                    });
                    debugPrint('Error feeding paper: $e');
                  }
                },
                child: const Text('Feed Paper Forward'),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () async {
                  try {
                    await _posPrinterPlugin.setupPage(height: 384, width: 100);
                    await _posPrinterPlugin.drawText(
                      data: "Hello World!",
                      x: 50,
                      y: 100,
                      fontName: "simsun",
                      fontSize: 24,
                      isBold: true,
                      isItalic: false,
                      rotate: 0,
                    );
                    await _posPrinterPlugin.printPage(0);
                    setState(() {
                      _statusMessage = 'Text printed successfully!';
                    });
                    debugPrint('-------drawText------------');
                  } catch (e) {
                    setState(() {
                      _statusMessage = 'Error printing text: $e';
                    });
                    debugPrint('Error printing text: $e');
                  }
                },
                child: const Text('Print Text'),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () async {
                  try {
                    final image = await getImageFileFromAssets('assets/image/icon_flutter.png');
                    await _posPrinterPlugin.setupPage(height: 384, width: -1);
                    
                    final resImage = await _posPrinterPlugin.drawBitmap(
                      image: image.path, xDest: 100, yDest: 100,
                    );
                    
                    await _posPrinterPlugin.drawText(
                      data: "Image with text",
                      x: 200,
                      y: 200,
                      fontName: "simsun",
                      fontSize: 16,
                      isBold: true,
                      isItalic: false,
                      rotate: 0,
                    );
                    
                    await _posPrinterPlugin.printPage(0);
                    
                    setState(() {
                      _statusMessage = 'Bitmap printed successfully!';
                    });
                    debugPrint('-------Draw Bitmap------------');
                  } catch (e) {
                    setState(() {
                      _statusMessage = 'Error printing bitmap: $e';
                    });
                    debugPrint('Error printing bitmap: $e');
                  }
                },
                child: const Text('Print Bitmap'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}