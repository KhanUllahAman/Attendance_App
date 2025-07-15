import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:orioattendanceapp/Controllers/login_controller.dart';
import 'package:orioattendanceapp/Controllers/otp_controller.dart';
import 'package:orioattendanceapp/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/otp_model.dart'; // Assuming OtpPayload is defined here

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _usernameKey = 'username';
  static const String _userIdKey = 'user_id';
  static const String _employeeIdKey = 'employee_id';
  static const String _employeeCodeKey = 'employee_code';

  // Save authentication data to shared preferences
  Future<void> saveAuthData(OtpPayload payload) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, payload.token);
    await prefs.setString(_usernameKey, payload.username);
    await prefs.setInt(_userIdKey, payload.userId);
    await prefs.setInt(_employeeIdKey, payload.employeeId);
    await prefs.setString(_employeeCodeKey, payload.employeeCode);
  }

  // Get all authentication data as a map
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
    };
  }

  // Get individual fields
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
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
    await prefs.clear();
    await Get.offAllNamed(LoginScreen.routeName);
  }
}
