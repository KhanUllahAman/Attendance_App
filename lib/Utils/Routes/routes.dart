import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:orioattendanceapp/Screens/login_screen.dart';
import 'package:orioattendanceapp/screens/apply_leave_screen.dart';
import 'package:orioattendanceapp/screens/forgot_password_screen.dart';
import 'package:orioattendanceapp/screens/home_screen.dart';
import 'package:orioattendanceapp/screens/otp_screen.dart';

import '../../Screens/splash_screen.dart';

final List<GetPage<dynamic>> routes = [
  GetPage(name: SplashScreen.routeName, page: () => const SplashScreen()),
  GetPage(name: LoginScreen.routeName, page: () => const LoginScreen()),
  GetPage(
    name: ForgotPasswordScreen.routeName,
    page: () => const ForgotPasswordScreen(),
  ),
  GetPage(name: OtpScreen.routeName, page: () => const OtpScreen()),
  GetPage(name: HomeScreen.routeName, page: () => const HomeScreen()),
  GetPage(
    name: ApplyLeaveScreen.routeName,
    page: () => const ApplyLeaveScreen(),
  ),
];

class Routes {
  static Map<String, Widget Function(BuildContext)> routes = {
    SplashScreen.routeName: (context) => const SplashScreen(),
    LoginScreen.routeName: (context) => const LoginScreen(),
    ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
    OtpScreen.routeName: (context) => const OtpScreen(),
    HomeScreen.routeName: (context) => const HomeScreen(),
    ApplyLeaveScreen.routeName: (context) => const ApplyLeaveScreen(),
  };
}
