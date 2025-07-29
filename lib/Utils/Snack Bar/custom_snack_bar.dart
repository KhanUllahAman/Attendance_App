import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
