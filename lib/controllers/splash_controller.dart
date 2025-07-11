import 'package:get/get.dart';
import '../Screens/login_screen.dart';

class SplashController extends GetxController {

  @override
  void onReady() {
    super.onReady();
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 3));
      Get.offNamed(LoginScreen.routeName);
    } 
  }