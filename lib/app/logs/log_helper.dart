import 'package:easy_books/app/auth/user_helper.dart';
import 'package:easy_books/models/Log.dart';
import 'package:easy_books/repositories/log_repository.dart';
import 'package:flutter/material.dart';

class LogHelper {
  static final LogRepository _logRepository = LogRepository();

  static Future<void> log(String message) {
    return _logRepository.log(message, UserHelper.user.username);
  }

  Future<void> restore(Log log) async {
    // Log restoration - create new log entry
    await _logRepository.log(log.log, log.user);
  }

  Stream<List<Log>> logStream() {
    return _logRepository.watchLogs();
  }

  Future<List<Log>> getLogs() {
    return _logRepository.getLogs();
  }

  Future<List<Log>> getLogsByDateRange(DateTimeRange range) {
    return _logRepository.getLogsByDateRange(range.start, range.end);
  }
}
