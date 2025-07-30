import 'dart:async';

import 'package:get/get.dart';
import 'package:orioattendanceapp/Network/Network%20Manager/network_manager.dart';

import '../AuthServices/auth_service.dart';
import '../Network/network.dart';
import '../Utils/Constant/api_url_constant.dart';
import '../models/notification_model.dart';

class NotificationController extends NetworkManager {
  final RxList<NotificationModel> notificationsList = <NotificationModel>[].obs;
  final RxList<NotificationModel> filteredNotifications = <NotificationModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isDetailLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool hasInitialLoad = false.obs;
  StreamSubscription? _connectivitySubscription;
  DateTime? _lastFetchTime;

  @override
  void onInit() {
    super.onInit();
    _setupConnectivityListener();
    fetchAllNotifications();
  }

  @override
  void onClose() {
    _disposeConnectivityListener();
    super.onClose();
  }

  void _setupConnectivityListener() {
    _connectivitySubscription = connectionType.stream.listen((status) {
      if (status != 0) {
        if (!hasInitialLoad.value || 
            errorMessage.value.isNotEmpty || 
            notificationsList.isEmpty) {
          fetchAllNotifications();
        }
      }
    });
  }

  void _disposeConnectivityListener() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
  }

  Future<void> fetchAllNotifications() async {
    if (_lastFetchTime != null &&
        DateTime.now().difference(_lastFetchTime!).inSeconds < 30) {
      return; // Skip fetching if recent fetch exists
    }
    if (connectionType.value == 0) {
      errorMessage.value = 'No internet connection';
      isLoading.value = false;
      hasInitialLoad.value = false;
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final token = await _getToken();
      final employeeId = await _getEmployeeId();

      if (token == null || employeeId == null) {
        errorMessage.value = 'Authentication error. Please log in again.';
        isLoading.value = false;
        hasInitialLoad.value = false;
        return;
      }

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final body = {'employee_id': employeeId};

      final response = await Network.postApi(
        null,
        notificationListApiUrl,
        body,
        headers,
      ).timeout(const Duration(seconds: 15));

      if (response['status'] == 1) {
        notificationsList.assignAll(
          (response['payload'] as List)
              .map((e) => NotificationModel.fromJson(e))
              .toList(),
        );
        filteredNotifications.assignAll(notificationsList);
        errorMessage.value = '';
        hasInitialLoad.value = true;
        _lastFetchTime = DateTime.now(); // Update last fetch time
      } else {
        throw Exception(response['message'] ?? 'Failed to fetch notifications');
      }
    } catch (e) {
      errorMessage.value = _getErrorMessage(e);
      hasInitialLoad.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<NotificationModel?> fetchNotificationDetails(int notificationId) async {
    if (connectionType.value == 0) {
      errorMessage.value = 'No internet connection';
      isDetailLoading.value = false;
      return null;
    }

    try {
      isDetailLoading.value = true;
      errorMessage.value = '';

      final token = await _getToken();
      if (token == null) {
        errorMessage.value = 'Authentication error. Please log in again.';
        isDetailLoading.value = false;
        return null;
      }

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final body = {'notification_id': notificationId};

      final response = await Network.postApi(
        null,
        notificationDetailApiUrl,
        body,
        headers,
      ).timeout(const Duration(seconds: 15));

      if (response['status'] == 1 && response['payload'] is List && response['payload'].isNotEmpty) {
        errorMessage.value = '';
        return NotificationModel.fromJson(response['payload'][0]);
      } else {
        throw Exception(
          response['message'] ?? 'Failed to fetch notification details',
        );
      }
    } catch (e) {
      errorMessage.value = _getErrorMessage(e);
      return null;
    } finally {
      isDetailLoading.value = false;
    }
  }

  String _getErrorMessage(dynamic e) {
    final errorStr = e.toString().toLowerCase();
    if (errorStr.contains('socket') || 
        errorStr.contains('network') ||
        errorStr.contains('connect')) {
      return 'Network error. Please check your internet connection.';
    } else if (errorStr.contains('timeout')) {
      return 'Request timeout. Please try again.';
    } else if (errorStr.contains('auth') || errorStr.contains('token')) {
      return 'Authentication error. Please log in again.';
    }
    return 'An error occurred: ${e.toString()}';
  }

  Future<String?> _getToken() async {
    return await AuthService().getToken();
  }

  Future<int?> _getEmployeeId() async {
    return await AuthService().getEmployeeId();
  }
}