import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orioattendanceapp/Network/Network%20Manager/network_manager.dart';

import 'dropdown_controller.dart';

class AssetRequestController extends NetworkManager {
  // Dropdown controllers
  final requestTypeCtrl = DropdownController();
  final categoryCtrl = DropdownController();
  final assetTypeCtrl = DropdownController();

  final reasonCtrl = TextEditingController();
  final isLoading = false.obs;

  bool isValid() {
    return requestTypeCtrl.selectedItem.value.isNotEmpty &&
        categoryCtrl.selectedItem.value.isNotEmpty &&
        assetTypeCtrl.selectedItem.value.isNotEmpty &&
        reasonCtrl.text.trim().isNotEmpty;
  }

  /// Submit Request
  void submitRequest() {
    if (!isValid()) {
      Get.snackbar(
        "Missing Fields",
        "Please fill all fields before submitting.",
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      Get.back(); 
      Get.snackbar(
        "Success",
        "Your asset request has been submitted.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    });
  }

  @override
  void onClose() {
    reasonCtrl.dispose();
    super.onClose();
  }
}
