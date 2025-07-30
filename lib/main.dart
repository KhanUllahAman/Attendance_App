import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:orioattendanceapp/firebase_options.dart';
import 'Controllers/backgroundNotification_controller.dart';
import 'Controllers/notification_controller.dart';
import 'Controllers/splash_controller.dart';
import 'Screens/splash_screen.dart';
import 'Utils/AppWidget/App_widget.dart';
import 'Utils/Routes/routes.dart';
import 'Utils/Snack Bar/custom_snack_bar.dart';
import 'Utils/theme/theme_data.dart';
import 'screens/notification_screen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('Background message received: ${message.notification?.title}');
  final notificationController = BackgroundnotificationController();
  notificationController.newNotification();
}

Future<void> _setupFirebaseMessaging() async {
  final notificationController = Get.put(BackgroundnotificationController());

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    log('Foreground message received: ${message.notification?.title}');
    notificationController.newNotification();
    if (Get.currentRoute == NotificationScreen.routeName) {
      Get.find<NotificationController>().fetchAllNotifications();
    }

    if (message.notification != null) {
      showNotificationSnackBar(
        onTap: () => Get.toNamed(NotificationScreen.routeName),
        position: SnackPosition.TOP,
        message.notification!.title ?? 'Notification',
        message.notification!.body ?? '',
        durationSeconds: 8,
        showDismiss: true,
      );
    }
  });

  RemoteMessage? initialMessage = await FirebaseMessaging.instance
      .getInitialMessage();
  if (initialMessage != null) {
    debugPrint('App opened from terminated state via notification');
    notificationController.newNotification();

    Future.delayed(const Duration(milliseconds: 500), () {
      _handleMessage(initialMessage);
    });
  }

  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    notificationController.newNotification();
    if (Get.currentRoute == NotificationScreen.routeName) {
      Get.find<NotificationController>().fetchAllNotifications();
    }
    _handleMessage(message);
  });
}

void _handleMessage(RemoteMessage message) {
  debugPrint('Notification opened: ${message.notification?.title}');

  Future.delayed(Duration.zero, () {
    if (Get.currentRoute == SplashScreen.routeName) {
      final controller = Get.find<SplashController>();
      controller.checkAuthStatus().then((_) {
        Get.toNamed(NotificationScreen.routeName);
      });
    } else {
      Get.toNamed(NotificationScreen.routeName);
    }
  });
}

void main() async {
  if (kDebugMode) {
    debugDisableShadows = true;
  }
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await _setupFirebaseMessaging(); // Initialize FCM handlers
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: TextScaler.noScaling, boldText: false),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        showPerformanceOverlay: false,
        debugShowMaterialGrid: false,
        checkerboardRasterCacheImages: false,
        checkerboardOffscreenLayers: false,
        theme: AppTheme.themeData(),
        routes: Routes.routes,
        initialBinding: AppBindings(),
        initialRoute: SplashScreen.routeName,
        getPages: routes,
      ),
    );
  }
}
