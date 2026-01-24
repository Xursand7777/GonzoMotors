import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gonzo_motors/features/profile/bloc/profile_bloc.dart';
import 'package:gonzo_motors/shared/internet_connectivity/internet_connectivity_wrapper.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_observer.dart';

import 'core/di/app_injection.dart';
import 'core/bloc/observer.dart';
import 'core/log/talker_logger.dart';
import 'core/services/deeplink_service.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';

import 'features/ads_banner/bloc/ads_banner_bloc.dart';
import 'features/car_catalog/bloc/car_catalog_bloc.dart';
import 'features/connection_checker/bloc/connection_checker_bloc.dart';
import 'firebase_options.dart';


import 'core/route/app_router.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = (FlutterErrorDetails details) {
    if (!kDebugMode) {
      FirebaseCrashlytics.instance.recordFlutterError(details);
    }
  };

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);

  // iOS uchun APNS token olish
  if (Platform.isIOS) {
    String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
    if (apnsToken != null) {
      // FCM token olish
      await FirebaseMessaging.instance.getToken();
      logger.debug("Firebase Messaging Token: $apnsToken");
    } else {
      // Callback orqali token olish
      FirebaseMessaging.instance.onTokenRefresh.listen((token) {
        logger.debug("Firebase Messaging apns Token stream: $apnsToken");
      });
    }
  } else {
    // Android uchun
    final token = await FirebaseMessaging.instance.getToken();
    logger.debug("Firebase Messaging android Token: $token");
  }



  Bloc.observer = MultiBlocObserver([
    TalkerBlocObserver(talker: logger),
  ]);

  await initInjection();

  await sl<DeeplinkService>().initialize();
  await sl<NotificationService>().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AdsBannerBloc>(
          create: (_) => AdsBannerBloc(repo: sl.get())..add(const GetBannersEvent()),
        ),
        BlocProvider<CarCatalogBloc>(
          create: (_) => CarCatalogBloc(repo: sl.get()),
        ),
        BlocProvider<ConnectionCheckerBloc>(
          create: (context) => ConnectionCheckerBloc(sl.get(), sl.get()),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(sl.get(), sl.get(), sl.get(), sl.get()),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        // Оборачиваем всё в CupertinoTheme, чтобы iOS-виджеты брали цвета/шрифты
        builder: (context, child) => InternetConnectivityWrapper(
          child: CupertinoTheme(
            data: AppTheme.cupertinoFrom(context),
            child: child!,
          ),
        ),
      ),
    );
  }
}
