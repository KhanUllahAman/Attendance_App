// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:orioattendanceapp/Network/Network%20Manager/network_manager.dart';

// import '../AuthServices/auth_service.dart';
// import '../Network/network.dart';
// import '../Utils/Constant/api_url_constant.dart';
// import '../Utils/Snack Bar/custom_snack_bar.dart';
// import '../models/login_model.dart';
// import '../models/otp_model.dart';
// import '../screens/otp_screen.dart';

// class LoginController extends NetworkManager {
//   final RxBool isLoading = false.obs;
//   final TextEditingController userIdController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final AuthService authService = AuthService();
//   final RxString errorMessage = ''.obs;

//   Future<void> login() async {
//     if (connectionType == 0) {
//       customSnackBar(
//         'No Connection',
//         'No internet connection available.',
//         snackBarType: SnackBarType.error,
//       );
//       errorMessage.value = 'No internet connection';
//       return;
//     }

//     isLoading.value = true;
//     try {
//       final data = {
//         'username': userIdController.text.trim(),
//         'password': passwordController.text.trim(),
//       };
//       log(data.toString());
//       final response = await Network.postApi(null, loginUrl, data, {
//         'Content-Type': 'application/json',
//       });

//       final loginResponse = LoginResponse.fromJson(response);

//       if (loginResponse.status == 1) {
//         customSnackBar(
//           'Login Successful',
//           'Proceeding to OTP verification.',
//           snackBarType: SnackBarType.success,
//         );
//         log("Login Success");
//         await requestOtp(userIdController.text.trim());
//       } else {
//         errorMessage.value = loginResponse.message;
//         customSnackBar(
//           'Login Failed',
//           loginResponse.message,
//           snackBarType: SnackBarType.error,
//         );
//         log("Login Error");
//       }
//     } catch (e) {
//       errorMessage.value = 'An error occurred. Please try again.';
//       customSnackBar(
//         'Error',
//         'An error occurred. Please try again.',
//         snackBarType: SnackBarType.error,
//       );
//       log("Login Erorr 1");
//       log('Login error: $e');
//     } finally {
//       isLoading.value = false;
//       log("Login Erorr 2");
//     }
//   }

//   Future<void> requestOtp(String username) async {
//     try {
//       final response = await Network.postApi(
//         null,
//         sendOtp,
//         {'username': username},
//         {'Content-Type': 'application/json'},
//       );
//       log(response);
//       final otpResponse = OtpResponse.fromJson(response);
//       if (otpResponse.status == 1) {
//         customSnackBar(
//           'OTP Sent',
//           otpResponse.message,
//           snackBarType: SnackBarType.success,
//         );
//         log("Request Otp Send");
//         Get.toNamed(OtpScreen.routeName, arguments: {'username': username});
//       } else {
//         errorMessage.value = otpResponse.message;
//         customSnackBar(
//           'OTP Request Failed',
//           otpResponse.message,
//           snackBarType: SnackBarType.error,
//         );
//         log("Request Otp error 1");
//       }
//     } catch (e) {
//       errorMessage.value = 'Failed to request OTP. Please try again.';
//       customSnackBar(
//         'Error',
//         'Failed to request OTP. Please try again.',
//         snackBarType: SnackBarType.error,
//       );
//       log('OTP request error: $e');
//     }
//   }

//   @override
//   void onClose() {
//     userIdController.dispose();
//     passwordController.dispose();
//     super.onClose();
//   }
// }


import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orioattendanceapp/Network/Network%20Manager/network_manager.dart';
import '../AuthServices/auth_service.dart';
import '../Network/network.dart';
import '../Utils/Constant/api_url_constant.dart';
import '../Utils/Snack%20Bar/custom_snack_bar.dart';
import '../models/login_model.dart';
import '../models/otp_model.dart';
import '../screens/otp_screen.dart';

class LoginController extends NetworkManager {
  final RxBool isLoading = false.obs;
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();
  final RxString errorMessage = ''.obs;

  Future<void> login() async {
    if (connectionType.value == 0) {
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
      final data = {
        'username': userIdController.text.trim(),
        'password': passwordController.text.trim(),
      };
      developer.log('Login Request Data: $data');
      final response = await Network.postApi(
        null,
        loginUrl,
        data,
        {'Content-Type': 'application/json'},
      );

      // Ensure response is a Map
      if (response is! Map<String, dynamic>) {
        throw Exception('Invalid response format from server');
      }

      final loginResponse = LoginResponse.fromJson(response);

      if (loginResponse.status == 1) {
        customSnackBar(
          'Login Successful',
          'Proceeding to OTP verification.',
          snackBarType: SnackBarType.success,
        );
        developer.log('Login Success');
        await requestOtp(userIdController.text.trim());
      } else {
        errorMessage.value = loginResponse.message;
        customSnackBar(
          'Login Failed',
          loginResponse.message,
          snackBarType: SnackBarType.error,
        );
        developer.log('Login Error: ${loginResponse.message}');
      }
    } catch (e) {
      errorMessage.value = 'An error occurred. Please try again.';
      customSnackBar(
        'Error',
        e.toString().contains('non-JSON')
            ? 'Server returned an invalid response. Please check the server.'
            : 'An error occurred. Please try again.',
        snackBarType: SnackBarType.error,
      );
      developer.log('Login Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> requestOtp(String username) async {
    try {
      final response = await Network.postApi(
        null,
        sendOtp,
        {'username': username},
        {'Content-Type': 'application/json'},
      );

      // Log response as a string
      developer.log('OTP Request Response: $response');

      // Ensure response is a Map
      if (response is! Map<String, dynamic>) {
        throw Exception('Invalid response format from server');
      }

      final otpResponse = OtpResponse.fromJson(response);
      if (otpResponse.status == 1) {
        customSnackBar(
          'OTP Sent',
          otpResponse.message,
          snackBarType: SnackBarType.success,
        );
        developer.log('Request OTP Success');
        Get.toNamed(OtpScreen.routeName, arguments: {'username': username});
      } else {
        errorMessage.value = otpResponse.message;
        customSnackBar(
          'OTP Request Failed',
          otpResponse.message,
          snackBarType: SnackBarType.error,
        );
        developer.log('Request OTP Error: ${otpResponse.message}');
      }
    } catch (e) {
      errorMessage.value = 'Failed to request OTP. Please try again.';
      customSnackBar(
        'Error',
        e.toString().contains('non-JSON')
            ? 'Server returned an invalid response. Please check the server.'
            : 'Failed to request OTP. Please try again.',
        snackBarType: SnackBarType.error,
      );
      developer.log('OTP Request Error: $e');
    }
  }

  @override
  void onClose() {
    userIdController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}