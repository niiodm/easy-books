import 'package:isar/isar.dart';
import 'package:serkohob/models/Refund.dart';
import 'package:serkohob/services/database_service.dart';

class RefundRepository {
  Stream<List<Refund>>? _refundsStream;

  Future<List<Refund>> getRefunds() async {
    final isar = await DatabaseService.instance;
    return await isar.refunds
        .where()
        .sortByTimeDesc()
        .findAll();
  }

  Future<List<Refund>> getRefundsByDateRange(DateTime start, DateTime end) async {
    final isar = await DatabaseService.instance;
    final nextDay = DateTime(end.year, end.month, end.day + 1);
    return await isar.refunds
        .filter()
        .timeGreaterThan(start, include: true)
        .and()
        .timeLessThan(nextDay)
        .sortByTimeDesc()
        .findAll();
  }

  Future<void> save(Refund refund) async {
    final isar = await DatabaseService.instance;
    await isar.writeTxn(() async {
      await isar.refunds.put(refund);
    });
  }

  Stream<List<Refund>> watchRefunds() {
    if (_refundsStream == null) {
      _refundsStream = Stream.fromFuture(DatabaseService.instance).asyncExpand((isar) {
        return isar.refunds
            .where()
            .sortByTimeDesc()
            .watch(fireImmediately: true)
            .asBroadcastStream();
      }).asBroadcastStream();
    }
    return _refundsStream!;
  }
}
