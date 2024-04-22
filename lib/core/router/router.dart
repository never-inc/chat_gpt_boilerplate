import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/open_ai/chat_page.dart';
import '../../features/open_ai/image_viewer_page.dart';

part 'router.g.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'rootNavigator');
final router = GoRouter(
  routes: $appRoutes,
  initialLocation: '/',
  navigatorKey: rootNavigatorKey,
  debugLogDiagnostics: true,
);

@TypedGoRoute<ChatGPTRoute>(
  path: '/',
  name: '/',
  routes: [
    TypedGoRoute<ImageViewerRoute>(
      path: 'image_viewer',
      name: 'image_viewer',
    ),
  ],
)
class ChatGPTRoute extends GoRouteData {
  const ChatGPTRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const ChatPage();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;
}

class ImageViewerRoute extends GoRouteData {
  const ImageViewerRoute({
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ImageViewerPage(imageUrl: imageUrl);
  }

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;
}
