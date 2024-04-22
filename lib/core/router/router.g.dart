// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $chatGPTRoute,
    ];

RouteBase get $chatGPTRoute => GoRouteData.$route(
      path: '/',
      name: '/',
      parentNavigatorKey: ChatGPTRoute.$parentNavigatorKey,
      factory: $ChatGPTRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: 'image_viewer',
          name: 'image_viewer',
          parentNavigatorKey: ImageViewerRoute.$parentNavigatorKey,
          factory: $ImageViewerRouteExtension._fromState,
        ),
      ],
    );

extension $ChatGPTRouteExtension on ChatGPTRoute {
  static ChatGPTRoute _fromState(GoRouterState state) => const ChatGPTRoute();

  String get location => GoRouteData.$location(
        '/',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ImageViewerRouteExtension on ImageViewerRoute {
  static ImageViewerRoute _fromState(GoRouterState state) => ImageViewerRoute(
        imageUrl: state.uri.queryParameters['image-url']!,
      );

  String get location => GoRouteData.$location(
        '/image_viewer',
        queryParams: {
          'image-url': imageUrl,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
