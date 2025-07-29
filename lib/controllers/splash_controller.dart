import 'package:get/get.dart';
import 'package:orioattendanceapp/AuthServices/auth_service.dart';
import '../Screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/notification_screen.dart';

class SplashController extends GetxController {
  final AuthService authService = AuthService();
  bool hasPendingNotification = false;

  @override
  void onReady() {
    super.onReady();
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 3));
    final authData = await authService.getAuthData();
    
    if (hasPendingNotification) {
      Get.offAllNamed(NotificationScreen.routeName);
    } else if (authData != null && authData['token'] != null) {
      Get.offAllNamed(HomeScreen.routeName);
    } else {
      Get.offAllNamed(LoginScreen.routeName);
    }
  }
}