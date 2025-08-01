import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:orioattendanceapp/Screens/login_screen.dart';
import 'package:orioattendanceapp/screens/apply_leave_screen.dart';
import 'package:orioattendanceapp/screens/forgot_password_screen.dart';
import 'package:orioattendanceapp/screens/home_screen.dart';
import 'package:orioattendanceapp/screens/otp_screen.dart';
import 'package:orioattendanceapp/screens/profile_view_screen.dart';

import '../../Screens/splash_screen.dart';
import '../../screens/asset_complain_request_screen.dart';
import '../../screens/asset_complain_request_screen_list.dart';
import '../../screens/attendance_correction_request.dart';
import '../../screens/change_password_screen.dart';
import '../../screens/daily_attendance_record_screen.dart';
import '../../screens/leave_history_page_screen.dart';
import '../../screens/menu_screen.dart';
import '../../screens/my_correction_request_list.dart';
import '../../screens/notification_screen.dart';
import '../../screens/office_wifi_screen.dart';

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
  GetPage(
    name: LeaveHistoryPageScreen.routeName,
    page: () =>  LeaveHistoryPageScreen(),
  ),
  GetPage(
    name: NotificationScreen.routeName,
    page: () =>  NotificationScreen(),
  ),
  GetPage(
    name: ProfileViewScreen.routeName,
    page: () =>  ProfileViewScreen(),
  ),
  GetPage(name: MenuScreen.routeName, page: () => const MenuScreen()),
  GetPage(
    name: ChangePasswordScreen.routeName,
    page: () => const ChangePasswordScreen(),
  ),
  GetPage(
    name: AttendanceCorrectionRequest.routeName,
    page: () =>  AttendanceCorrectionRequest(),
  ),
  GetPage(
    name: MyCorrectionRequestList.routeName,
    page: () =>  MyCorrectionRequestList(),
  ),
  GetPage(
    name: AssetComplainRequestScreenList.routeName,
    page: () =>  AssetComplainRequestScreenList(),
  ),
  GetPage(
    name: AssetComplainRequestScreen.routeName,
    page: () =>  AssetComplainRequestScreen(),
  ),
  GetPage(
    name: OfficeWifiScreen.routeName,
    page: () =>  OfficeWifiScreen(),
  ),
  GetPage(
    name: DailyAttendanceRecordScreen.routeName,
    page: () =>  DailyAttendanceRecordScreen(),
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
    LeaveHistoryPageScreen.routeName: (context) =>
         LeaveHistoryPageScreen(),
    NotificationScreen.routeName: (context) =>  NotificationScreen(),
    ProfileViewScreen.routeName: (context) =>  ProfileViewScreen(),
    MenuScreen.routeName: (context) => const MenuScreen(),
    ChangePasswordScreen.routeName: (context) => const ChangePasswordScreen(),
    AttendanceCorrectionRequest.routeName: (context) =>
         AttendanceCorrectionRequest(),
    MyCorrectionRequestList.routeName: (context) =>
         MyCorrectionRequestList(),
    AssetComplainRequestScreenList.routeName: (context) =>
         AssetComplainRequestScreenList(),
    AssetComplainRequestScreen.routeName: (context) =>
         AssetComplainRequestScreen(),
      OfficeWifiScreen.routeName: (context) =>
         OfficeWifiScreen(),
          DailyAttendanceRecordScreen.routeName: (context) =>
         DailyAttendanceRecordScreen(),
  };
}
