## 0.3.9+8

### Fixes
- **Fixed**: page-commit calls (`printPage`, `prnPrintPage`, `printCachedPage`, `print`) now run
  off the platform thread on a dedicated `HandlerThread`, so printing no longer freezes the Flutter UI.
- **Added**: automatic retry (3×, 300ms apart) while the printer reports `PRNSTS_BUSY` before a commit.
- **Fixed**: `result.error(...)` passed a `StackTraceElement[]` (not serializable over the method
  channel), which swallowed native error details — now sends `Log.getStackTraceString(e)`.
- **Fixed**: `prnPaperBack`, `prnGetTemp`, `getTemp`, `printCachedPage` were stubbed placeholders;
  they now call the real SDK methods.
- **Fixed**: `print()` returned `String?` and had no native handler (`MissingPluginException`);
  it now returns the `PRNSTS_*` code from a diagnostic print.
- **Added**: `PosPrinter.statusOk`/`statusBusy`/... constants and `PosPrinter.statusMessage(code)`.

## 0.3.7+6

### Major Fixes
- **Fixed**: PrinterManager instantiation issues that were preventing proper printer initialization
- **Fixed**: Inconsistent parameter handling between Dart and Java (mixed ArrayList/HashMap usage)
- **Fixed**: Removed test code from production implementation
- **Fixed**: Added proper error handling and validation throughout the codebase

### Improvements
- **Added**: Comprehensive logging for debugging printer operations
- **Added**: Input validation for all parameters with proper error messages
- **Added**: Synchronized access to PrinterManager to prevent race conditions
- **Added**: Proper resource cleanup and disposal
- **Added**: Status checking before operations
- **Added**: Updated example app with proper usage patterns and error handling

### Code Quality
- **Improved**: Method channel implementation with consistent parameter passing
- **Improved**: Error handling with specific error codes and messages
- **Improved**: Documentation and code comments
- **Improved**: Backward compatibility with legacy prn_* methods

## 0.0.1

* Initial release with basic printer functionality.
