import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orioattendanceapp/Utils/Snack%20Bar/custom_snack_bar.dart';

import '../AuthServices/auth_service.dart';
import '../Network/Network Manager/network_manager.dart';
import '../Network/network.dart';
import '../Utils/Constant/api_url_constant.dart';
import '../models/leave_history_model.dart';

class LeaveHistoryController extends NetworkManager {
  final searchController = TextEditingController();
  final RxList<LeaveHistory> leaveHistoryList = <LeaveHistory>[].obs;
  final RxList<LeaveSummary> leaveSummaryList = <LeaveSummary>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    await fetchAllLeaveData();
  }

  Future<void> fetchAllLeaveData() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final token = await _getToken();
      final employeeId = await _getEmployeeId();

      if (token == null || employeeId == null) {
        errorMessage.value = 'Authentication error. Please log in again.';
        isLoading.value = false;
        return;
      }

      await Future.wait([
        fetchLeaveHistory(token, employeeId),
        fetchLeaveSummary(token, employeeId),
      ]);
    } catch (e) {
      errorMessage.value = 'Failed to load leave data: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchLeaveHistory(String token, int employeeId) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      
      final body = {'employee_id': 1};
      
      final response = await Network.postApi(
        token,
        leaveHistoryApi,
        body,
        headers,
      ).timeout(const Duration(seconds: 15));

      if (response['status'] == 1) {
        leaveHistoryList.value = (response['payload'] as List)
            .map((e) => LeaveHistory.fromJson(e))
            .toList();
      } else {
        throw Exception(response['message'] ?? 'Failed to fetch leave history');
      }
    } catch (e) {
      throw Exception('Leave history: ${e.toString()}');
    }
  }

  Future<void> fetchLeaveSummary(String token, int employeeId) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final body = {'employee_id': 1};

      final response = await Network.postApi(
        token,
        leaveSummaryApi,
        body,
        headers,
      ).timeout(const Duration(seconds: 15));

      if (response['status'] == 1) {
        leaveSummaryList.value = (response['payload'] as List)
            .map((e) => LeaveSummary.fromJson(e))
            .toList();
        customSnackBar("Success", response['message'], 
            snackBarType: SnackBarType.success);
      } else {
        throw Exception(response['message'] ?? 'Failed to fetch leave summary');
      }
    } catch (e) {
      throw Exception('Leave summary: ${e.toString()}');
    }
  }

  Future<String?> _getToken() async {
    return await AuthService().getToken();
  }

  Future<int?> _getEmployeeId() async {
    return await AuthService().getEmployeeId();
  }
}