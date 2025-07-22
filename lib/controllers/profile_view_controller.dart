import 'package:get/get.dart';

import '../AuthServices/auth_service.dart';
import '../Network/Network Manager/network_manager.dart';
import '../Network/network.dart';
import '../Utils/Constant/api_url_constant.dart';
import '../Utils/Snack Bar/custom_snack_bar.dart';
import '../models/profile_screen_model.dart';

class ProfileViewController extends NetworkManager {
  final isLoading = false.obs;
  final employeeProfile = Rxn<EmployeeProfile>();

  Future<void> fetchEmployeeProfile() async {
    try {
      isLoading.value = true;

      final token = await AuthService().getToken();
      final employeeId = await AuthService().getEmployeeId();

      if (token == null || employeeId == null) {
        throw Exception("Authentication failed");
      }
      final header = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
      final body = {"employee_id": employeeId};
      final response = await Network.postApi(
        null,
        profileGetApi,
        body,
        header,
      ).timeout(const Duration(seconds: 15));

      if (response['status'] == 1) {
        final data =
            response['payload'] is List && response['payload'].isNotEmpty
            ? response['payload'][0]
            : {};
        employeeProfile.value = EmployeeProfile.fromJson(data);
      } else {
        throw Exception(response['message'] ?? "Failed to fetch profile");
      }
    } catch (e) {
      customSnackBar("Error", e.toString(), snackBarType: SnackBarType.error);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    fetchEmployeeProfile();
    super.onInit();
  }
}
