import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:orioattendanceapp/Network/Network%20Manager/network_manager.dart';
import 'package:orioattendanceapp/Network/network.dart';

import '../AuthServices/auth_service.dart';
import '../Utils/Constant/api_url_constant.dart';
import '../Utils/Snack Bar/custom_snack_bar.dart';

class ChangePasswordController extends NetworkManager {
  final oldPassController = TextEditingController();
  final newPassController = TextEditingController();
  final confirmPassController = TextEditingController();
  final isLoading = false.obs;
  final formKey = GlobalKey<FormState>();

  Future<void> changePassword() async {
    try {
      if (!formKey.currentState!.validate()) return;
      if (newPassController.text != confirmPassController.text) {
        customSnackBar(
          "Error",
          "New password and confirm password don't match",
          snackBarType: SnackBarType.error,
        );
        return;
      }
      isLoading.value = true;

      final token = await AuthService().getToken();
      final employeeId = await AuthService().getEmployeeId();

      if (token == null || employeeId == null) {
        throw Exception("Authentication failed");
      }
      final header = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
      final body = {
        "employee_id": employeeId,
        "old_password": oldPassController.text.trim(),
        "new_password": newPassController.text.trim(),
      };

      final response = await Network.postApi(
        null,
        changePasswordApi,
        body,
        header,
      ).timeout(const Duration(seconds: 15));

      if (response['status'] == 1) {
        customSnackBar(
          "Success",
          response['message'] ?? "Password changed successfully",
          snackBarType: SnackBarType.success,
        );
        clearForm();
      } else {
        throw Exception(response['message'] ?? "Failed to change password");
      }
    } catch (e) {
      customSnackBar("Error", e.toString(), snackBarType: SnackBarType.error);
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    oldPassController.clear();
    newPassController.clear();
    confirmPassController.clear();
  }

  @override
  void onClose() {
    oldPassController.dispose();
    newPassController.dispose();
    confirmPassController.dispose();
    super.onClose();
  }
}
