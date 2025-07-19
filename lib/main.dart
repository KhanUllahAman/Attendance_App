import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'Screens/splash_screen.dart';
import 'Utils/AppWidget/App_widget.dart';
import 'Utils/Routes/routes.dart';
import 'Utils/theme/theme_data.dart';

void main() async {
  if (kDebugMode) {
    debugDisableShadows = true;
  }
  WidgetsFlutterBinding.ensureInitialized();
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
