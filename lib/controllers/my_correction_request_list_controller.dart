import 'dart:async';

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



// class MyCorrectionRequestListController extends NetworkManager {
//   final searchController = TextEditingController();
//   final RxList<AttendanceCorrection> correctionsList = <AttendanceCorrection>[].obs;
//   final RxList<AttendanceCorrection> filteredCorrections = <AttendanceCorrection>[].obs;
//   final RxBool isLoading = false.obs;
//   final RxBool isRefreshing = false.obs;
//   final RxString errorMessage = ''.obs;
//   final RxBool hasInitialLoad = false.obs;
//   StreamSubscription? _connectivitySubscription;

//   @override
//   void onInit() {
//     super.onInit();
//     searchController.addListener(_filterCorrections);
//     _setupConnectivityListener();
//     fetchCorrectionRequests();
//   }

//   @override
//   void onClose() {
//     searchController.dispose();
//     _connectivitySubscription?.cancel();
//     super.onClose();
//   }

//   void _setupConnectivityListener() {
//     _connectivitySubscription = connectionType.stream.listen((status) {
//       if (status != 0 && (!hasInitialLoad.value || errorMessage.value.isNotEmpty)) {
//         fetchCorrectionRequests();
//       }
//     });
//   }

//   void _filterCorrections() {
//     final query = searchController.text.toLowerCase();
//     if (query.isEmpty) {
//       filteredCorrections.assignAll(correctionsList);
//     } else {
//       filteredCorrections.assignAll(
//         correctionsList.where((correction) {
//           return correction.formattedAttendanceDate.toLowerCase().contains(query) ||
//               correction.requestTypeDisplay.toLowerCase().contains(query) ||
//               correction.statusText.toLowerCase().contains(query);
//         }).toList(),
//       );
//     }
//   }

//   Future<void> fetchCorrectionRequests({bool isRefresh = false}) async {
//     if (connectionType.value == 0) {
//       errorMessage.value = 'No internet connection';
//       isLoading.value = false;
//       isRefreshing.value = false;
//       return;
//     }

//     try {
//       isRefresh ? isRefreshing.value = true : isLoading.value = true;
//       errorMessage.value = '';

//       final token = await _getToken();
//       final employeeId = await _getEmployeeId();

//       if (token == null || employeeId == null) {
//         errorMessage.value = 'Authentication error. Please log in again.';
//         return;
//       }

//       final headers = {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       };

//       final body = {'employee_id': employeeId};

//       final response = await Network.postApi(
//         null,
//         attendnceCorrectionListApi,
//         body,
//         headers,
//       ).timeout(const Duration(seconds: 15));

//       if (response['status'] == 1) {
//         correctionsList.assignAll(
//           (response['payload'] as List)
//               .map((e) => AttendanceCorrection.fromJson(e))
//               .toList(),
//         );
//         filteredCorrections.assignAll(correctionsList);
//         errorMessage.value = '';
//         hasInitialLoad.value = true;
//       } else {
//         throw Exception(response['message'] ?? 'Failed to fetch correction requests');
//       }
//     } catch (e) {
//       errorMessage.value = _getErrorMessage(e);
//       hasInitialLoad.value = false;
//     } finally {
//       isLoading.value = false;
//       isRefreshing.value = false;
//     }
//   }

//   Future<void> refreshData() async {
//     await fetchCorrectionRequests(isRefresh: true);
//   }

//   String _getErrorMessage(dynamic e) {
//     final errorStr = e.toString().toLowerCase();
//     if (errorStr.contains('socket') || errorStr.contains('network')) {
//       return 'Network error. Please check your connection.';
//     } else if (errorStr.contains('timeout')) {
//       return 'Request timeout. Please try again.';
//     } else if (errorStr.contains('auth') || errorStr.contains('token')) {
//       return 'Session expired. Please log in again.';
//     }
//     return 'Failed to load correction requests: ${e.toString()}';
//   }

//   Future<String?> _getToken() async {
//     return await AuthService().getToken();
//   }

//   Future<int?> _getEmployeeId() async {
//     return await AuthService().getEmployeeId();
//   }
// }