import 'package:flutter/material.dart';
import 'package:serkohob/app/auth/helper.dart';
import 'package:serkohob/models/Log.dart';
import 'package:serkohob/repositories/log_repository.dart';

class LogHelper {
  static final LogRepository _logRepository = LogRepository();

  static Future<void> log(String message) {
    return _logRepository.log(message, UserHelper.user.username);
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
