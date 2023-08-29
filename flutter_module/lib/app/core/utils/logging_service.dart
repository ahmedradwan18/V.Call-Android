import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

// import 'firebase/firebase_crashlytics_service.dart';

class LoggingService {
  //!=============================== Constructor ===============================
  static const LoggingService _singleton = LoggingService._internal();
  factory LoggingService() {
    return _singleton;
  }
  const LoggingService._internal();
  //!=============================== Properties ================================
  static final _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0, // number of method calls to be displayed
      errorMethodCount: 8, // number of method calls if stacktrace is provided
      lineLength: 120, // width of the output
      //? Used [io] based on [Logger]'s Documentation Recommendation
      colors: io.stdout.supportsAnsiEscapes, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      printTime: false, // Should each log print contain a timestamp
    ),
  );
  //!================================ Methods ==================================
  /// Log a message at level [Level.verbose].
  static void verbose(dynamic message,
      [dynamic error, StackTrace? stackTrace]) {
    _logger.v(message, error, stackTrace);
  }

  /// Log a message at level [Level.debug].
  static void debug(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error, stackTrace);
  }

  /// Log a message at level [Level.info].
  static void information(dynamic message,
      [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _logger.i(message, error, stackTrace);
    } else {
      // CrashlyticsService.log(message);
    }
  }

  /// Log a message at level [Level.error].
  static void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _logger.e(message, error, stackTrace);
    } else {
      // CrashlyticsService.recordError(
      //   error: error,
      //   stackTrace: stackTrace,
      //   message: message,
      // );
    }
  }

  /// Log a message at level [Level.warning].
  static void warning(dynamic message,
      [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error, stackTrace);
  }

  /// Log a message at level [Level.wtf].
  static void wtf(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.wtf(message, error, stackTrace);
  }

  //!===========================================================================
  //!===========================================================================
}
