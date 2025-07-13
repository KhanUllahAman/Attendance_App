import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Utils/Snack Bar/custom_snack_bar.dart';
import 'dropdown_controller.dart';

class ApplyLeaveController extends GetxController {
  final leaveTypeController = DropdownController().obs;
  final reasonController = TextEditingController();
  final isLoading = false.obs;

  final leaveTypes = ['Sick', 'Casual', 'Annual'];
  final sickRemaining = 5.obs;
  final casualRemaining = 4.obs;
  final annualRemaining = 10.obs;

  DateTime? startDate;
  DateTime? endDate;
  final selectedDateRangeText = ''.obs;

  void setLeaveType(String type) {
    leaveTypeController.value.selectItem(type);
  }

  void setDateRange(DateTime? start, DateTime? end) {
    startDate = start;
    endDate = end;
    if (start != null && end != null) {
      final diff = end.difference(start).inDays + 1;
      selectedDateRangeText.value =
          '${start.toLocal().toString().split(' ')[0]} to ${end.toLocal().toString().split(' ')[0]} ($diff days)';
    }
  }

  Future<void> submitLeaveApplication() async {
    if (leaveTypeController.value.selectedItem.isEmpty ||
        startDate == null ||
        endDate == null ||
        reasonController.text.isEmpty) {
      customSnackBar("Missing Fields", "Please fill all fields", snackBarType: SnackBarType.error);
      return;
    }

    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 2));

    isLoading.value = false;
    customSnackBar("Success", "Leave application submitted", snackBarType: SnackBarType.success);
    Get.back();
  }
}
