import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:serkohob/app/auth/helper.dart';
import 'package:serkohob/models/Log.dart';

class LogHelper {
  static Future<void> log(String message) {
    return Amplify.DataStore.save(
      Log(
        time: TemporalDateTime.now(),
        log: message,
        user: UserHelper.user.username,
      ),
    );
  }

  Stream logStream() {
    return Amplify.DataStore.observe(Log.classType);
  }

  Future<List<Log>> getLogs() {
    return Amplify.DataStore.query(
      Log.classType,
      sortBy: [Log.TIME.descending()],
    );
  }

  Future<List<Log>> getLogsByDateRange(DateTimeRange range) {
    final endDate = DateTime(
      range.end.year,
      range.end.month,
      range.end.day + 1,
    );
    return Amplify.DataStore.query(
      Log.classType,
      where: Log.TIME
          .ge(TemporalDate(range.start).format())
          .and(Log.TIME.lt(TemporalDate(endDate).format())),
      sortBy: [Log.TIME.descending()],
    );
  }
}
