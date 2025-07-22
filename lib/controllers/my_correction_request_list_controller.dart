import 'package:flutter/material.dart';
import 'package:orioattendanceapp/Network/Network%20Manager/network_manager.dart';
import 'package:get/get.dart';
import 'package:orioattendanceapp/Network/network.dart';
import 'package:orioattendanceapp/AuthServices/auth_service.dart';

import '../Utils/Constant/api_url_constant.dart';
import '../models/attendance_correction_list_model.dart';

class MyCorrectionRequestListController extends NetworkManager {
  final searchController = TextEditingController();
  final RxList<AttendanceCorrection> correctionsList =
      <AttendanceCorrection>[].obs;
  final RxList<AttendanceCorrection> filteredCorrections =
      <AttendanceCorrection>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(_filterCorrections);
    fetchCorrectionRequests();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void _filterCorrections() {
    final query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      filteredCorrections.assignAll(correctionsList);
    } else {
      filteredCorrections.assignAll(
        correctionsList.where((correction) {
          return correction.formattedAttendanceDate.toLowerCase().contains(
                query,
              ) ||
              correction.requestTypeDisplay.toLowerCase().contains(query) ||
              correction.statusText.toLowerCase().contains(query);
        }).toList(),
      );
    }
  }

  Future<void> fetchCorrectionRequests() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final token = await _getToken();
      final employeeId = await _getEmployeeId();

      if (token == null || employeeId == null) {
        errorMessage.value = 'Authentication error. Please log in again.';
        isLoading.value = false;
        return;
      }

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final body = {'employee_id': employeeId};

      final response = await Network.postApi(
        null,
        attendnceCorrectionListApi,
        body,
        headers,
      ).timeout(const Duration(seconds: 15));

      if (response['status'] == 1) {
        correctionsList.assignAll(
          (response['payload'] as List)
              .map((e) => AttendanceCorrection.fromJson(e))
              .toList(),
        );
        filteredCorrections.assignAll(correctionsList);
      } else {
        throw Exception(
          response['message'] ?? 'Failed to fetch correction requests',
        );
      }
    } catch (e) {
      errorMessage.value = 'Error fetching corrections: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> _getToken() async {
    return await AuthService().getToken();
  }

  Future<int?> _getEmployeeId() async {
    return await AuthService().getEmployeeId();
  }
}
