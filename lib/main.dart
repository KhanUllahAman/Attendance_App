import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:orioattendanceapp/firebase_options.dart';
import 'Controllers/backgroundNotification_controller.dart';
import 'Screens/splash_screen.dart';
import 'Utils/AppWidget/App_widget.dart';
import 'Utils/Routes/routes.dart';
import 'Utils/Snack Bar/custom_snack_bar.dart';
import 'Utils/theme/theme_data.dart';
import 'screens/home_screen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('Background message received: ${message.notification?.title}');
}

Future<void> _setupFirebaseMessaging() async {
  final notificationController = Get.put(BackgroundnotificationController());
  
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    log('Foreground message received: ${message.notification?.title}');
    notificationController.newNotification();
    
    if (message.notification != null) {
      showNotificationSnackBar(
        position: SnackPosition.TOP,
        message.notification!.title ?? 'Notification',
        message.notification!.body ?? '',
        durationSeconds: 8,
        showDismiss: true,
      );
    }
  });

  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    notificationController.newNotification();
    _handleMessage(initialMessage);
  }
  
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    notificationController.newNotification();
    _handleMessage(message);
  });
}

void _handleMessage(RemoteMessage message) {
  debugPrint('Notification opened: ${message.notification?.title}');
  Get.toNamed(HomeScreen.routeName); 
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