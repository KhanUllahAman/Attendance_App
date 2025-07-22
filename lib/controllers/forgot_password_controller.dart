import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orioattendanceapp/Network/Network%20Manager/network_manager.dart';
import 'package:orioattendanceapp/Screens/login_screen.dart';

import '../Network/network.dart';
import '../Utils/Constant/api_url_constant.dart';
import '../Utils/Snack Bar/custom_snack_bar.dart';

class ForgotPasswordController extends NetworkManager {
  final emailController = TextEditingController();
  final isLoading = false.obs;
  final formKey = GlobalKey<FormState>();

  Future<void> changePassword() async {
    try {
      if (!formKey.currentState!.validate()) return;
      isLoading.value = true;
      final body = {"employee_email": emailController.text.trim()};

      final response = await Network.postApi(
        null,
        forgotPasswordApi,
        body,
        null,
      ).timeout(const Duration(seconds: 15));

      if (response['status'] == 1) {
        customSnackBar(
          "Success",
          "Password has been sent your email",
          snackBarType: SnackBarType.success,
        );
        clearForm();
        Get.offAllNamed(LoginScreen.routeName);
      } else {
        customSnackBar(
          "Error",
          response['message'] ?? "Failed to change password",
          snackBarType: SnackBarType.error,
        );
      }
    } catch (e) {
      customSnackBar("Error", e.toString(), snackBarType: SnackBarType.error);
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    emailController.clear();
  }

  @override
  void onClose() {
    emailController.dispose();
    ;
    super.onClose();
  }
}
