import 'package:get/get.dart';

class BackgroundnotificationController extends GetxController {
  final RxBool hasNotification = false.obs;
  
  // Call this when a new notification arrives
  void newNotification() {
    hasNotification.value = true;
  }
  
  // Call this when notifications are viewed
  void clearNotification() {
    hasNotification.value = false;
  }
}