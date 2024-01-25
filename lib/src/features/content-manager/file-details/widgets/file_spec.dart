import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:red_bull_flutter_case_study/src/localization/localization.dart';

class DurationFileSpec extends StatelessWidget {
  const DurationFileSpec(
    this.duration, {
    super.key,
  });

  final Duration? duration;

  @override
  Widget build(BuildContext context) {
    return FileSpec(
      title: context.l10n.file_duration,
      value: duration != null
          ? _durationFormatted
          : context.l10n.file_duration_notAvailable,
    );
  }

  String get _durationFormatted {
    final hours = duration!.inHours;
    final minutes = duration!.inMinutes;
    final seconds = duration!.inSeconds;

    return '${hours > 0 ? '${hours.toString().padLeft(2, "0")}:' : ''}${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}';
  }
}

class CreationDateFileSpec extends StatelessWidget {
  const CreationDateFileSpec(
    this.creationDate, {
    super.key,
  });

  final DateTime? creationDate;

  @override
  Widget build(BuildContext context) {
    return FileSpec(
      title: context.l10n.file_createdAt,
      value: creationDate != null
          ? DateFormat.yMMMd().format(creationDate!)
          : context.l10n.file_createdAt_notAvailable,
    );
  }
}

class FileSpec extends StatelessWidget {
  const FileSpec({
    required this.title,
    required this.value,
    super.key,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textStyle = DefaultTextStyle.of(context).style;

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$title: ',
            style: textStyle.copyWith(
              fontWeight: FontWeight.w300,
            ),
          ),
          TextSpan(
            text: value,
            style: textStyle.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
