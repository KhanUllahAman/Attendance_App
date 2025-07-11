import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ColorResources {
  static const textfeildColor = Color(0xffF3F2F2);
  static const appMainColor = Color(0xff0074FC);
  static const secondryColor = Color(0xff001e31);
  static const whiteColor = Color(0xffFFFFFF);
  static const blackColor = Color(0xff000000);
  static const hintTextColor = Color(0xff1A1C1E);
  static const greyColor = Color(0xff474747);
  static const blueColor = Color(0xff1565FF);
  static const containerColor = Color(0xffF3F2F2);
  static const textBlueColor = Color(0xff000C19);
  static const floatingbuttonColor = Color(0xff001E31);
  static const lightBlueColor = Color(0xffE6F1FF);

  static LinearGradient get appBarGradient => const LinearGradient(
    colors: [secondryColor, appMainColor],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static SystemUiOverlayStyle getSystemUiOverlayStyle() {
    return const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarColor: appMainColor,
      statusBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
    );
  }

  static SystemUiOverlayStyle getSystemUiOverlayAllPages(bool isDark) {
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light, // Explicitly set
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    );
  }
}
