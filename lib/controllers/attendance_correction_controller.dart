import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:orioattendanceapp/Network/Network%20Manager/network_manager.dart';

import '../AuthServices/auth_service.dart';
import '../Network/network.dart';
import '../Utils/Constant/api_url_constant.dart';
import '../Utils/Snack Bar/custom_snack_bar.dart';
import '../models/attendance_correction_request_model.dart';
import 'dropdown_controller.dart';
import 'my_correction_request_list_controller.dart';

class AttendanceCorrectionController extends NetworkManager {
  final reasonController = TextEditingController();
  final selectedDate = Rxn<DateTime>();
  final selectedRequestType = Rxn<RequestType>();
  final checkInTime = Rxn<TimeOfDay>();
  final checkOutTime = Rxn<TimeOfDay>();
  final isLoading = false.obs;

  final DropdownController requestTypeDropdownController = DropdownController();

  List<String> get requestTypeOptions =>
      RequestType.values.map((e) => e.displayName).toList();

  void setSelectedDate(DateTime date) => selectedDate.value = date;

  void setCheckInTime(TimeOfDay time) => checkInTime.value = time;

  void setCheckOutTime(TimeOfDay time) => checkOutTime.value = time;

  void setRequestType(String displayName) {
    selectedRequestType.value = RequestType.values.firstWhere(
      (type) => type.displayName == displayName,
      orElse: () => RequestType.missedCheckIn,
    );
  }

  Future<void> submitRequest(BuildContext context) async {
    try {
      // Validate date
      if (selectedDate.value == null) {
        customSnackBar(
          "Date Required",
          "Please select a date for correction",
          snackBarType: SnackBarType.error,
        );
        return;
      }

      // Validate request type
      if (selectedRequestType.value == null) {
        customSnackBar(
          "Request Type Required",
          "Please select a request type",
          snackBarType: SnackBarType.error,
        );
        return;
      }

      // Validate reason
      if (reasonController.text.isEmpty) {
        customSnackBar(
          "Reason Required",
          "Please enter a reason for correction",
          snackBarType: SnackBarType.error,
        );
        return;
      }

      // Validate time fields based on request type
      final type = selectedRequestType.value!;
      if (type.requiresCheckIn && checkInTime.value == null) {
        customSnackBar(
          "Check-In Time Required",
          "Please select check-in time",
          snackBarType: SnackBarType.error,
        );
        return;
      }

      if (type.requiresCheckOut && checkOutTime.value == null) {
        customSnackBar(
          "Check-Out Time Required",
          "Please select check-out time",
          snackBarType: SnackBarType.error,
        );
        return;
      }

      // Validate check-out time is after check-in time if both exist
      if (type.requiresCheckIn && type.requiresCheckOut) {
        final checkIn = checkInTime.value!;
        final checkOut = checkOutTime.value!;

        final checkInDateTime = DateTime(
          selectedDate.value!.year,
          selectedDate.value!.month,
          selectedDate.value!.day,
          checkIn.hour,
          checkIn.minute,
        );

        final checkOutDateTime = DateTime(
          selectedDate.value!.year,
          selectedDate.value!.month,
          selectedDate.value!.day,
          checkOut.hour,
          checkOut.minute,
        );

        if (checkOutDateTime.isBefore(checkInDateTime)) {
          customSnackBar(
            "Invalid Time Range",
            "Check-out time cannot be before check-in time",
            snackBarType: SnackBarType.error,
          );
          return;
        }
      }

      isLoading.value = true;

      final token = await _getToken();
      final employeeId = await _getEmployeeId();

      if (token == null || employeeId == null) {
        customSnackBar(
          "Authentication Error",
          "Please login again",
          snackBarType: SnackBarType.error,
        );
        isLoading.value = false;
        return;
      }

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final body = {
        "employee_id": employeeId,
        "attendance_date": DateFormat('yyyy-MM-dd').format(selectedDate.value!),
        "request_type": selectedRequestType.value!.apiValue,
        "reason": reasonController.text.trim(),
        "requested_check_in_time": type.requiresCheckIn
            ? _formatTimeForApi(checkInTime.value!)
            : null,
        "requested_check_out_time": type.requiresCheckOut
            ? _formatTimeForApi(checkOutTime.value!)
            : null,
      };

      log("This is body $body");
      final response = await Network.postApi(
        null,
        attendanceCorrectionCreateApi,
        body,
        headers,
      ).timeout(const Duration(seconds: 15));

      if (response['status'] == 1) {
        customSnackBar(
          "Success",
          response['message'] ?? "Attendance correction created successfully",
          snackBarType: SnackBarType.success,
        );
        clearForm();
        final mycorrectionrequestlistController =
            Get.find<MyCorrectionRequestListController>();
        await mycorrectionrequestlistController.fetchCorrectionRequests();
        await Future.delayed(const Duration(milliseconds: 1500));
        Navigator.pop(context);
      } else {
        throw Exception(response['message'] ?? "Failed to submit correction");
      }
    } catch (e) {
      customSnackBar("Error", e.toString(), snackBarType: SnackBarType.error);
    } finally {
      isLoading.value = false;
    }
  }

  String _formatTimeForApi(TimeOfDay time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00";
  }

  void clearForm() {
    selectedDate.value = null;
    selectedRequestType.value = null;
    checkInTime.value = null;
    checkOutTime.value = null;
    reasonController.clear();
    requestTypeDropdownController.clearSelection();
  }

  Future<String?> _getToken() async {
    return await AuthService().getToken();
  }

  Future<int?> _getEmployeeId() async {
    return await AuthService().getEmployeeId();
  }

  @override
  void onClose() {
    reasonController.dispose();
    requestTypeDropdownController.dispose();
    super.onClose();
  }
}
