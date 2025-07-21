// wifi_network_controller.dart
import 'package:get/get.dart';
import 'package:orioattendanceapp/Network/Network%20Manager/network_manager.dart';
import 'package:orioattendanceapp/Network/network.dart';
import 'package:orioattendanceapp/Models/wifi_network_model.dart';
import 'package:orioattendanceapp/AuthServices/auth_service.dart';

import '../Utils/Constant/api_url_constant.dart';

class WifiNetworkController extends NetworkManager {
  final RxList<WifiNetwork> wifiNetworks = <WifiNetwork>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWifiNetworks();
  }

  Future<void> fetchWifiNetworks() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final token = await AuthService().getToken();
      if (token == null) {
        errorMessage.value = 'Authentication error. Please log in again.';
        isLoading.value = false;
        return;
      }

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await Network.getApi(
        allWifiNetworkApi,
        headers: headers,
      ).timeout(const Duration(seconds: 15));

      if (response['status'] == 1) {
        wifiNetworks.assignAll(
          (response['payload'] as List)
              .map((e) => WifiNetwork.fromJson(e))
              .toList(),
        );
      } else {
        throw Exception(response['message'] ?? 'Failed to fetch WiFi networks');
      }
    } catch (e) {
      errorMessage.value = 'Error fetching WiFi networks: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }
}
