import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orioattendanceapp/Controllers/leave_history_controller.dart';
import '../AuthServices/auth_service.dart';
import '../Network/Network Manager/network_manager.dart';
import '../Network/network.dart';
import '../Utils/Constant/api_url_constant.dart';
import '../Utils/Snack Bar/custom_snack_bar.dart';
import '../models/leave_type_model.dart';
import 'dropdown_controller.dart';

class ApplyLeaveController extends NetworkManager {
  final leaveTypeController = DropdownController().obs;
  final reasonController = TextEditingController();
  final isLoading = false.obs;
  final leaveTypesList = <LeaveType>[].obs;

  final sickRemaining = 0.obs;
  final casualRemaining = 0.obs;
  final annualRemaining = 0.obs;

  DateTime? startDate;
  DateTime? endDate;
  final selectedDateRangeText = ''.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    await fetchLeaveTypes();
  }

  void setLeaveType(String type) {
    leaveTypeController.value.selectItem(type);
    update();
  }

  void setDateRange(DateTime? start, DateTime? end) {
    startDate = start;
    endDate = end;
    if (start != null && end != null) {
      final diff = end.difference(start).inDays + 1;
      selectedDateRangeText.value =
          '${start.toLocal().toString().split(' ')[0]} to ${end.toLocal().toString().split(' ')[0]} ($diff days)';
    }
    update();
  }

  Future<void> fetchLeaveTypes() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final token = await _getToken();
      if (token == null) {
        errorMessage.value = 'Authentication error. Please log in again.';
        isLoading.value = false;
        return;
      }

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await Network.getApi(
        leaveTypesApi,
        headers: headers,
      ).timeout(const Duration(seconds: 15));

      if (response['success'] == true) {
        leaveTypesList.assignAll(
          (response['data'] as List).map((e) => LeaveType.fromJson(e)).toList(),
        );

        for (var type in leaveTypesList) {
          if (type.name.toLowerCase() == 'sick') {
            sickRemaining.value = type.totalQuota;
          } else if (type.name.toLowerCase() == 'casual') {
            casualRemaining.value = type.totalQuota;
          } else if (type.name.toLowerCase() == 'annual') {
            annualRemaining.value = type.totalQuota;
          }
        }
        log("Leave types loaded: ${leaveTypesList.length}");
      } else {
        throw Exception(response['message'] ?? 'Failed to fetch leave types');
      }
    } catch (e) {
      errorMessage.value = 'Error fetching leave types: ${e.toString()}';
      log("Error fetching leave types: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> submitLeaveApplication(BuildContext context) async {
    try {
      if (leaveTypeController.value.selectedItem.isEmpty ||
          startDate == null ||
          endDate == null ||
          reasonController.text.isEmpty) {
        customSnackBar(
          "Missing Fields",
          "Please fill all fields",
          snackBarType: SnackBarType.error,
        );
        return;
      }

      isLoading.value = true; 
      update();

      final token = await _getToken();
      final employeeId = await _getEmployeeId();

      if (token == null || employeeId == null) {
        errorMessage.value = 'Authentication error. Please log in again.';
        isLoading.value = false;
        update();
        return;
      }

      final selectedType = leaveTypesList.firstWhere(
        (type) =>
            type.name.toLowerCase() ==
            leaveTypeController.value.selectedItem.toLowerCase(),
        orElse: () => LeaveType(id: 0, name: '', totalQuota: 0),
      );

      if (selectedType.id == 0) {
        throw Exception('Invalid leave type selected');
      }

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final body = {
        "employee_id": employeeId,
        "leave_type_id": selectedType.id,
        "start_date": startDate!.toIso8601String().split('T')[0],
        "end_date": endDate!.toIso8601String().split('T')[0],
        "reason": reasonController.text,
      };

      final response = await Network.postApi(
        null,
        applyLeaveApi,
        body,
        headers,
      ).timeout(const Duration(seconds: 15));

      if (response['status'] == 1) {
        clearFormFields();
        customSnackBar(
          "Success",
          response['message'] ?? "Leave application submitted",
          snackBarType: SnackBarType.success,
        );
        // Refresh leave history
        final leaveHistoryController = Get.find<LeaveHistoryController>();
        await leaveHistoryController.fetchAllLeaveData();
        await Future.delayed(const Duration(milliseconds: 1500));
        Navigator.pop(context);
        
      } else {
        throw Exception(
          response['message'] ?? 'Failed to submit leave application',
        );
      }
    } catch (e) {
      customSnackBar(
        "Something went wrong",
        e.toString(),
        snackBarType: SnackBarType.error,
      );
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<String?> _getToken() async {
    return await AuthService().getToken();
  }

  Future<int?> _getEmployeeId() async {
    return await AuthService().getEmployeeId();
  }

   void clearFormFields() {
    leaveTypeController.value.selectedItem;
    reasonController.clear();
    startDate = null;
    endDate = null;
    selectedDateRangeText.value = '';
    update();
  }
}
