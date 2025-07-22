import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:orioattendanceapp/Network/network.dart';

import '../AuthServices/auth_service.dart';
import '../Network/Network Manager/network_manager.dart';
import '../Utils/AppWidget/App_widget.dart';
import '../Utils/Constant/api_url_constant.dart';
import '../Utils/Snack Bar/custom_snack_bar.dart';
import '../models/attendance_record_model.dart';

class DailyAttendanceRecordController extends NetworkManager {
  final isLoading = false.obs;
  final attendanceRecords = <AttendanceRecord>[].obs;
  final startDate = Rxn<DateTime>();
  final endDate = Rxn<DateTime>();

  Future<void> fetchAttendanceRecords() async {
    try {
      if (startDate.value == null || endDate.value == null) {
        customSnackBar(
          "Error",
          "Please select both start and end dates",
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
      var headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
      var body = {
        "employee_id": employeeId,
        "start_date": DateFormat('yyyy-MM-dd').format(startDate.value!),
        "end_date": DateFormat('yyyy-MM-dd').format(endDate.value!),
      };
      final response = await Network.postApi(null, dailyAttendanceRecordApi, body, headers);
      if (response['status'] == 1) {
        final List<dynamic> data = response['payload'] ?? [];
        attendanceRecords.assignAll(
          data.map((item) => AttendanceRecord.fromJson(item)).toList(),
        );
      } else {
        throw Exception(response['message'] ?? "Failed to fetch attendance");
      }
    } catch (e) {
      customSnackBar("Error", e.toString(), snackBarType: SnackBarType.error);
    } finally {
      isLoading.value = false;
    }
  }

  void showDatePicker(BuildContext context, {required bool isStartDate}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CustomDatePicker(
        initialDate: isStartDate 
            ? startDate.value 
            : endDate.value,
        firstDate: DateTime.now().subtract(const Duration(days: 365)),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        onDateSelected: (date) {
          if (isStartDate) {
            startDate.value = date;
          } else {
            endDate.value = date;
          }
        },
      ),
    );
  }

  void clearDates() {
    startDate.value = null;
    endDate.value = null;
    attendanceRecords.clear();
  }


}
