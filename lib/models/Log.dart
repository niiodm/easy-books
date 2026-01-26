import 'package:isar/isar.dart';

part 'Log.g.dart';

@collection
class Log {
  Id id = Isar.autoIncrement;

  @Index()
  DateTime time;

  String log;

  String user;

  Log({
    required this.time,
    required this.log,
    required this.user,
  });

  Log copyWith({
    Id? id,
    DateTime? time,
    String? log,
    String? user,
  }) {
    final logEntry = Log(
      time: time ?? this.time,
      log: log ?? this.log,
      user: user ?? this.user,
    );
    if (id != null) {
      logEntry.id = id;
    }
    return logEntry;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Log &&
        id == other.id &&
        time == other.time &&
        log == other.log &&
        user == other.user;
  }

  @override
  int get hashCode => Object.hash(id, time, log, user);

  @override
  String toString() {
    return 'Log {id=$id, time=$time, log=$log, user=$user}';
  }
}
