# Urovo POS Printer Flutter Plugin - Complete Documentation

## Table of Contents

1. [Quick Start Guide](#quick-start-guide)
2. [Installation & Setup](#installation--setup)
3. [Basic Usage](#basic-usage)
4. [Real-World Scenarios](#real-world-scenarios)
5. [Advanced Features](#advanced-features)
6. [Troubleshooting](#troubleshooting)
7. [API Reference](#api-reference)
8. [Best Practices](#best-practices)

---

## Quick Start Guide

### 1. Add the Plugin

```yaml
# pubspec.yaml
dependencies:
  pos_printer: ^0.3.7+6
```

### 2. Basic Implementation

```dart
import 'package:pos_printer/pos_printer.dart';

class PrinterService {
  final PosPrinter _printer = PosPrinter();

  Future<void> printSimpleReceipt() async {
    try {
      // Check if printer is ready
      int? status = await _printer.getStatus();
      if (status != 0) {
        throw Exception('Printer not ready: Status $status');
      }

      // Setup page
      await _printer.setupPage(height: 384, width: -1);
      
      // Print content
      await _printer.drawText(
        data: "Hello World!",
        x: 50,
        y: 100,
        fontName: "simsun",
        fontSize: 24,
        isBold: true,
        isItalic: false,
        rotate: 0,
      );
      
      // Print the page
      await _printer.printPage(0);
      
      print('Receipt printed successfully!');
    } catch (e) {
      print('Error printing: $e');
    }
  }
}
```

---

## Installation & Setup

### Android Configuration

#### Step 1: Add SDK JAR
```bash
# Copy the Urovo SDK to your app's libs directory
cp android/libs/platform_sdk_v4.1.0326.jar android/app/libs/
```

#### Step 2: Update AndroidManifest.xml
```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Add printer permission -->
    <uses-permission android:name="smartpos.deviceservice.permission.Printer" />
    
    <application>
        <!-- Your app configuration -->
    </application>
</manifest>
```

#### Step 3: Update build.gradle
```gradle
// android/app/build.gradle
dependencies {
    implementation fileTree(dir: 'libs', include: ['*.jar'])
    // ... other dependencies
}
```

### iOS Configuration

Currently, this plugin only supports Android. For iOS support, you would need to implement the iOS-specific code using the Urovo iOS SDK.

---

## Basic Usage

### Initializing the Printer

```dart
import 'package:pos_printer/pos_printer.dart';

class PrinterManager {
  final PosPrinter _printer = PosPrinter();
  bool _isInitialized = false;

  Future<bool> initialize() async {
    try {
      int? status = await _printer.getStatus();
      _isInitialized = status == 0;
      return _isInitialized;
    } catch (e) {
      print('Failed to initialize printer: $e');
      return false;
    }
  }

  bool get isReady => _isInitialized;
}
```

### Checking Printer Status

```dart
class PrinterStatusChecker {
  final PosPrinter _printer = PosPrinter();

  Future<String> getStatusMessage() async {
    try {
      int? status = await _printer.getStatus();
      return _getStatusDescription(status);
    } catch (e) {
      return 'Error checking status: $e';
    }
  }

  String _getStatusDescription(int? status) {
    switch (status) {
      case 0:
        return 'Printer is ready';
      case -1:
        return 'Out of paper';
      case -2:
        return 'Printer is overheating';
      case -3:
        return 'Low voltage';
      case -4:
        return 'Printer is busy';
      case -256:
        return 'General error';
      case -257:
        return 'Driver error';
      default:
        return 'Unknown status: $status';
    }
  }
}
```

---

## Real-World Scenarios

### Scenario 1: Coffee Shop Receipt

```dart
class CoffeeShopPrinter {
  final PosPrinter _printer = PosPrinter();

  Future<void> printCoffeeReceipt({
    required String customerName,
    required List<OrderItem> items,
    required double total,
    required String orderNumber,
  }) async {
    try {
      // Check printer status
      await _checkPrinterStatus();
      
      // Setup page
      await _printer.setupPage(height: 384, width: -1);
      
      int yPosition = 50;
      
      // Print header
      await _printHeader(yPosition);
      yPosition += 60;
      
      // Print order details
      await _printOrderDetails(orderNumber, customerName, yPosition);
      yPosition += 80;
      
      // Print items
      yPosition = await _printItems(items, yPosition);
      yPosition += 20;
      
      // Print total
      await _printTotal(total, yPosition);
      yPosition += 40;
      
      // Print footer
      await _printFooter(yPosition);
      
      // Print the receipt
      await _printer.printPage(0);
      
      print('Coffee receipt printed successfully!');
    } catch (e) {
      print('Error printing coffee receipt: $e');
      rethrow;
    }
  }

  Future<void> _checkPrinterStatus() async {
    int? status = await _printer.getStatus();
    if (status != 0) {
      throw Exception('Printer not ready: ${_getStatusDescription(status)}');
    }
  }

  Future<void> _printHeader(int y) async {
    await _printer.drawText(
      data: "☕ COFFEE SHOP ☕",
      x: 80,
      y: y,
      fontName: "simsun",
      fontSize: 24,
      isBold: true,
      isItalic: false,
      rotate: 0,
    );
  }

  Future<void> _printOrderDetails(String orderNumber, String customerName, int y) async {
    await _printer.drawText(
      data: "Order #: $orderNumber",
      x: 50,
      y: y,
      fontName: "simsun",
      fontSize: 16,
      isBold: false,
      isItalic: false,
      rotate: 0,
    );
    
    await _printer.drawText(
      data: "Customer: $customerName",
      x: 50,
      y: y + 25,
      fontName: "simsun",
      fontSize: 16,
      isBold: false,
      isItalic: false,
      rotate: 0,
    );
    
    await _printer.drawText(
      data: "Date: ${DateTime.now().toString().substring(0, 19)}",
      x: 50,
      y: y + 50,
      fontName: "simsun",
      fontSize: 14,
      isBold: false,
      isItalic: false,
      rotate: 0,
    );
  }

  Future<int> _printItems(List<OrderItem> items, int startY) async {
    int y = startY;
    
    // Print header line
    await _printer.drawLine(x0: 50, y0: y, x1: 300, y1: y, lineWidth: 1);
    y += 20;
    
    for (var item in items) {
      // Item name
      await _printer.drawText(
        data: item.name,
        x: 50,
        y: y,
        fontName: "simsun",
        fontSize: 16,
        isBold: false,
        isItalic: false,
        rotate: 0,
      );
      
      // Quantity
      await _printer.drawText(
        data: "x${item.quantity}",
        x: 200,
        y: y,
        fontName: "simsun",
        fontSize: 16,
        isBold: false,
        isItalic: false,
        rotate: 0,
      );
      
      // Price
      await _printer.drawText(
        data: "\$${item.price.toStringAsFixed(2)}",
        x: 250,
        y: y,
        fontName: "simsun",
        fontSize: 16,
        isBold: false,
        isItalic: false,
        rotate: 0,
      );
      
      y += 25;
    }
    
    // Print separator line
    await _printer.drawLine(x0: 50, y0: y, x1: 300, y1: y, lineWidth: 1);
    
    return y + 20;
  }

  Future<void> _printTotal(double total, int y) async {
    await _printer.drawText(
      data: "TOTAL: \$${total.toStringAsFixed(2)}",
      x: 150,
      y: y,
      fontName: "simsun",
      fontSize: 20,
      isBold: true,
      isItalic: false,
      rotate: 0,
    );
  }

  Future<void> _printFooter(int y) async {
    await _printer.drawText(
      data: "Thank you for visiting!",
      x: 100,
      y: y,
      fontName: "simsun",
      fontSize: 16,
      isBold: false,
      isItalic: false,
      rotate: 0,
    );
    
    await _printer.drawText(
      data: "Please come again",
      x: 120,
      y: y + 25,
      fontName: "simsun",
      fontSize: 14,
      isBold: false,
      isItalic: false,
      rotate: 0,
    );
  }

  String _getStatusDescription(int? status) {
    switch (status) {
      case 0: return 'Ready';
      case -1: return 'Out of paper';
      case -2: return 'Overheating';
      case -3: return 'Low voltage';
      case -4: return 'Busy';
      default: return 'Unknown error';
    }
  }
}

class OrderItem {
  final String name;
  final int quantity;
  final double price;

  OrderItem({required this.name, required this.quantity, required this.price});
}
```

### Scenario 2: Retail Store Receipt

```dart
class RetailStorePrinter {
  final PosPrinter _printer = PosPrinter();

  Future<void> printRetailReceipt({
    required String storeName,
    required String cashierName,
    required List<RetailItem> items,
    required double subtotal,
    required double tax,
    required double total,
    required String paymentMethod,
  }) async {
    try {
      await _checkPrinterStatus();
      await _printer.setupPage(height: 384, width: -1);
      
      int y = 30;
      
      // Store header
      await _printStoreHeader(storeName, y);
      y += 60;
      
      // Transaction details
      await _printTransactionDetails(cashierName, y);
      y += 60;
      
      // Items
      y = await _printRetailItems(items, y);
      y += 20;
      
      // Totals
      await _printTotals(subtotal, tax, total, y);
      y += 60;
      
      // Payment method
      await _printPaymentMethod(paymentMethod, y);
      y += 40;
      
      // Barcode
      await _printBarcode(total.toString(), y);
      
      await _printer.printPage(0);
      print('Retail receipt printed successfully!');
    } catch (e) {
      print('Error printing retail receipt: $e');
      rethrow;
    }
  }

  Future<void> _printStoreHeader(String storeName, int y) async {
    await _printer.drawText(
      data: storeName.toUpperCase(),
      x: 100,
      y: y,
      fontName: "simsun",
      fontSize: 24,
      isBold: true,
      isItalic: false,
      rotate: 0,
    );
    
    await _printer.drawText(
      data: "RETAIL RECEIPT",
      x: 120,
      y: y + 30,
      fontName: "simsun",
      fontSize: 18,
      isBold: true,
      isItalic: false,
      rotate: 0,
    );
  }

  Future<void> _printTransactionDetails(String cashierName, int y) async {
    await _printer.drawText(
      data: "Cashier: $cashierName",
      x: 50,
      y: y,
      fontName: "simsun",
      fontSize: 14,
      isBold: false,
      isItalic: false,
      rotate: 0,
    );
    
    await _printer.drawText(
      data: "Date: ${DateTime.now().toString().substring(0, 19)}",
      x: 50,
      y: y + 20,
      fontName: "simsun",
      fontSize: 14,
      isBold: false,
      isItalic: false,
      rotate: 0,
    );
  }

  Future<int> _printRetailItems(List<RetailItem> items, int startY) async {
    int y = startY;
    
    // Header
    await _printer.drawText(data: "ITEM", x: 50, y: y, fontName: "simsun", fontSize: 14, isBold: true, isItalic: false, rotate: 0);
    await _printer.drawText(data: "QTY", x: 150, y: y, fontName: "simsun", fontSize: 14, isBold: true, isItalic: false, rotate: 0);
    await _printer.drawText(data: "PRICE", x: 200, y: y, fontName: "simsun", fontSize: 14, isBold: true, isItalic: false, rotate: 0);
    await _printer.drawText(data: "TOTAL", x: 250, y: y, fontName: "simsun", fontSize: 14, isBold: true, isItalic: false, rotate: 0);
    y += 20;
    
    // Separator line
    await _printer.drawLine(x0: 50, y0: y, x1: 300, y1: y, lineWidth: 1);
    y += 10;
    
    for (var item in items) {
      // Item name (truncated if too long)
      String displayName = item.name.length > 15 ? '${item.name.substring(0, 15)}...' : item.name;
      await _printer.drawText(
        data: displayName,
        x: 50,
        y: y,
        fontName: "simsun",
        fontSize: 14,
        isBold: false,
        isItalic: false,
        rotate: 0,
      );
      
      // Quantity
      await _printer.drawText(
        data: item.quantity.toString(),
        x: 150,
        y: y,
        fontName: "simsun",
        fontSize: 14,
        isBold: false,
        isItalic: false,
        rotate: 0,
      );
      
      // Unit price
      await _printer.drawText(
        data: "\$${item.unitPrice.toStringAsFixed(2)}",
        x: 200,
        y: y,
        fontName: "simsun",
        fontSize: 14,
        isBold: false,
        isItalic: false,
        rotate: 0,
      );
      
      // Total price
      double itemTotal = item.quantity * item.unitPrice;
      await _printer.drawText(
        data: "\$${itemTotal.toStringAsFixed(2)}",
        x: 250,
        y: y,
        fontName: "simsun",
        fontSize: 14,
        isBold: false,
        isItalic: false,
        rotate: 0,
      );
      
      y += 20;
    }
    
    // Separator line
    await _printer.drawLine(x0: 50, y0: y, x1: 300, y1: y, lineWidth: 1);
    
    return y + 10;
  }

  Future<void> _printTotals(double subtotal, double tax, double total, int y) async {
    await _printer.drawText(
      data: "Subtotal: \$${subtotal.toStringAsFixed(2)}",
      x: 200,
      y: y,
      fontName: "simsun",
      fontSize: 16,
      isBold: false,
      isItalic: false,
      rotate: 0,
    );
    
    await _printer.drawText(
      data: "Tax: \$${tax.toStringAsFixed(2)}",
      x: 200,
      y: y + 20,
      fontName: "simsun",
      fontSize: 16,
      isBold: false,
      isItalic: false,
      rotate: 0,
    );
    
    await _printer.drawText(
      data: "TOTAL: \$${total.toStringAsFixed(2)}",
      x: 180,
      y: y + 40,
      fontName: "simsun",
      fontSize: 18,
      isBold: true,
      isItalic: false,
      rotate: 0,
    );
  }

  Future<void> _printPaymentMethod(String paymentMethod, int y) async {
    await _printer.drawText(
      data: "Payment: $paymentMethod",
      x: 50,
      y: y,
      fontName: "simsun",
      fontSize: 16,
      isBold: false,
      isItalic: false,
      rotate: 0,
    );
  }

  Future<void> _printBarcode(String data, int y) async {
    await _printer.drawBarcode(
      data: data,
      x: 100,
      y: y,
      barcodeType: 29, // Code 128
      width: 200,
      height: 50,
      rotate: 0,
    );
  }

  Future<void> _checkPrinterStatus() async {
    int? status = await _printer.getStatus();
    if (status != 0) {
      throw Exception('Printer not ready: Status $status');
    }
  }
}

class RetailItem {
  final String name;
  final int quantity;
  final double unitPrice;

  RetailItem({required this.name, required this.quantity, required this.unitPrice});
}
```

### Scenario 3: Restaurant Kitchen Order

```dart
class KitchenPrinter {
  final PosPrinter _printer = PosPrinter();

  Future<void> printKitchenOrder({
    required String tableNumber,
    required String serverName,
    required List<KitchenItem> items,
    required String specialInstructions,
  }) async {
    try {
      await _checkPrinterStatus();
      await _printer.setupPage(height: 384, width: -1);
      
      int y = 30;
      
      // Header
      await _printKitchenHeader(tableNumber, serverName, y);
      y += 60;
      
      // Items
      y = await _printKitchenItems(items, y);
      y += 20;
      
      // Special instructions
      if (specialInstructions.isNotEmpty) {
        await _printSpecialInstructions(specialInstructions, y);
      }
      
      // Footer
      await _printKitchenFooter(y + 40);
      
      await _printer.printPage(0);
      print('Kitchen order printed successfully!');
    } catch (e) {
      print('Error printing kitchen order: $e');
      rethrow;
    }
  }

  Future<void> _printKitchenHeader(String tableNumber, String serverName, int y) async {
    await _printer.drawText(
      data: "🔥 KITCHEN ORDER 🔥",
      x: 80,
      y: y,
      fontName: "simsun",
      fontSize: 24,
      isBold: true,
      isItalic: false,
      rotate: 0,
    );
    
    await _printer.drawText(
      data: "Table: $tableNumber",
      x: 50,
      y: y + 30,
      fontName: "simsun",
      fontSize: 18,
      isBold: true,
      isItalic: false,
      rotate: 0,
    );
    
    await _printer.drawText(
      data: "Server: $serverName",
      x: 50,
      y: y + 50,
      fontName: "simsun",
      fontSize: 16,
      isBold: false,
      isItalic: false,
      rotate: 0,
    );
  }

  Future<int> _printKitchenItems(List<KitchenItem> items, int startY) async {
    int y = startY;
    
    for (var item in items) {
      // Item name
      await _printer.drawText(
        data: "${item.quantity}x ${item.name}",
        x: 50,
        y: y,
        fontName: "simsun",
        fontSize: 18,
        isBold: true,
        isItalic: false,
        rotate: 0,
      );
      
      // Modifications
      if (item.modifications.isNotEmpty) {
        for (var mod in item.modifications) {
          await _printer.drawText(
            data: "  - $mod",
            x: 70,
            y: y + 20,
            fontName: "simsun",
            fontSize: 14,
            isBold: false,
            isItalic: true,
            rotate: 0,
          );
          y += 20;
        }
      }
      
      y += 30;
    }
    
    return y;
  }

  Future<void> _printSpecialInstructions(String instructions, int y) async {
    await _printer.drawText(
      data: "SPECIAL INSTRUCTIONS:",
      x: 50,
      y: y,
      fontName: "simsun",
      fontSize: 16,
      isBold: true,
      isItalic: false,
      rotate: 0,
    );
    
    // Split long instructions into multiple lines
    List<String> lines = _splitText(instructions, 30);
    for (int i = 0; i < lines.length; i++) {
      await _printer.drawText(
        data: lines[i],
        x: 50,
        y: y + 20 + (i * 20),
        fontName: "simsun",
        fontSize: 14,
        isBold: false,
        isItalic: false,
        rotate: 0,
      );
    }
  }

  Future<void> _printKitchenFooter(int y) async {
    await _printer.drawText(
      data: "Time: ${DateTime.now().toString().substring(11, 16)}",
      x: 50,
      y: y,
      fontName: "simsun",
      fontSize: 14,
      isBold: false,
      isItalic: false,
      rotate: 0,
    );
    
    await _printer.drawText(
      data: "PLEASE PREPARE ASAP!",
      x: 100,
      y: y + 30,
      fontName: "simsun",
      fontSize: 18,
      isBold: true,
      isItalic: false,
      rotate: 0,
    );
  }

  List<String> _splitText(String text, int maxLength) {
    List<String> lines = [];
    String remaining = text;
    
    while (remaining.length > maxLength) {
      int spaceIndex = remaining.lastIndexOf(' ', maxLength);
      if (spaceIndex == -1) spaceIndex = maxLength;
      
      lines.add(remaining.substring(0, spaceIndex));
      remaining = remaining.substring(spaceIndex + 1);
    }
    
    if (remaining.isNotEmpty) {
      lines.add(remaining);
    }
    
    return lines;
  }

  Future<void> _checkPrinterStatus() async {
    int? status = await _printer.getStatus();
    if (status != 0) {
      throw Exception('Kitchen printer not ready: Status $status');
    }
  }
}

class KitchenItem {
  final String name;
  final int quantity;
  final List<String> modifications;

  KitchenItem({
    required this.name,
    required this.quantity,
    this.modifications = const [],
  });
}
```

### Scenario 4: Inventory Label Printing

```dart
class InventoryPrinter {
  final PosPrinter _printer = PosPrinter();

  Future<void> printInventoryLabel({
    required String itemName,
    required String sku,
    required double price,
    required String barcode,
    required String location,
  }) async {
    try {
      await _checkPrinterStatus();
      await _printer.setupPage(height: 200, width: 300);
      
      int y = 20;
      
      // Item name
      await _printer.drawText(
        data: itemName,
        x: 10,
        y: y,
        fontName: "simsun",
        fontSize: 16,
        isBold: true,
        isItalic: false,
        rotate: 0,
      );
      y += 25;
      
      // SKU
      await _printer.drawText(
        data: "SKU: $sku",
        x: 10,
        y: y,
        fontName: "simsun",
        fontSize: 12,
        isBold: false,
        isItalic: false,
        rotate: 0,
      );
      y += 20;
      
      // Price
      await _printer.drawText(
        data: "Price: \$${price.toStringAsFixed(2)}",
        x: 10,
        y: y,
        fontName: "simsun",
        fontSize: 14,
        isBold: true,
        isItalic: false,
        rotate: 0,
      );
      y += 25;
      
      // Location
      await _printer.drawText(
        data: "Location: $location",
        x: 10,
        y: y,
        fontName: "simsun",
        fontSize: 12,
        isBold: false,
        isItalic: false,
        rotate: 0,
      );
      y += 30;
      
      // Barcode
      await _printer.drawBarcode(
        data: barcode,
        x: 10,
        y: y,
        barcodeType: 29, // Code 128
        width: 280,
        height: 40,
        rotate: 0,
      );
      
      await _printer.printPage(0);
      print('Inventory label printed successfully!');
    } catch (e) {
      print('Error printing inventory label: $e');
      rethrow;
    }
  }

  Future<void> _checkPrinterStatus() async {
    int? status = await _printer.getStatus();
    if (status != 0) {
      throw Exception('Inventory printer not ready: Status $status');
    }
  }
}
```

---

## Advanced Features

### Custom Font Management

```dart
class FontManager {
  static const Map<String, String> availableFonts = {
    'simsun': 'SimSun',
    'arial': 'Arial',
    'times': 'Times New Roman',
    'courier': 'Courier New',
  };

  static String getFontName(String fontKey) {
    return availableFonts[fontKey] ?? 'simsun';
  }

  static List<String> getAvailableFonts() {
    return availableFonts.keys.toList();
  }
}
```

### Print Quality Control

```dart
class PrintQualityController {
  final PosPrinter _printer = PosPrinter();

  Future<void> setOptimalQuality() async {
    // Set gray level for better print quality
    await _printer.setGrayLevel(3); // 0-4, higher = darker
    
    // Set print speed (slower = better quality)
    await _printer.setSpeedLevel(5); // 0-9, lower = slower
  }

  Future<void> setFastPrinting() async {
    // Set for speed over quality
    await _printer.setGrayLevel(2);
    await _printer.setSpeedLevel(8);
  }

  Future<void> setDraftQuality() async {
    // Set for draft printing
    await _printer.setGrayLevel(1);
    await _printer.setSpeedLevel(9);
  }
}
```

### Batch Printing

```dart
class BatchPrinter {
  final PosPrinter _printer = PosPrinter();
  final List<PrintJob> _printQueue = [];

  void addToQueue(PrintJob job) {
    _printQueue.add(job);
  }

  Future<void> processQueue() async {
    try {
      await _checkPrinterStatus();
      
      for (var job in _printQueue) {
        await _printJob(job);
        await Future.delayed(Duration(milliseconds: 500)); // Small delay between jobs
      }
      
      _printQueue.clear();
      print('Batch printing completed successfully!');
    } catch (e) {
      print('Error in batch printing: $e');
      rethrow;
    }
  }

  Future<void> _printJob(PrintJob job) async {
    await _printer.setupPage(height: job.height, width: job.width);
    
    for (var element in job.elements) {
      switch (element.type) {
        case PrintElementType.text:
          await _printTextElement(element as TextElement);
          break;
        case PrintElementType.line:
          await _printLineElement(element as LineElement);
          break;
        case PrintElementType.barcode:
          await _printBarcodeElement(element as BarcodeElement);
          break;
        case PrintElementType.bitmap:
          await _printBitmapElement(element as BitmapElement);
          break;
      }
    }
    
    await _printer.printPage(job.rotation);
  }

  Future<void> _printTextElement(TextElement element) async {
    await _printer.drawText(
      data: element.text,
      x: element.x,
      y: element.y,
      fontName: element.fontName,
      fontSize: element.fontSize,
      isBold: element.isBold,
      isItalic: element.isItalic,
      rotate: element.rotation,
    );
  }

  Future<void> _printLineElement(LineElement element) async {
    await _printer.drawLine(
      x0: element.x0,
      y0: element.y0,
      x1: element.x1,
      y1: element.y1,
      lineWidth: element.width,
    );
  }

  Future<void> _printBarcodeElement(BarcodeElement element) async {
    await _printer.drawBarcode(
      data: element.data,
      x: element.x,
      y: element.y,
      barcodeType: element.barcodeType,
      width: element.width,
      height: element.height,
      rotate: element.rotation,
    );
  }

  Future<void> _printBitmapElement(BitmapElement element) async {
    await _printer.drawBitmap(
      image: element.imagePath,
      xDest: element.x,
      yDest: element.y,
    );
  }

  Future<void> _checkPrinterStatus() async {
    int? status = await _printer.getStatus();
    if (status != 0) {
      throw Exception('Printer not ready for batch printing: Status $status');
    }
  }
}

enum PrintElementType { text, line, barcode, bitmap }

abstract class PrintElement {
  final PrintElementType type;
  final int x;
  final int y;
  final int rotation;

  PrintElement(this.type, this.x, this.y, this.rotation);
}

class TextElement extends PrintElement {
  final String text;
  final String fontName;
  final int fontSize;
  final bool isBold;
  final bool isItalic;

  TextElement({
    required this.text,
    required int x,
    required int y,
    required this.fontName,
    required this.fontSize,
    this.isBold = false,
    this.isItalic = false,
    int rotation = 0,
  }) : super(PrintElementType.text, x, y, rotation);
}

class LineElement extends PrintElement {
  final int x0;
  final int y0;
  final int x1;
  final int y1;
  final int width;

  LineElement({
    required this.x0,
    required this.y0,
    required this.x1,
    required this.y1,
    required this.width,
  }) : super(PrintElementType.line, x0, y0, 0);
}

class BarcodeElement extends PrintElement {
  final String data;
  final int barcodeType;
  final int width;
  final int height;

  BarcodeElement({
    required this.data,
    required int x,
    required int y,
    required this.barcodeType,
    required this.width,
    required this.height,
    int rotation = 0,
  }) : super(PrintElementType.barcode, x, y, rotation);
}

class BitmapElement extends PrintElement {
  final String imagePath;

  BitmapElement({
    required this.imagePath,
    required int x,
    required int y,
  }) : super(PrintElementType.bitmap, x, y, 0);
}

class PrintJob {
  final List<PrintElement> elements;
  final int height;
  final int width;
  final int rotation;

  PrintJob({
    required this.elements,
    required this.height,
    required this.width,
    this.rotation = 0,
  });
}
```

### Error Handling and Recovery

```dart
class PrinterErrorHandler {
  final PosPrinter _printer = PosPrinter();

  Future<bool> handlePrinterError(dynamic error) async {
    print('Printer error occurred: $error');
    
    try {
      // Check printer status
      int? status = await _printer.getStatus();
      
      switch (status) {
        case -1: // Out of paper
          return await _handleOutOfPaper();
        case -2: // Overheating
          return await _handleOverheating();
        case -3: // Low voltage
          return await _handleLowVoltage();
        case -4: // Busy
          return await _handleBusy();
        default:
          return await _handleGeneralError(status);
      }
    } catch (e) {
      print('Error in error handler: $e');
      return false;
    }
  }

  Future<bool> _handleOutOfPaper() async {
    print('Printer is out of paper. Please add paper and retry.');
    // Wait a bit and check again
    await Future.delayed(Duration(seconds: 2));
    int? status = await _printer.getStatus();
    return status == 0;
  }

  Future<bool> _handleOverheating() async {
    print('Printer is overheating. Please wait for it to cool down.');
    // Wait longer for cooling
    await Future.delayed(Duration(seconds: 10));
    int? status = await _printer.getStatus();
    return status == 0;
  }

  Future<bool> _handleLowVoltage() async {
    print('Printer has low voltage. Please check power supply.');
    return false; // Requires manual intervention
  }

  Future<bool> _handleBusy() async {
    print('Printer is busy. Please wait...');
    // Wait and retry
    await Future.delayed(Duration(seconds: 3));
    int? status = await _printer.getStatus();
    return status == 0;
  }

  Future<bool> _handleGeneralError(int? status) async {
    print('General printer error: $status');
    // Try to reset the printer
    try {
      await _printer.dispose();
      await Future.delayed(Duration(seconds: 1));
      await _printer.getStatus(); // Reinitialize
      return true;
    } catch (e) {
      print('Failed to reset printer: $e');
      return false;
    }
  }
}
```

---

## Troubleshooting

### Common Issues and Solutions

#### 1. Printer Not Initializing

**Symptoms**: `Printer not initialized` errors

**Solutions**:
```dart
// Check if SDK is properly included
// Verify AndroidManifest.xml has correct permissions
// Ensure device has Urovo printer hardware

// Add this check to your code:
Future<bool> checkPrinterAvailability() async {
  try {
    int? status = await _printer.getStatus();
    return status != null;
  } catch (e) {
    print('Printer not available: $e');
    return false;
  }
}
```

#### 2. Print Quality Issues

**Symptoms**: Faint or unclear printing

**Solutions**:
```dart
// Adjust gray level (0-4, higher = darker)
await _printer.setGrayLevel(3);

// Adjust print speed (0-9, lower = slower but better quality)
await _printer.setSpeedLevel(3);

// Check paper type and quality
```

#### 3. Text Not Printing

**Symptoms**: No text appears on receipt

**Solutions**:
```dart
// Check coordinates are within page bounds
// Verify font name is available
// Ensure text is not rotated off-page

// Debug coordinates:
await _printer.drawText(
  data: "Test",
  x: 50,  // Make sure this is within page width
  y: 50,  // Make sure this is within page height
  fontName: "simsun", // Use available font
  fontSize: 16,
  isBold: false,
  isItalic: false,
  rotate: 0, // 0 = normal, 90 = rotated
);
```

#### 4. Barcode Not Scanning

**Symptoms**: Barcode prints but doesn't scan

**Solutions**:
```dart
// Use correct barcode type
// Ensure adequate size
// Check data format

await _printer.drawBarcode(
  data: "123456789", // Only numbers for Code 128
  x: 50,
  y: 100,
  barcodeType: 29, // Code 128
  width: 200, // Make sure it's wide enough
  height: 50, // Make sure it's tall enough
  rotate: 0,
);
```

### Debug Logging

Enable detailed logging to troubleshoot issues:

```dart
class PrinterDebugger {
  static void logPrintOperation(String operation, Map<String, dynamic> params) {
    print('=== PRINTER DEBUG ===');
    print('Operation: $operation');
    print('Parameters: $params');
    print('Timestamp: ${DateTime.now()}');
    print('===================');
  }

  static void logPrinterStatus(int? status) {
    print('=== PRINTER STATUS ===');
    print('Status Code: $status');
    print('Status Description: ${_getStatusDescription(status)}');
    print('=====================');
  }

  static String _getStatusDescription(int? status) {
    switch (status) {
      case 0: return 'OK';
      case -1: return 'Out of paper';
      case -2: return 'Overheating';
      case -3: return 'Low voltage';
      case -4: return 'Busy';
      case -256: return 'General error';
      case -257: return 'Driver error';
      default: return 'Unknown';
    }
  }
}
```

---

## API Reference

### Core Methods

| Method | Description | Parameters | Returns |
|--------|-------------|------------|---------|
| `getStatus()` | Get printer status | None | `Future<int?>` |
| `setupPage()` | Setup page dimensions | `height`, `width` | `Future<int?>` |
| `clearPage()` | Clear current page | None | `Future<int?>` |
| `printPage()` | Print current page | `rotate` | `Future<int?>` |
| `dispose()` | Close printer connection | None | `Future<int?>` |

### Text Methods

| Method | Description | Parameters |
|--------|-------------|------------|
| `drawText()` | Draw text | `data`, `x`, `y`, `fontName`, `fontSize`, `isBold`, `isItalic`, `rotate` |
| `drawTextEx()` | Draw text with advanced formatting | `data`, `x`, `y`, `width`, `height`, `fontName`, `fontSize`, `isBold`, `isItalic`, `rotate`, `style`, `format` |

### Graphics Methods

| Method | Description | Parameters |
|--------|-------------|------------|
| `drawLine()` | Draw a line | `x0`, `y0`, `x1`, `y1`, `lineWidth` |
| `drawBarcode()` | Draw barcode | `data`, `x`, `y`, `barcodeType`, `width`, `height`, `rotate` |
| `drawBitmap()` | Draw bitmap from file | `image`, `xDest`, `yDest` |
| `drawBitmapEx()` | Draw bitmap from bytes | `bytes`, `xDest`, `yDest`, `widthDest`, `heightDest` |

### Control Methods

| Method | Description | Parameters |
|--------|-------------|------------|
| `setGrayLevel()` | Set print gray level | `level` (0-4) |
| `setSpeedLevel()` | Set print speed | `level` (0-9) |
| `paperFeed()` | Feed paper forward | `length` |

### Legacy Methods

All methods have legacy `prn_*` versions for backward compatibility.

---

## Best Practices

### 1. Always Check Printer Status

```dart
Future<void> safePrint(Function printOperation) async {
  try {
    int? status = await _printer.getStatus();
    if (status != 0) {
      throw Exception('Printer not ready: Status $status');
    }
    
    await printOperation();
  } catch (e) {
    print('Print error: $e');
    rethrow;
  }
}
```

### 2. Use Proper Error Handling

```dart
Future<void> printWithRetry(Function printOperation, {int maxRetries = 3}) async {
  for (int i = 0; i < maxRetries; i++) {
    try {
      await printOperation();
      return;
    } catch (e) {
      print('Print attempt ${i + 1} failed: $e');
      if (i < maxRetries - 1) {
        await Future.delayed(Duration(seconds: 2));
      }
    }
  }
  throw Exception('Print failed after $maxRetries attempts');
}
```

### 3. Manage Printer Resources

```dart
class PrinterResourceManager {
  final PosPrinter _printer = PosPrinter();
  bool _isDisposed = false;

  Future<void> dispose() async {
    if (!_isDisposed) {
      await _printer.dispose();
      _isDisposed = true;
    }
  }

  // Use in your widget's dispose method
  @override
  void dispose() {
    _printerResourceManager.dispose();
    super.dispose();
  }
}
```

### 4. Optimize Print Quality

```dart
class PrintQualityOptimizer {
  final PosPrinter _printer = PosPrinter();

  Future<void> optimizeForReceipts() async {
    await _printer.setGrayLevel(3); // Good contrast
    await _printer.setSpeedLevel(5); // Balanced speed/quality
  }

  Future<void> optimizeForLabels() async {
    await _printer.setGrayLevel(4); // Maximum contrast
    await _printer.setSpeedLevel(3); // Slower for precision
  }

  Future<void> optimizeForSpeed() async {
    await _printer.setGrayLevel(2); // Adequate contrast
    await _printer.setSpeedLevel(8); // Fast printing
  }
}
```

### 5. Handle Different Paper Sizes

```dart
class PaperSizeManager {
  static const Map<String, Map<String, int>> paperSizes = {
    'receipt': {'width': -1, 'height': 384},
    'label': {'width': 300, 'height': 200},
    'large': {'width': 600, 'height': 800},
  };

  static Map<String, int> getPaperSize(String type) {
    return paperSizes[type] ?? paperSizes['receipt']!;
  }
}
```

This comprehensive documentation provides everything you need to successfully implement and use the Urovo POS Printer Flutter Plugin in real-world scenarios. The examples cover common use cases and include proper error handling, making your printing operations reliable and robust. 