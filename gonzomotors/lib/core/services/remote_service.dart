


import 'dart:convert';
import 'dart:developer';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteService {
  FirebaseRemoteConfig? _remoteConfig;
  String? studentApiUrl;
  bool passportSeries = false;
  bool passportPnfl = false;
  String appBuildNumber = '0';
  String? discountPopUp;
  RemoteConfigLinks remoteConfigLinks = RemoteConfigLinks();

  Future<void> init() async {
    _remoteConfig = FirebaseRemoteConfig.instance;
    await _remoteConfig!.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ),
    );
    await _remoteConfig?.ensureInitialized();
    await _remoteConfig?.fetchAndActivate();
    studentApiUrl = _remoteConfig!.getString('student_api');
    passportSeries = _remoteConfig!.getBool('passport_series');
    passportPnfl = _remoteConfig!.getBool('passport_pnfl');
    discountPopUp = _remoteConfig!.getString('discount_popup');
    log("discount Pop $discountPopUp");
    final links = _remoteConfig!.getString('links');
    final jsonLinks = jsonDecode(links);
    log('Links from Remote Config: $jsonLinks');
    remoteConfigLinks = RemoteConfigLinks.fromRemoteConfig(jsonLinks);

    // appBuildNumber = _remoteConfig!.getString('version');
    log('Remote Config ${_remoteConfig!.getAll()}');
    log('Remote Config initialized: $remoteConfigLinks');
  }

  Future<void> refresh() async {
    if (_remoteConfig == null) return;

    try {
      await _remoteConfig!.fetchAndActivate();
      studentApiUrl = _remoteConfig!.getString('student_api');
      passportSeries = _remoteConfig!.getBool('passport_series');
      passportSeries = _remoteConfig!.getBool('passport_pnfl');
      appBuildNumber = _remoteConfig!.getString('version');
      remoteConfigLinks = RemoteConfigLinks.fromRemoteConfig(
        jsonDecode(_remoteConfig!.getString('links')),
      );

      log('Remote Config updated: $studentApiUrl | $passportSeries');
    } catch (e) {
      log('Remote config update error: $e');
    }
  }
}

class RemoteConfigLinks {
  final bool linkSource;
  final bool linkTelegram;
  final bool linkYoutube;
  final bool linkInstagram;
  final bool linkTiktok;
  final bool linkWebsite;

  RemoteConfigLinks({
    this.linkSource = false,
    this.linkTelegram = true,
    this.linkYoutube = true,
    this.linkInstagram = true,
    this.linkTiktok = true,
    this.linkWebsite = true,
  });

  factory RemoteConfigLinks.fromRemoteConfig(Map<String, dynamic> json) {
    return RemoteConfigLinks(
      linkSource: json['source'] ?? false,
      // linkTelegram: json['telegram'] ?? false,
      // linkYoutube: json['youtube'] ?? false,
      // linkInstagram: json['instagram'] ?? false,
      // linkTiktok: json['tiktok'] ?? false,
      // linkWebsite: json['web'] ?? false,
    );
  }

  RemoteConfigLinks copyWith({
    bool? linkSource,
    bool? linkTelegram,
    bool? linkYoutube,
    bool? linkInstagram,
    bool? linkTiktok,
    bool? linkWebsite,
  }) {
    return RemoteConfigLinks(
      linkSource: linkSource ?? this.linkSource,
      linkTelegram: linkTelegram ?? this.linkTelegram,
      linkYoutube: linkYoutube ?? this.linkYoutube,
      linkInstagram: linkInstagram ?? this.linkInstagram,
      linkTiktok: linkTiktok ?? this.linkTiktok,
      linkWebsite: linkWebsite ?? this.linkWebsite,
    );
  }

  @override
  String toString() =>
      'RemoteConfigLinks(linkSource: $linkSource, linkTelegram: $linkTelegram, linkYoutube: $linkYoutube, linkInstagram: $linkInstagram, linkTiktok: $linkTiktok, linkWebsite: $linkWebsite)';
}
/// Link turlarini aniqlash uchun enum
enum LinkType {
  telegram,
  youtube,
  instagram,
  tiktok,
  website,
  unknown,
}

/// Link type uchun extension
extension LinkTypeExtension on LinkType {
  /// URL dan LinkType ni aniqlash va RemoteConfig ga qarab qaytarish
  /// Agar ijtimoiy tarmoq disabled bo'lsa, website qaytaradi
  static LinkType fromUrlWithConfig(String url, RemoteConfigLinks config) {
    if (url.isEmpty) return LinkType.website;

    final lowerUrl = url.toLowerCase();


    // Telegram - agar disabled bo'lsa website qaytadi
    if (lowerUrl.contains('t.me') ||
        lowerUrl.contains('telegram.me') ||
        lowerUrl.contains('telegram.org')) {
      return config.linkTelegram ? LinkType.telegram : LinkType.unknown;
    }

    // YouTube - agar disabled bo'lsa website qaytadi
    if (lowerUrl.contains('youtube.com') ||
        lowerUrl.contains('youtu.be') ||
        lowerUrl.contains('youtube-nocookie.com')) {
      return config.linkYoutube ? LinkType.youtube : LinkType.unknown;
    }

    // Instagram - agar disabled bo'lsa website qaytadi
    if (lowerUrl.contains('instagram.com') || lowerUrl.contains('instagr.am')) {
      return config.linkInstagram ? LinkType.instagram : LinkType.unknown;
    }

    // TikTok - agar disabled bo'lsa website qaytadi
    if (lowerUrl.contains('tiktok.com') || lowerUrl.contains('vm.tiktok.com')) {
      return config.linkTiktok ? LinkType.tiktok : LinkType.unknown;
    }

    // Default - Website
    return config.linkWebsite ?  LinkType.website : LinkType.unknown;
  }
}