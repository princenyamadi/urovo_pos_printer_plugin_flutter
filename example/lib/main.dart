import 'dart:io';

import 'package:flutter/material.dart';

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pos_printer/pos_printer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _posPrinterPlugin = PosPrinter();

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(children: [
          Text('Running on: $_platformVersion\n'),
          OutlinedButton(
              onPressed: () async {
                String? print = await _posPrinterPlugin.print();
                debugPrint('--------------------');
                debugPrint(print);
              },
              child: const Text('Print')),
          OutlinedButton(
              onPressed: () async {
                int? status = await _posPrinterPlugin.getStatus();
                debugPrint('--------Get Status------------');
                debugPrint(status.toString());
              },
              child: const Text('Get Status')),
          OutlinedButton(
              onPressed: () async {
                final setup =
                    await _posPrinterPlugin.setupPage(height: 348, width: -1);
                debugPrint('--------Setup page------------');
                debugPrint(setup.toString());
              },
              child: const Text('setup page')),
          OutlinedButton(
              onPressed: () async {
                await _posPrinterPlugin.setupPage(height: 348, width: -1);
                debugPrint('--------drawline------------');
                _posPrinterPlugin.drawLine(
                    x0: 30, y0: 20, x1: 10, y1: 30, lineWidth: 89);
                _posPrinterPlugin.printPage(0);
              },
              child: const Text('Draw Li    ne')),
          OutlinedButton(
              onPressed: () async {
                int? dis = await _posPrinterPlugin.dispose();
                debugPrint('-------dispose------------');
                debugPrint(dis.toString());
              },
              child: const Text('Dispose')),
          OutlinedButton(
              onPressed: () async {
                await _posPrinterPlugin.prnPaperForWard(100);
                debugPrint('-------forward------------');
              },
              child: const Text('Forward')),
          OutlinedButton(
              onPressed: () async {
                await _posPrinterPlugin.setupPage(height: 384, width: 100);
                await _posPrinterPlugin.drawText(
                    data: "Prince>>",
                    x: 200,
                    y: 200,
                    fontName: "simsun",
                    fontSize: 14,
                    isBold: true,
                    isItalic: false,
                    rotate: 0);
                await _posPrinterPlugin.printPage(0);
                debugPrint('-------drawText------------');
              },
              child: const Text('Draw Text')),
          OutlinedButton(
              onPressed: () async {
                // ByteData imageBytes =
                //     await rootBundle.load('assets/image/icon_flutter.png');
                // List<int> values = imageBytes.buffer.asUint8List();
                // img.Image? photo;
                // photo = img.decodeImage(values);
                // final res = img.decodePng(values);
                // int pixel = photo!.getPixel(5, 0);
                // await _posPrinterPlugin.setupPage(height: 384, width: -1);
                // print(pixel);
                // print(values);
                // print(imageBytes.buffer.asByteData());
                // Uint8List data = Uint8List.fromList(values);
                // final d = await _posPrinterPlugin.drawBitmapEx(
                //     bytes: photo.getBytes(),
                //     xDest: 300,
                //     yDest: 300,
                //     heightDest: 300,
                //     widthDest: 300);

                // print('d: $d --');

                final image = await getImageFileFromAssets(
                    'assets/image/icon_flutter.png');

                final resImage = await _posPrinterPlugin.drawBitmap(
                    image: image.path, xDest: 100, yDest: 100);
                debugPrint(resImage.toString());
                await _posPrinterPlugin.drawText(
                    data: "Prince>>",
                    x: 200,
                    y: 200,
                    fontName: "simsun",
                    fontSize: 14,
                    isBold: true,
                    isItalic: false,
                    rotate: 0);
                await _posPrinterPlugin.printPage(0);

                debugPrint('-------Draw Bitmap------------');
              },
              child: const Text('Draw Bitmap  ')),
        ]),
      ),
    );
  }
}
// assets/image/icon_flutter.png