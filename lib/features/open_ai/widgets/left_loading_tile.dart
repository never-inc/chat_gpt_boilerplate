import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../core/res/colors.dart';
import '../../../core/res/text_styles.dart';

class LeftLoadingTile extends StatelessWidget {
  const LeftLoadingTile({
    this.name,
    this.avatar,
    this.color = Colors.blueAccent,
    this.backgroundColor,
    super.key,
  });

  final String? name;
  final Color color;
  final Color? backgroundColor;
  final Widget? avatar;

  @override
  Widget build(BuildContext context) {
    final name = this.name;
    final avatar = this.avatar;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (avatar != null)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: avatar,
            ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (name != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      name,
                      style: context.smallStyle.copyWith(
                        color: ColorNames.lightGrey1,
                      ),
                      textAlign: TextAlign.start,
                      maxLines: 1,
                    ),
                  ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32).copyWith(
                      topLeft: Radius.zero,
                    ),
                    color: backgroundColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: LoadingAnimationWidget.prograssiveDots(
                      color: color,
                      size: 40,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}
