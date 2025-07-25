import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ColorResources {
  //Theme One //

  static const textfeildColor = Color(0xffE0E0E0);
  static const backgroundWhiteColor = Color(0xffF9FAFB);
  static const appMainColor = Color(0xff0074FC);
  static const secondryColor = Color(0xff001E31);
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

  static LinearGradient get appBarGradient1 => const LinearGradient(
    colors: [Color(0xff001E31), Color(0xff0074FC)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static SystemUiOverlayStyle getSystemUiOverlayStyle() {
    return const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
    );
  }

  static SystemUiOverlayStyle getSystemUiOverlayAllPages({
    Color? statusBarColor,
    Brightness? statusBarIconBrightness,
    Brightness? statusBarBrightness,
    Color? systemNavigationBarColor,
    Color? systemNavigationBarDividerColor,
    Brightness? systemNavigationBarIconBrightness,
  }) {
    return SystemUiOverlayStyle(
      statusBarColor: statusBarColor ?? Colors.transparent,
      statusBarIconBrightness: statusBarIconBrightness ?? Brightness.light,
      statusBarBrightness: statusBarBrightness ?? Brightness.light,
      systemNavigationBarColor: systemNavigationBarColor ?? Colors.transparent,
      systemNavigationBarDividerColor:
          systemNavigationBarDividerColor ?? Colors.transparent,
      systemNavigationBarIconBrightness:
          systemNavigationBarIconBrightness ?? Brightness.dark,
    );
  }

  static SystemUiOverlayStyle getSystemUiOverlayAllPagesSplash() {
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light, // Explicitly set
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: secondryColor,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    );
  }
}
