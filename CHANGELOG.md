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
