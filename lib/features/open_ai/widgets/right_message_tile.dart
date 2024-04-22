import 'package:flutter/material.dart';

import '../../../core/extensions/date_time_extension.dart';
import '../../../core/res/colors.dart';
import '../../../core/res/text_styles.dart';

class RightMessageTile extends StatelessWidget {
  const RightMessageTile({
    required this.date,
    this.text,
    this.name,
    this.avatar,
    this.color,
    this.backgroundColor,
    super.key,
  });

  final String? text;
  final DateTime date;
  final String? name;
  final Color? color;
  final Color? backgroundColor;
  final Widget? avatar;

  @override
  Widget build(BuildContext context) {
    final text = this.text;
    final name = this.name;
    final avatar = this.avatar;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(width: 40),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Text(
                date.format(format: 'H:mm'),
                style: context.smallStyle.copyWith(
                  color: ColorNames.lightGrey1,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (name != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      name,
                      style: context.smallStyle.copyWith(
                        color: ColorNames.lightGrey1,
                      ),
                      textAlign: TextAlign.end,
                      maxLines: 1,
                    ),
                  ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32).copyWith(
                      topRight: Radius.zero,
                    ),
                    color: backgroundColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (text != null)
                          SelectableText(
                            text,
                            style: context.mediumStyle.copyWith(color: color),
                            textAlign: TextAlign.start,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (avatar != null)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: avatar,
            ),
        ],
      ),
    );
  }
}
