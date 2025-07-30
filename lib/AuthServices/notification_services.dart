import 'dart:developer' as developer;
import 'package:firebase_messaging/firebase_messaging.dart';

import '../Network/network.dart';
import '../Utils/Constant/api_url_constant.dart';
import '../Utils/Snack Bar/custom_snack_bar.dart';
import '../models/fcm_model.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> registerFcmToken(int employeeId) async {
    try {
      developer.log(
        'Starting FCM token registration for employeeId: $employeeId',
      );

      // Request notification permissions
      developer.log('Requesting notification permissions...');
      NotificationSettings settings = await _firebaseMessaging
          .requestPermission(
            alert: true,
            announcement: false,
            badge: true,
            carPlay: false,
            criticalAlert: false,
            provisional: false,
            sound: true,
          );
      developer.log('Permission status: ${settings.authorizationStatus}');

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        // Get FCM token
        developer.log('Retrieving FCM token...');
        String? fcmToken = await _firebaseMessaging.getToken();
        if (fcmToken != null) {
          developer.log('FCM Token retrieved: $fcmToken');
          await _sendFcmTokenToBackend(employeeId, fcmToken);
          developer.log(
            'FCM Token registered successfully for employeeId: $employeeId',
          );
        } else {
          developer.log('Failed to retrieve FCM token: Token is null');
          // customSnackBar(
          //   'Error',
          //   'Failed to retrieve FCM token.',
          //   snackBarType: SnackBarType.error,
          // );
        }
      } else {
        developer.log(
          'Notification permissions not granted: ${settings.authorizationStatus}',
        );
        // customSnackBar(
        //   'Error',
        //   'Notification permissions not granted.',
        //   snackBarType: SnackBarType.error,
        // );
      }
    } catch (e, stackTrace) {
      developer.log('Error retrieving FCM token: $e', stackTrace: stackTrace);
      // customSnackBar(
      //   'Error',
      //   'Failed to register for notifications: $e',
      //   snackBarType: SnackBarType.error,
      // );
    }
  }

  Future<void> _sendFcmTokenToBackend(int employeeId, String token) async {
    try {
      developer.log('Sending FCM token to backend...');
      final data = {'employee_id': employeeId, 'token': token};
      developer.log('Request payload: $data');

      final response = await Network.postApi(null, fcmTokenApiUrl, data, {
        'Content-Type': 'application/json',
      });
      developer.log('FCM Token API Response: $response');

      final fcmResponse = FcmTokenResponse.fromJson(response);
      if (fcmResponse.status == 1) {
        developer.log(
          'FCM token registered successfully: ${fcmResponse.message}',
        );
        customSnackBar(
          'Success',
          fcmResponse.message,
          snackBarType: SnackBarType.success,
        );
      } else {
        developer.log('FCM token registration failed: ${fcmResponse.message}');
        customSnackBar(
          'Error',
          'Failed to register FCM token: ${fcmResponse.message}',
          snackBarType: SnackBarType.error,
        );
      }
    } catch (e, stackTrace) {
      developer.log('Error sending FCM token: $e', stackTrace: stackTrace);
      customSnackBar(
        'Error',
        'Failed to register FCM token: $e',
        snackBarType: SnackBarType.error,
      );
    }
  }
}
