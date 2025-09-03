import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:orioattendanceapp/AuthServices/auth_service.dart';
import 'package:orioattendanceapp/Network/Network%20Manager/network_manager.dart';
import 'package:intl/intl.dart';
import 'package:orioattendanceapp/Network/network.dart';
import 'package:orioattendanceapp/Utils/Constant/api_url_constant.dart';
import 'package:orioattendanceapp/Utils/Snack%20Bar/custom_snack_bar.dart';
import 'package:orioattendanceapp/models/meeting_model.dart';

class MeetingController extends NetworkManager {
  RxBool isloading = false.obs;
  final selectedDateRangeText = ''.obs;
  final errorMessage = ''.obs;
  final hasInitialLoad = false.obs;
  DateTime? endDate;
  final meetingRecord = <Payload>[].obs;
  StreamSubscription? _connectivitySubscription;

  @override
  void onInit() async {
    super.onInit();

    _connectivitySubscription = connectionType.stream.listen((status) {
      if (status != 0 && !hasInitialLoad.value) {
        fetchmeetingdata();
      } else if (status != 0 && errorMessage.value.isNotEmpty) {
        fetchmeetingdata();
      }
    });

    await fetchmeetingdata();
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    super.onClose();
  }

  Future<void> fetchmeetingdata() async {
    if (connectionType.value == 0) {
      errorMessage.value = "No Internet Connection";
      isloading.value = false;
      return;
    }

    try {
      isloading.value = true;
      errorMessage.value = '';

      final effectiveEndDate = endDate ?? DateTime.now();

      final token = await AuthService().getToken();
      final employeeId = await AuthService().getEmployeeId();

      if (token == null || employeeId == null) {
        errorMessage.value = 'Authentication error. Please log in again.';
        return;
      }

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final body = {
        "end_date": DateFormat("yyyy-MM-dd").format(effectiveEndDate),
        // "employee_id": employeeId,
        "employee_id": 2,
      };
      log("This is body for meeting $body");
      final response = await Network.postApi(
        token,
        meetingUrl,
        body,
        headers,
      ).timeout(Duration(seconds: 15));

      if (response['status'] == 1) {
        log("this is response:::: $response");
        final List<dynamic> data = response['payload'] ?? [];
        log("$data , payload data");

        meetingRecord.assignAll(
          data.map((item) => Payload.fromJson(item)).toList(),
        );

        meetingRecord.sort((a, b) {
          final dateA = DateFormat("yyyy-MM-dd").parse(a.instanceDate);
          final dateB = DateFormat("yyyy-MM-dd").parse(b.instanceDate);
          return dateB.compareTo(dateA); // naya date upar
        });
        hasInitialLoad.value = true;
      } else {
        throw Exception(response['message'] ?? "Failed to fetch attendance");
      }
    } catch (e) {
      errorMessage.value = _getErrorMessage(e);
      customSnackBar(
        "Error",
        errorMessage.value,
        snackBarType: SnackBarType.error,
      );
    } finally {
      isloading.value = false;
    }
  }

  String _getErrorMessage(dynamic e) {
    final errorStr = e.toString().toLowerCase();
    if (errorStr.contains('socket') || errorStr.contains('network')) {
      return 'Network error. Please check your connection.';
    } else if (errorStr.contains('timeout')) {
      return 'Request timeout. Please try again.';
    } else if (errorStr.contains('auth')) {
      return 'Session expired. Please log in again.';
    }
    return 'Failed to load attendance: ${e.toString()}';
  }
}
