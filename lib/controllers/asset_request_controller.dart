import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orioattendanceapp/Controllers/asset_complain_request_list_controller.dart';
import 'package:orioattendanceapp/Network/Network%20Manager/network_manager.dart';

import '../AuthServices/auth_service.dart';
import '../Network/network.dart';
import '../Utils/Constant/api_url_constant.dart';
import '../Utils/Snack Bar/custom_snack_bar.dart';
import '../models/create_asset_complian_model.dart';
import 'dropdown_controller.dart';

class AssetRequestController extends NetworkManager {
  final requestTypeCtrl = DropdownController();
  final categoryCtrl = DropdownController();
  final assetTypeCtrl = DropdownController();
  final reasonCtrl = TextEditingController();
  final isLoading = false.obs;

  List<String> get requestTypeOptions =>
      AssetRequestType.values.map((e) => e.displayName).toList();

  List<String> get categoryOptions =>
      ComplaintCategory.values.map((e) => e.displayName).toList();

  List<String> get assetTypeOptions =>
      AssetType.values.map((e) => e.displayName).toList();

  bool isValid() {
    return requestTypeCtrl.selectedItem.value.isNotEmpty &&
        categoryCtrl.selectedItem.value.isNotEmpty &&
        assetTypeCtrl.selectedItem.value.isNotEmpty &&
        reasonCtrl.text.trim().isNotEmpty;
  }

  Future<void> submitRequest(BuildContext context) async {
    if (!isValid()) {
      customSnackBar(
        "Missing Fields",
        "Please fill all fields before submitting.",
        snackBarType: SnackBarType.error,
      );
      return;
    }

    try {
      isLoading.value = true;

      final token = await _getToken();
      final employeeId = await _getEmployeeId();

      if (token == null || employeeId == null) {
        customSnackBar(
          "Authentication Error",
          "Please login again",
          snackBarType: SnackBarType.error,
        );
        isLoading.value = false;
        return;
      }

      final requestType = AssetRequestType.fromDisplayName(
        requestTypeCtrl.selectedItem.value,
      );
      final category = ComplaintCategory.fromDisplayName(
        categoryCtrl.selectedItem.value,
      );
      final assetType = AssetType.fromDisplayName(
        assetTypeCtrl.selectedItem.value,
      );

      if (requestType == null || category == null || assetType == null) {
        throw Exception("Invalid selection");
      }

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final body = {
        "employee_id": employeeId,
        "request_type": requestType.apiValue,
        "category": category.apiValue,
        "asset_type": assetType.apiValue,
        "reason": reasonCtrl.text.trim(),
      };

      final response = await Network.postApi(
        null,
        assetsCreateComplain,
        body,
        headers,
      ).timeout(const Duration(seconds: 15));

      if (response['status'] == 1) {
        // Show success snackbar
        customSnackBar(
          "Success",
          response['message'] ?? "Asset complaint created successfully",
          snackBarType: SnackBarType.success,
        );

        clearForm();

        final listController = Get.find<AssetComplainRequestListController>();
        await listController.fetchAssetComplaints();

        Navigator.pop(context);
      } else {
        throw Exception(response['message'] ?? "Failed to submit complaint");
      }
    } catch (e) {
      customSnackBar("Error", e.toString(), snackBarType: SnackBarType.error);
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    requestTypeCtrl.clearSelection();
    categoryCtrl.clearSelection();
    assetTypeCtrl.clearSelection();
    reasonCtrl.clear();
  }

  Future<String?> _getToken() async {
    return await AuthService().getToken();
  }

  Future<int?> _getEmployeeId() async {
    return await AuthService().getEmployeeId();
  }

  @override
  void onClose() {
    requestTypeCtrl.dispose();
    categoryCtrl.dispose();
    assetTypeCtrl.dispose();
    reasonCtrl.dispose();
    super.onClose();
  }
}