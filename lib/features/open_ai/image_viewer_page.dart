import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/extensions/context_extension.dart';

class ImageViewerPage extends StatefulWidget {
  const ImageViewerPage({
    required this.imageUrl,
    super.key,
  });

  final String imageUrl;

  @override
  ImageViewerState createState() => ImageViewerState();
}

class ImageViewerState extends State<ImageViewerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: context.iconTheme.copyWith(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  onPressed: () async {
                    try {
                      final url = widget.imageUrl;
                      final file =
                          await DefaultCacheManager().getSingleFile(url);

                      if (context.mounted) {
                        final box = context.findRenderObject() as RenderBox?;
                        await Share.shareXFiles(
                          [XFile(file.path)],
                          sharePositionOrigin:
                              box!.localToGlobal(Offset.zero) & box.size,
                        );
                      }
                    } catch (e) {
                      debugPrint(e.toString());
                      if (context.mounted) {
                        showOkAlertDialog(context: context, title: e.toString())
                            .ignore();
                      }
                    }
                  },
                  icon: const Icon(Icons.ios_share_rounded),
                );
              },
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: PhotoView(
        imageProvider: CachedNetworkImageProvider(widget.imageUrl),
      ),
    );
  }
}
