import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extension.dart';
import '../../../core/extensions/date_time_extension.dart';
import '../../../core/providers/locale_type_controller.dart';
import '../../../core/res/text_styles.dart';

class DateTile extends ConsumerWidget {
  const DateTile({
    required this.date,
    this.color = Colors.white,
    this.backgroundColor = Colors.black54,
    super.key,
  });

  final DateTime date;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale =
        ref.watch(localeTypeControllerProvider)?.toLocale ?? context.locale;
    return Center(
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: backgroundColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          child: Text(
            _getLabel(context, locale),
            style: context.smallStyle.copyWith(color: color),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  String _getLabel(BuildContext context, Locale locale) {
    final now = DateTime.now().toUtc();
    final self = date.setHour(0, 0, 0, 0, 0);
    final difference = now.difference(self);
    final sec = difference.inSeconds;
    if (sec >= 60 * 60 * 24 * 30) {
      return date.format(
        format: locale.languageCode == LocaleType.ja.languageCode
            ? 'yyyy.M.d (E)'
            : 'E, M.d.yyyy',
        locale: locale.languageCode,
      );
    } else if (difference.inDays == 1) {
      return context.l10n.yesterday;
    } else if (sec >= 60 * 60 * 24) {
      return context.l10n.xDaysAgo(difference.inDays);
    } else {
      return context.l10n.today;
    }
  }
}
