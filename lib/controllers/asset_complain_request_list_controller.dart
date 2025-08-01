// asset_complaint_controller.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orioattendanceapp/Network/network.dart';
import 'package:orioattendanceapp/AuthServices/auth_service.dart';

import '../Network/Network Manager/network_manager.dart';
import '../Utils/Constant/api_url_constant.dart';
import '../models/asset_complian_request_model.dart';

// class AssetComplainRequestListController extends NetworkManager {
//   final searchController = TextEditingController();
//   final RxList<AssetComplaint> complaintsList = <AssetComplaint>[].obs;
//   final RxList<AssetComplaint> filteredComplaints = <AssetComplaint>[].obs;
//   final RxBool isLoading = false.obs;
//   final RxString errorMessage = ''.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     searchController.addListener(filterComplaints);
//     fetchAssetComplaints();
//   }

//   @override
//   void onClose() {
//     searchController.dispose();
//     super.onClose();
//   }

//   void filterComplaints() {
//     final query = searchController.text.toLowerCase();
//     if (query.isEmpty) {
//       filteredComplaints.assignAll(complaintsList);
//     } else {
//       filteredComplaints.assignAll(
//         complaintsList.where((complaint) {
//           return complaint.requestType.toLowerCase().contains(query) ||
//               complaint.category.toLowerCase().contains(query) ||
//               complaint.status.toLowerCase().contains(query) ||
//               complaint.reason.toLowerCase().contains(query);
//         }).toList(),
//       );
//     }
//   }

//   Future<void> fetchAssetComplaints() async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';

//       final token = await _getToken();
//       final employeeId = await _getEmployeeId();

//       if (token == null || employeeId == null) {
//         errorMessage.value = 'Authentication error. Please log in again.';
//         isLoading.value = false;
//         return;
//       }

//       final headers = {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       };

//       final body = {'employee_id': employeeId};

//       final response = await Network.postApi(
//         null,
//         assetsComplainsList,
//         body,
//         headers,
//       ).timeout(const Duration(seconds: 15));

//       if (response['status'] == 1) {
//         complaintsList.assignAll(
//           (response['payload'] as List)
//               .map((e) => AssetComplaint.fromJson(e))
//               .toList(),
//         );
//         filteredComplaints.assignAll(complaintsList);
//       } else {
//         throw Exception(
//           response['message'] ?? 'Failed to fetch asset complaints',
//         );
//       }
//     } catch (e) {
//       errorMessage.value = 'Error fetching complaints: ${e.toString()}';
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<String?> _getToken() async {
//     return await AuthService().getToken();
//   }

//   Future<int?> _getEmployeeId() async {
//     return await AuthService().getEmployeeId();
//   }
// }


class AssetComplainRequestListController extends NetworkManager {
  final searchController = TextEditingController();
  final RxList<AssetComplaint> complaintsList = <AssetComplaint>[].obs;
  final RxList<AssetComplaint> filteredComplaints = <AssetComplaint>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool hasInitialLoad = false.obs;
  StreamSubscription? _connectivitySubscription;


  @override
  void onInit() {
    super.onInit();
    searchController.addListener(filterComplaints);
    _setupConnectivityListener();
    fetchAssetComplaints();
  }

  @override
  void onClose() {
    searchController.dispose();
    _connectivitySubscription?.cancel();
    super.onClose();
  }

    void _setupConnectivityListener() {
    _connectivitySubscription = connectionType.stream.listen((status) {
      if (status != 0 && (!hasInitialLoad.value || errorMessage.value.isNotEmpty)) {
        fetchAssetComplaints();
      }
    });
  }

  void filterComplaints() {
    final query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      filteredComplaints.assignAll(complaintsList);
    } else {
      filteredComplaints.assignAll(
        complaintsList.where((complaint) {
          return complaint.requestType.toLowerCase().contains(query) ||
              complaint.category.toLowerCase().contains(query) ||
              complaint.status.toLowerCase().contains(query) ||
              complaint.reason.toLowerCase().contains(query);
        }).toList(),
      );
    }
  }

  Future<void> fetchAssetComplaints() async {
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
        assetsComplainsList,
        body,
        headers,
      ).timeout(const Duration(seconds: 15));

      if (response['status'] == 1) {
        complaintsList.assignAll(
          (response['payload'] as List)
              .map((e) => AssetComplaint.fromJson(e))
              .toList(),
        );
        filteredComplaints.assignAll(complaintsList);
        errorMessage.value = '';
        hasInitialLoad.value = true;
      } else {
        throw Exception(
          response['message'] ?? 'Failed to fetch asset complaints',
        );
      }
    } catch (e) {
      errorMessage.value = _getErrorMessage(e);
      hasInitialLoad.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  String _getErrorMessage(dynamic e) {
    final errorStr = e.toString().toLowerCase();
    if (errorStr.contains('socket') || errorStr.contains('network')) {
      return 'Network error. Please check your connection.';
    } else if (errorStr.contains('timeout')) {
      return 'Request timeout. Please try again.';
    } else if (errorStr.contains('auth') || errorStr.contains('token')) {
      return 'Session expired. Please log in again.';
    }
    return 'Failed to load correction requests: ${e.toString()}';
  }

  Future<String?> _getToken() async {
    return await AuthService().getToken();
  }

  Future<int?> _getEmployeeId() async {
    return await AuthService().getEmployeeId();
  }
}