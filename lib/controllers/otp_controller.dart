import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../AuthServices/auth_service.dart';
import '../AuthServices/notification_services.dart';
import '../Network/Network Manager/network_manager.dart';
import '../Network/network.dart';
import '../Utils/Constant/api_url_constant.dart';
import '../Utils/Snack Bar/custom_snack_bar.dart';
import '../models/otp_model.dart';
import '../screens/home_screen.dart';

class OtpController extends NetworkManager {
  final RxBool isLoading = false.obs;
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());
  final RxString username = ''.obs;
  final RxString errorMessage = ''.obs;
  final AuthService authService = AuthService();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args['username'] != null) {
      username.value = args['username'];
    }
  }

  Future<void> verifyOtp() async {
    if (connectionType == 0) {
      customSnackBar(
        'No Connection',
        'No internet connection available.',
        snackBarType: SnackBarType.error,
      );
      errorMessage.value = 'No internet connection';
      return;
    }

    isLoading.value = true;
    try {
      final otp = otpControllers.map((controller) => controller.text).join();
      final data = {'username': username.value, 'otp': int.parse(otp)};

      final response = await Network.postApi(null, verifyOtpApi, data, {
        'Content-Type': 'application/json',
      });

      final otpResponse = OtpResponse.fromJson(response);
      if (otpResponse.status == 1 && otpResponse.payload.isNotEmpty) {
        await authService.saveAuthData(otpResponse.payload.first);
        // Register FCM token after successful OTP verification
        final employeeId = otpResponse
            .payload
            .first
            .employeeId;
        await NotificationService().registerFcmToken(employeeId);
        customSnackBar(
          'OTP Verified',
          otpResponse.message,
          snackBarType: SnackBarType.success,
        );
        Get.offAllNamed(HomeScreen.routeName);
      } else {
        errorMessage.value = otpResponse.message;
        customSnackBar(
          'OTP Verification Failed',
          otpResponse.message,
          snackBarType: SnackBarType.error,
        );
      }
    } catch (e) {
      errorMessage.value = 'Failed to verify OTP. Please try again.';
      customSnackBar(
        'Error',
        'Failed to verify OTP. Please try again.',
        snackBarType: SnackBarType.error,
      );
      log('OTP verification error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.onClose();
  }
}
