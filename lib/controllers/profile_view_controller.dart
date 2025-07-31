import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:orioattendanceapp/Network/Network%20Manager/network_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../AuthServices/auth_service.dart';
import '../Network/network.dart';
import '../Utils/AppWidget/App_widget.dart';
import '../Utils/Constant/api_url_constant.dart';
import '../Utils/Snack Bar/custom_snack_bar.dart';
import '../models/profile_screen_model.dart';
import 'home_screen_controller.dart';

class ProfileViewController extends NetworkManager {
  final isLoading = false.obs;
  final employeeProfile = Rxn<EmployeeProfile>();
  final fullNameController = TextEditingController();
  final fatherNameController = TextEditingController();
  final dobController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final cnicController = TextEditingController();
  final addressController = TextEditingController();
  bool _isFetching = false;
  bool _isDatePickerShowing = false;

  Future<void> fetchEmployeeProfile() async {
    if (_isFetching) return;
    _isFetching = true;
    try {
      log('Fetching profile...');
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

      final body = {"employee_id": employeeId};
      final response = await Network.postApi(
        null,
        profileGetApi,
        body,
        header,
      ).timeout(const Duration(seconds: 15));

      log('Fetch API response: $response');

      if (response['status'] == 1) {
        final Map<String, dynamic> payload = response['payload'] is List
            ? (response['payload'][0] as Map).cast<String, dynamic>()
            : (response['payload'] as Map).cast<String, dynamic>();

        employeeProfile.value = EmployeeProfile.fromJson(payload);
        fullNameController.text = employeeProfile.value!.fullName;
        fatherNameController.text = employeeProfile.value!.fatherName ?? '';
        dobController.text = _formatDob(employeeProfile.value!.dob);
        emailController.text = employeeProfile.value!.email ?? '';
        phoneController.text = employeeProfile.value!.phone ?? '';
        cnicController.text = _formatCnic(employeeProfile.value!.cnic);
        addressController.text = employeeProfile.value!.address ?? '';

        log('Profile data loaded successfully');
      } else {
        throw Exception(response['message'] ?? "Failed to fetch profile");
      }
    } catch (e) {
      log('Error fetching profile: $e');
      customSnackBar("Error", e.toString(), snackBarType: SnackBarType.error);
    } finally {
      isLoading.value = false;
      _isFetching = false;
    }
  }

  String _formatDob(String? dob) {
    if (dob == null || dob.isEmpty) return '';
    try {
      final dateFormat = DateFormat('MMMM d, yyyy');
      final date = dateFormat.parseLoose(dob);
      return DateFormat('yyyy-MM-dd').format(date);
    } catch (e) {
      try {
        final date = DateTime.parse(dob);
        return DateFormat('yyyy-MM-dd').format(date);
      } catch (e) {
        print('Error parsing DOB: $dob, error: $e');
        return '';
      }
    }
  }

  String _formatCnic(String? cnic) {
    if (cnic == null || cnic.isEmpty) return '';
    final digits = cnic.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 13) {
      return '${digits.substring(0, 5)}-${digits.substring(5, 12)}-${digits.substring(12)}';
    }
    return digits;
  }

  Future<void> showDatePicker(BuildContext context) async {
    if (_isDatePickerShowing) return;
    _isDatePickerShowing = true;
    try {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => CustomDatePicker(
          initialDate: dobController.text.isNotEmpty
              ? DateTime.tryParse(dobController.text)
              : DateTime.now(),
          onDateSelected: (date) {
            dobController.text = DateFormat('yyyy-MM-dd').format(date);
          },
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        ),
      );
    } finally {
      _isDatePickerShowing = false;
    }
  }

  Future<void> updateEmployeeProfile(Map<String, dynamic> profileData) async {
    try {
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
        'employee_id': employeeId,
        'fullname': profileData['fullname'] ?? fullNameController.text,
        'fathername': profileData['fathername'] ?? fatherNameController.text,
        'dob': profileData['dob'] ?? dobController.text,
        'email': profileData['email'] ?? emailController.text,
        'phone': profileData['phone'] ?? phoneController.text,
        'cnic': profileData['cnic'] ?? cnicController.text.replaceAll('-', ''),
        'address': profileData['address'] ?? addressController.text,
      };

      log('Sending update request with body: $body');

      final response = await Network.putApi(
        null,
        profileUpdateApi,
        body,
        header,
      ).timeout(const Duration(seconds: 15));

      log('Update API response: $response');

      if (response['status'] == 1) {
        // Update SharedPreferences with new full name
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AuthService.fullNameKey, fullNameController.text);
        final homeController = Get.find<HomeScreenController>();
        homeController.fetchUserName(); // Refresh the username
        customSnackBar(
          "Success",
          "Profile updated successfully",
          snackBarType: SnackBarType.success,
        );
        employeeProfile.value = null;
        await fetchEmployeeProfile();
      } else {
        throw Exception(response['message'] ?? "Failed to update profile");
      }
    } catch (e) {
      log('Error updating profile: $e');
      customSnackBar("Error", e.toString(), snackBarType: SnackBarType.error);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    fetchEmployeeProfile();
    super.onInit();
  }

  @override
  void onClose() {
    fullNameController.dispose();
    fatherNameController.dispose();
    dobController.dispose();
    emailController.dispose();
    phoneController.dispose();
    cnicController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
