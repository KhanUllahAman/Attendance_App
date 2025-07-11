import 'package:flutter/material.dart';

import '../Colors/color_resoursec.dart';
import '../transition/transition.dart';

class AppTheme {
  static ThemeData themeData() {
    return ThemeData(
      scaffoldBackgroundColor: ColorResources.whiteColor,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: TransitionsBuilder(),
          TargetPlatform.iOS: TransitionsBuilder(),
        },
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: ColorResources.appMainColor,
        selectionColor: ColorResources.appMainColor.withOpacity(0.3),
        selectionHandleColor: ColorResources.appMainColor,
      ),
    );
  }
}
