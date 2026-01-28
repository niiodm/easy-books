import 'package:flutter/material.dart';

class BackupRecordTile extends StatelessWidget {
  final String title;
  final int number;
  final Widget? trailing;

  const BackupRecordTile({
    super.key,
    required this.title,
    required this.number,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text('$number record${number == 1 ? '' : 's'}'),
      trailing: trailing,
    );
  }
}

class ImportRecordTile extends StatefulWidget {
  final String title;
  final int number;
  final VoidCallback action;

  const ImportRecordTile({
    super.key,
    required this.title,
    required this.number,
    required this.action,
  });

  @override
  State<ImportRecordTile> createState() => _ImportRecordTileState();
}

class _ImportRecordTileState extends State<ImportRecordTile> {

  @override
  Widget build(BuildContext context) {
    return BackupRecordTile(
      title: widget.title,
      number: widget.number,

    );
  }
}
