import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:orioattendanceapp/Network/network.dart';

import '../AuthServices/auth_service.dart';
import '../Network/Network Manager/network_manager.dart';
import '../Utils/Constant/api_url_constant.dart';
import '../Utils/Snack Bar/custom_snack_bar.dart';
import '../models/attendance_record_model.dart';

class DailyAttendanceRecordController extends NetworkManager {
  final isLoading = false.obs;
  final attendanceRecords = <AttendanceRecord>[].obs;
  final selectedDateRangeText = ''.obs;
  DateTime? startDate;
  DateTime? endDate;

  @override
  void onInit() {
    super.onInit();
    setDefaultDateRange();
    fetchAttendanceRecords();
  }

  void setDefaultDateRange() {
    endDate = DateTime.now();
    startDate = endDate?.subtract(const Duration(days: 14));
    updateDateRangeText();
  }

  void setDateRange(DateTime? start, DateTime? end) {
    startDate = start;
    endDate = end;
    updateDateRangeText();
  }

  void updateDateRangeText() {
    if (startDate != null && endDate != null) {
      final diff = endDate!.difference(startDate!).inDays + 1;
      selectedDateRangeText.value =
          '${DateFormat('yyyy-MM-dd').format(startDate!)} to ${DateFormat('yyyy-MM-dd').format(endDate!)} ($diff days)';
    } else {
      selectedDateRangeText.value = 'Last 15 Days';
    }
  }

  Future<void> fetchAttendanceRecords() async {
    try {
      isLoading.value = true;
            final effectiveStartDate = startDate ?? DateTime.now().subtract(const Duration(days: 14));
      final effectiveEndDate = endDate ?? DateTime.now();

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
        "start_date": DateFormat('yyyy-MM-dd').format(effectiveStartDate),
        "end_date": DateFormat('yyyy-MM-dd').format(effectiveEndDate),
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
}
