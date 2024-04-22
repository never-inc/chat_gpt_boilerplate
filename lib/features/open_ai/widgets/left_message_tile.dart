import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/extensions/date_time_extension.dart';
import '../../../core/res/colors.dart';
import '../../../core/res/text_styles.dart';
import '../../../core/router/router.dart';

class LeftMessageTile extends StatelessWidget {
  const LeftMessageTile({
    required this.date,
    this.imageUrls,
    this.text,
    this.name,
    this.avatar,
    this.color,
    this.backgroundColor,
    super.key,
  });

  final String? text;
  final List<String>? imageUrls;
  final DateTime date;
  final String? name;
  final Widget? avatar;
  final Color? color;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final text = this.text;
    final imageUrls = this.imageUrls;
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
                        if (imageUrls != null)
                          SizedBox(
                            width: 160 * imageUrls.length.toDouble(),
                            height: 160,
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final imageUrl = imageUrls[index];

                                return Padding(
                                  padding: EdgeInsets.only(
                                    left: index == 0 ? 0 : 8,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: InkWell(
                                      onTap: () {
                                        ImageViewerRoute(imageUrl: imageUrl)
                                            .go(context);
                                      },
                                      child: SizedBox(
                                        width: 160,
                                        child: CachedNetworkImage(
                                          imageUrl: imageUrl,
                                          placeholder: (context, url) =>
                                              const CupertinoActivityIndicator(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: imageUrls.length,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                date.format(format: 'H:mm'),
                style: context.smallStyle.copyWith(
                  color: ColorNames.lightGrey1,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}
