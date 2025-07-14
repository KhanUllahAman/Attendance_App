import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orioattendanceapp/Network/Network%20Manager/network_manager.dart';

import '../Utils/Snack Bar/custom_snack_bar.dart';
import 'dropdown_controller.dart';

class AttendanceCorrectionController extends NetworkManager {
  final reasonController = TextEditingController();
  final selectedDate = Rxn<DateTime>();
  final selectedRequestType = RxnString();
  final checkInTime = Rxn<TimeOfDay>();
  final checkOutTime = Rxn<TimeOfDay>();

  final DropdownController requestTypeDropdownController = DropdownController();

  final List<String> requestTypes = [
    'missed_check_in',
    'missed_check_out',
    'wrong_time',
    'both',
    'other',
  ];

  void setSelectedDate(DateTime date) => selectedDate.value = date;

  void setCheckInTime(TimeOfDay time) => checkInTime.value = time;

  void setCheckOutTime(TimeOfDay time) => checkOutTime.value = time;

  void submitRequest() {
    if (selectedDate.value == null || selectedRequestType.value == null || reasonController.text.isEmpty) {
      customSnackBar("Error", "Please fill all required fields", snackBarType: SnackBarType.error);
      return;
    }

  }

  @override
  void onClose() {
    reasonController.dispose();
    super.onClose();
  }
}
