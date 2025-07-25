import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:orioattendanceapp/Controllers/change_password_controller.dart';
import 'package:orioattendanceapp/Controllers/login_controller.dart';
import 'package:orioattendanceapp/Controllers/notification_controller.dart';
import 'package:orioattendanceapp/Controllers/otp_controller.dart';
import 'package:orioattendanceapp/Controllers/profile_view_controller.dart';
import 'package:orioattendanceapp/screens/login_screen.dart';
import 'package:orioattendanceapp/screens/my_correction_request_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Controllers/apply_leave_controller.dart';
import '../Controllers/asset_complain_request_list_controller.dart';
import '../Controllers/asset_request_controller.dart';
import '../Controllers/attendance_correction_controller.dart';
import '../Controllers/daily_attendnce_record_controller.dart';
import '../Controllers/home_screen_controller.dart';
import '../Controllers/leave_history_controller.dart';
import '../Controllers/wifi_network_controller.dart';
import '../models/otp_model.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _usernameKey = 'username';
  static const String _userIdKey = 'user_id';
  static const String _employeeIdKey = 'employee_id';
  static const String _employeeCodeKey = 'employee_code';
  static const String _fullNameKey = 'full_name';

  Future<void> saveAuthData(OtpPayload payload) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, payload.token);
    await prefs.setString(_usernameKey, payload.username);
    await prefs.setInt(_userIdKey, payload.id);
    await prefs.setInt(_employeeIdKey, payload.employeeId);
    await prefs.setString(_employeeCodeKey, payload.employee.employeeCode);
    await prefs.setString(_fullNameKey, payload.employee.fullName);
  }

  Future<Map<String, dynamic>?> getAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    if (token == null) return null;

    return {
      'token': token,
      'username': prefs.getString(_usernameKey) ?? '',
      'userId': prefs.getInt(_userIdKey) ?? 0,
      'employeeId': prefs.getInt(_employeeIdKey) ?? 0,
      'employeeCode': prefs.getString(_employeeCodeKey) ?? '',
      'fullName': prefs.getString(_fullNameKey) ?? '',
    };
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  Future<String?> getFullName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_fullNameKey);
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  Future<int?> getEmployeeId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_employeeIdKey);
  }

  Future<String?> getEmployeeCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_employeeCodeKey);
  }

  // Clear all authentication data
  Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await Get.delete<LoginController>(force: true);
    await Get.delete<OtpController>(force: true);
    await Get.delete<HomeScreenController>(force: true);
    await Get.delete<LeaveHistoryController>(force: true);
    await Get.delete<ApplyLeaveController>(force: true);
    await Get.delete<AssetComplainRequestListController>(force: true);
    await Get.delete<AssetRequestController>(force: true);
    await Get.delete<AttendanceCorrectionController>(force: true);
    await Get.delete<MyCorrectionRequestList>(force: true);
    await Get.delete<WifiNetworkController>(force: true);
    await Get.delete<DailyAttendanceRecordController>(force: true);
    await Get.delete<ChangePasswordController>(force: true);
    await Get.delete<ProfileViewController>(force: true);
    await Get.delete<NotificationController>(force: true);
    await prefs.clear();
    await Get.offAllNamed(LoginScreen.routeName);
  }
}
