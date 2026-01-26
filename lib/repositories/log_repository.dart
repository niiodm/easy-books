import 'package:isar/isar.dart';
import 'package:serkohob/models/Log.dart';
import 'package:serkohob/services/database_service.dart';

class LogRepository {
  Stream<List<Log>>? _logsStream;

  Future<void> log(String message, String user) async {
    final isar = await DatabaseService.instance;
    final logEntry = Log(
      time: DateTime.now(),
      log: message,
      user: user,
    );
    await isar.writeTxn(() async {
      await isar.logs.put(logEntry);
    });
  }

  Future<List<Log>> getLogs() async {
    final isar = await DatabaseService.instance;
    return await isar.logs
        .where()
        .sortByTimeDesc()
        .findAll();
  }

  Future<List<Log>> getLogsByDateRange(DateTime start, DateTime end) async {
    final isar = await DatabaseService.instance;
    final endDate = DateTime(end.year, end.month, end.day + 1);
    return await isar.logs
        .filter()
        .timeGreaterThan(start, include: true)
        .and()
        .timeLessThan(endDate)
        .sortByTimeDesc()
        .findAll();
  }

  Stream<List<Log>> watchLogs() {
    if (_logsStream == null) {
      _logsStream = Stream.fromFuture(DatabaseService.instance).asyncExpand((isar) {
        return isar.logs
            .where()
            .sortByTimeDesc()
            .watch(fireImmediately: true)
            .asBroadcastStream();
      }).asBroadcastStream();
    }
    return _logsStream!;
  }
}
