# Urovo POS Printer Flutter Plugin

A Flutter plugin for integrating with Urovo POS printer hardware using the Urovo Platform SDK.

## Overview

This plugin provides a seamless interface to Urovo POS printer devices from Flutter applications. It supports all major printing operations including text, graphics, barcodes, and page management.

## Features

- ✅ **Text Printing**: Support for various fonts, sizes, and styles
- ✅ **Graphics**: Draw lines, shapes, and bitmaps
- ✅ **Barcodes**: Multiple barcode format support
- ✅ **Page Management**: Setup, clear, and print pages
- ✅ **Printer Control**: Status checking, paper feed, speed control
- ✅ **Error Handling**: Comprehensive error handling and status reporting
- ✅ **Backward Compatibility**: Support for legacy `prn_*` methods

## Recent Fixes

### PrinterManager Instantiation Issues
- **Fixed**: Proper PrinterManager initialization with error handling
- **Fixed**: Synchronized access to prevent race conditions
- **Fixed**: Status checking before operations
- **Fixed**: Proper resource cleanup and disposal

### Parameter Handling Issues
- **Fixed**: Consistent parameter passing using `HashMap` instead of mixed `ArrayList`/`HashMap`
- **Fixed**: Parameter validation for all methods
- **Fixed**: Proper error messages for missing or invalid parameters

### Code Quality Improvements
- **Fixed**: Removed test code from production implementation
- **Fixed**: Added comprehensive logging for debugging
- **Fixed**: Proper exception handling throughout
- **Fixed**: Input validation and bounds checking

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  pos_printer: ^0.3.7+6
```

## Setup

### Android Configuration

1. **Add the Urovo SDK JAR** to your Android project:
   ```bash
   # Copy the SDK JAR to your app's libs directory
   cp android/libs/platform_sdk_v4.1.0326.jar android/app/libs/
   ```

2. **Add permissions** to `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <uses-permission android:name="smartpos.deviceservice.permission.Printer" />
   ```

3. **Update your app's build.gradle** to include the SDK:
   ```gradle
   dependencies {
       implementation fileTree(dir: 'libs', include: ['*.jar'])
   }
   ```

## Usage

### Basic Setup

```dart
import 'package:pos_printer/pos_printer.dart';

final printer = PosPrinter();
```

### Check Printer Status

```dart
try {
  int? status = await printer.getStatus();
  if (status == 0) {
    print('Printer is ready');
  } else {
    print('Printer error: $status');
  }
} catch (e) {
  print('Error checking status: $e');
}
```

### Print a Simple Receipt

```dart
Future<void> printReceipt() async {
  try {
    // Check printer status
    int? status = await printer.getStatus();
    if (status != 0) {
      throw Exception('Printer not ready: $status');
    }

    // Setup page
    await printer.setupPage(height: 384, width: -1);
    
    // Print header
    await printer.drawText(
      data: "=== RECEIPT ===",
      x: 100,
      y: 50,
      fontName: "simsun",
      fontSize: 24,
      isBold: true,
      isItalic: false,
      rotate: 0,
    );

    // Print items
    await printer.drawText(
      data: "Coffee: \$3.50",
      x: 50,
      y: 100,
      fontName: "simsun",
      fontSize: 16,
      isBold: false,
      isItalic: false,
      rotate: 0,
    );

    // Draw separator line
    await printer.drawLine(
      x0: 50,
      y0: 150,
      x1: 300,
      y1: 150,
      lineWidth: 2,
    );

    // Print total
    await printer.drawText(
      data: "TOTAL: \$3.50",
      x: 150,
      y: 200,
      fontName: "simsun",
      fontSize: 20,
      isBold: true,
      isItalic: false,
      rotate: 0,
    );

    // Print the page
    await printer.printPage(0);
    
    print('Receipt printed successfully!');
  } catch (e) {
    print('Error printing receipt: $e');
  }
}
```

### Print Barcode

```dart
await printer.drawBarcode(
  data: "123456789",
  x: 50,
  y: 100,
  barcodeType: 29, // Code 128
  width: 200,
  height: 50,
  rotate: 0,
);
```

### Print Bitmap

```dart
await printer.drawBitmap(
  image: "/path/to/image.png",
  xDest: 100,
  yDest: 100,
);
```

### Control Printer Settings

```dart
// Set gray level (0-4)
await printer.setGrayLevel(2);

// Set speed level (0-9)
await printer.setSpeedLevel(5);

// Feed paper
await printer.paperFeed(100);
```

## API Reference

### Core Methods

| Method | Description | Parameters |
|--------|-------------|------------|
| `getStatus()` | Get printer status | None |
| `setupPage()` | Setup page dimensions | `height`, `width` |
| `clearPage()` | Clear current page | None |
| `printPage()` | Print current page | `rotate` |
| `dispose()` | Close printer connection | None |

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

### Legacy Methods (Backward Compatibility)

All methods also have legacy `prn_*` versions for backward compatibility:
- `prnOpen()` → `getPrinterManager()`
- `prnClose()` → `dispose()`
- `prnGetStatus()` → `getStatus()`
- `prnSetupPage()` → `setupPage()`
- `prnDrawText()` → `drawText()`
- etc.

## Printer Status Codes

| Code | Description |
|------|-------------|
| 0 | OK - Printer ready |
| -1 | Out of paper |
| -2 | Over heat |
| -3 | Under voltage |
| -4 | Device is busy |
| -256 | Common error |
| -257 | Driver error |

## Error Handling

The plugin provides comprehensive error handling:

```dart
try {
  await printer.drawText(
    data: "Hello World",
    x: 50,
    y: 100,
    fontName: "simsun",
    fontSize: 16,
    isBold: false,
    isItalic: false,
    rotate: 0,
  );
} on PlatformException catch (e) {
  print('Platform error: ${e.code} - ${e.message}');
} catch (e) {
  print('General error: $e');
}
```

## Troubleshooting

### Common Issues

1. **Printer not initializing**
   - Check if the Urovo SDK JAR is properly included
   - Verify permissions are added to AndroidManifest.xml
   - Ensure the device has the Urovo printer hardware

2. **Status errors**
   - Check printer connection
   - Verify paper is loaded
   - Check for overheating or voltage issues

3. **Print quality issues**
   - Adjust gray level (0-4)
   - Check print speed settings
   - Verify font and size parameters

### Debug Logging

Enable debug logging to troubleshoot issues:

```dart
// The plugin automatically logs to Android logcat
// Look for "PosPrinterPlugin" tags in logcat
```

## Example App

See the `example/` directory for a complete working example that demonstrates:
- Printer status checking
- Receipt printing
- Text and graphics
- Error handling
- UI feedback

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues and questions:
1. Check the troubleshooting section
2. Review the example app
3. Open an issue on GitHub

## Changelog

### Version 0.3.7+6
- **Fixed**: PrinterManager instantiation issues
- **Fixed**: Parameter handling inconsistencies
- **Fixed**: Removed test code from production
- **Added**: Comprehensive error handling
- **Added**: Input validation
- **Added**: Better logging and debugging
- **Added**: Updated example app with proper usage

