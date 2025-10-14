


import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../log/talker_logger.dart';

class DeeplinkService {
  static final DeeplinkService _instance = DeeplinkService._internal();
  factory DeeplinkService() => _instance;
  DeeplinkService._internal();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  // Callback functions
  Function(int)? onProductView;
  Function(Map<String, String>)? onCustomAction;

  /// Initialize deeplink listening
  Future<void> initialize() async {
    try {

      // Listen for incoming links when app is already running
      _linkSubscription = _appLinks.uriLinkStream.listen(
            (Uri uri) async {
          await _handleDeeplink(uri);
        },
        onError: (err) {
          logger.debug('Deeplink error: $err');
        },
      );
    } catch (e) {
      logger.debug('Deeplink initialization error: $e');
    }
  }

  Future<void> initDeepLinkListener() async {

    try {
      // Check if app was launched from a link

      final initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        _handleDeeplink(initialLink);
      }
    } catch (e) {
    }
  }
  /// Handle incoming deeplink
  Future<void> _handleDeeplink(Uri uri) async {
    try {
      await _saveLastDeeplink(uri.toString());

      logger.debug('Received deeplink: $uri');

      // Parse different deeplink patterns
      if (uri.scheme == 'gonzomotors') {
        await _handleCustomScheme(uri);
      } else if (uri.scheme == 'https' || uri.scheme == 'http') {
        await _handleHttpsLink(uri);
      }
    } catch (e) {
      logger.debug('Error handling deeplink: $e');
    }
  }

  /// Handle custom scheme links (gonzomotors://)
  Future<void> _handleCustomScheme(Uri uri) async {
    final String host = uri.host;
    final Map<String, String> params = uri.queryParameters;

    switch (host) {
      // case 'discount':
      //   final String? productId = params['id'];
      //   if (productId != null && onProductView != null) {
      //     onProductView!(int.tryParse(productId) ?? 0);
      //   }
      //   break;
      default:
        if (onCustomAction != null) {
          onCustomAction!({
            'host': host,
            'path': uri.path,
            ...params,
          });
        }
    }
  }

  /// Handle HTTPS links
  Future<void> _handleHttpsLink(Uri uri) async {
    final List<String> pathSegments = uri.pathSegments;
    final Map<String, String> params = uri.queryParameters;

    if (uri.path.isEmpty) return;

    switch (uri.path) {
      // case '/discount':
      //   onProductView?.call(int.tryParse(uri.queryParameters['id'] ?? '') ?? 0);
      //   break;
      default:
        if (onCustomAction != null) {
          onCustomAction!({
            'host': uri.host,
            'path': uri.path,
            'segments': pathSegments.join('/'),
            ...params,
          });
        }
    }
  }

  /// Save last deeplink for debugging
  Future<void> _saveLastDeeplink(String link) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_deeplink', link);
    await prefs.setInt(
        'last_deeplink_time', DateTime.now().millisecondsSinceEpoch);
  }

  /// Get last deeplink (for debugging)
  Future<String?> getLastDeeplink() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('last_deeplink');
  }

  /// Create deeplink URLs
  static String createProductLink(String carId) {
    return 'gonzomotors://car?id=$carId';
  }

  static String createHttpsLink(String path, [Map<String, String>? params]) {
    String url = 'https://gonzomotors.uz/$path';
    if (params != null && params.isNotEmpty) {
      final query = params.entries
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
          .join('&');
      url += '?$query';
    }
    return url;
  }

  /// Dispose resources
  void dispose() {
    _linkSubscription?.cancel();
  }
}
