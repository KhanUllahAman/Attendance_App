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
  final RxBool isDetailLoading = false.obs; // Separate loading state for details
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllNotifications();
  }

  Future<void> fetchAllNotifications() async {
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
      } else {
        throw Exception(
          response['message'] ?? 'Failed to fetch notifications',
        );
      }
    } catch (e) {
      errorMessage.value = 'Error fetching notifications: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<NotificationModel?> fetchNotificationDetails(int notificationId) async {
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
        return NotificationModel.fromJson(response['payload'][0]);
      } else {
        throw Exception(
          response['message'] ?? 'Failed to fetch notification details',
        );
      }
    } catch (e) {
      errorMessage.value = 'Error fetching notification details: ${e.toString()}';
      return null;
    } finally {
      isDetailLoading.value = false;
    }
  }

  Future<String?> _getToken() async {
    return await AuthService().getToken();
  }

  Future<int?> _getEmployeeId() async {
    return await AuthService().getEmployeeId();
  }
}
