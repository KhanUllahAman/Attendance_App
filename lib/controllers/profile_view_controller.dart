import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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
  final RxString selectedImageBase64 = ''.obs;
  final Rx<XFile?> selectedImage = Rxn<XFile>();
  final RxString dob = ''.obs; // Added to make DOB reactive

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
        Map<String, dynamic> payload;
        if (response['payload'] is List && (response['payload'] as List).isNotEmpty) {
          if (response['payload'][0] is Map) {
            payload = (response['payload'][0] as Map).cast<String, dynamic>();
          } else {
            throw Exception("Invalid payload format: Expected a Map in payload list");
          }
        } else if (response['payload'] is Map) {
          payload = (response['payload'] as Map).cast<String, dynamic>();
        } else {
          throw Exception("Invalid payload format: Expected a List or Map");
        }

        employeeProfile.value = EmployeeProfile.fromJson(payload);
        fullNameController.text = employeeProfile.value!.fullName;
        fatherNameController.text = employeeProfile.value!.fatherName ?? '';
        dobController.text = _formatDob(employeeProfile.value!.dob);
        dob.value = dobController.text; // Update reactive DOB
        emailController.text = employeeProfile.value!.email ?? '';
        phoneController.text = employeeProfile.value!.phone ?? '';
        cnicController.text = _formatCnic(employeeProfile.value!.cnic);
        addressController.text = employeeProfile.value!.address ?? '';
        selectedImageBase64.value = '';
        selectedImage.value = null;

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
            dob.value = dobController.text; // Update reactive DOB
          },
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        ),
      );
    } finally {
      _isDatePickerShowing = false;
    }
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        selectedImage.value = image;
        final bytes = await image.readAsBytes();
        String mimeType = 'image/jpeg';
        if (image.path.toLowerCase().endsWith('.png')) {
          mimeType = 'image/png';
        }
        selectedImageBase64.value = 'data:$mimeType;base64,${base64Encode(bytes)}';
      }
    } catch (e) {
      log('Error picking image: $e');
      customSnackBar("Error", "Failed to pick image", snackBarType: SnackBarType.error);
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
        'profile_picture': selectedImageBase64.value.isNotEmpty 
            ? selectedImageBase64.value 
            : profileData['profile_picture'] ?? employeeProfile.value?.profilePicture,
      };
      final response = await Network.putApi(
        null,
        profileUpdateApi,
        body,
        header,
      ).timeout(const Duration(seconds: 15));
      if (response['status'] == 1) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AuthService.fullNameKey, fullNameController.text);
        if (selectedImageBase64.value.isNotEmpty) {
          String? profilePicture;
          if (response['payload'] is List && (response['payload'] as List).isNotEmpty) {
            if (response['payload'][0] is Map) {
              profilePicture = response['payload'][0]['profile_picture']?.toString();
            }
          } else if (response['payload'] is Map) {
            profilePicture = response['payload']['profile_picture']?.toString();
          }
          await prefs.setString(AuthService.profileImage, profilePicture ?? '');
        }
        final homeController = Get.find<HomeScreenController>();
        homeController.fetchUserName();
        homeController.fetchProfileImage();
        customSnackBar(
          "Success",
          "Profile updated successfully",
          snackBarType: SnackBarType.success,
        );
        employeeProfile.value = null;
        selectedImageBase64.value = '';
        selectedImage.value = null;
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