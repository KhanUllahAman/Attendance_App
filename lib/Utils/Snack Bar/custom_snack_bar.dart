import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orioattendanceapp/Utils/Colors/color_resoursec.dart';

enum SnackBarType { success, error, info }

void customSnackBar(
  String title,
  String message, {
  SnackBarType snackBarType = SnackBarType.success,
  int durationSeconds = 4,
  SnackPosition? position = SnackPosition.BOTTOM,
}) {
  if (Get.context == null) return;

  Color backgroundColor;
  IconData iconData;

  switch (snackBarType) {
    case SnackBarType.success:
      backgroundColor = Colors.green.shade600;
      iconData = Icons.check_circle_outline;
      break;
    case SnackBarType.error:
      backgroundColor = Colors.red.shade600;
      iconData = Icons.error_outline;
      break;
    case SnackBarType.info:
      backgroundColor = Colors.blue.shade600;
      iconData = Icons.info_outline;
      break;
  }

  Get.rawSnackbar(
    title: title,
    message: message,
    duration: Duration(seconds: durationSeconds),
    backgroundColor: backgroundColor,
    margin: const EdgeInsets.all(10),
    borderRadius: 8,
    icon: Icon(iconData, color: Colors.white),
    shouldIconPulse: false,
    mainButton: TextButton(
      child: const Text('DISMISS', style: TextStyle(color: Colors.white)),
      onPressed: () => Get.back(),
    ),
    snackPosition: position ?? SnackPosition.BOTTOM,
    animationDuration: const Duration(milliseconds: 300),
    isDismissible: true,
  );
}

void showNotificationSnackBar(
  String title,
  String message, {
  int durationSeconds = 4,
  SnackPosition position = SnackPosition.TOP,
  bool showDismiss = true,
}) {
  if (Get.context == null) return;

  // Custom notification styling
  const backgroundColor =
      ColorResources.backgroundWhiteColor; // Dark gray background
  const iconColor = ColorResources.appMainColor; // Orange icon color
  const textColor = ColorResources.blackColor;

  Get.rawSnackbar(
    title: title,
    titleText: Text(
      title,
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
    message: message,
    messageText: Text(
      message,
      style: TextStyle(color: textColor.withOpacity(0.9), fontSize: 14),
    ),
    duration: Duration(seconds: durationSeconds),
    backgroundColor: backgroundColor,
    margin: const EdgeInsets.all(10),
    borderRadius: 12, // Slightly more rounded
    icon: Icon(Icons.notifications_active, color: iconColor, size: 24),
    shouldIconPulse: true, // Pulsing icon for notifications
    mainButton: showDismiss
        ? TextButton(
            child: const Text(
              'DISMISS',
              style: TextStyle(color: iconColor, fontWeight: FontWeight.bold),
            ),
            onPressed: () => Get.back(),
          )
        : null,
    snackPosition: position,
    animationDuration: const Duration(milliseconds: 400),
    forwardAnimationCurve: Curves.easeOutBack,
    reverseAnimationCurve: Curves.easeInCirc,
    isDismissible: true,
    boxShadows: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 10,
        spreadRadius: 2,
        offset: const Offset(0, 4),
      ),
    ],
    borderWidth: 1,
    borderColor: Colors.white.withOpacity(0.1),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  );
}
