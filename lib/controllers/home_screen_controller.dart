import 'dart:async';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:orioattendanceapp/Utils/Snack%20Bar/custom_snack_bar.dart';
import 'dart:developer' as developer;
import '../AuthServices/auth_service.dart';
import '../Network/Network Manager/network_manager.dart';
import '../Network/network.dart';
import '../Utils/Constant/api_url_constant.dart';
import '../models/home_model.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreenController extends NetworkManager {
  final AuthService authService = AuthService();
  final RxBool isLoading = true.obs;
  final RxBool isLocationMatched = false.obs;
  final Rx<HomeScreenResponse> homeScreenData = HomeScreenResponse().obs;
  final RxString errorMessage = ''.obs;
  final RxInt matchedOfficeId = 0.obs;
  final RxString userName = ''.obs;
  final RxString greeting = ''.obs;
  final RxString currentTime = ''.obs;
  final RxString currentDate = ''.obs;
  Timer? timer;

 @override
  void onInit() async {
    super.onInit();
    await Future.wait([fetchUserName(), fetchHomeData()]);
    updateGreeting();
    startTimeUpdates();
    developer.log('HomeScreenController initialized');
  }

  void startTimeUpdates() {
    updateTimeAndDate();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      updateTimeAndDate();
    });
    developer.log('Started time update timer');
  }

  void updateTimeAndDate() {
    currentTime.value = DateFormat('hh:mm a').format(DateTime.now());
    currentDate.value = DateFormat(
      'MMMM dd, yyyy - EEEE',
    ).format(DateTime.now());
    developer.log(
      'Updated time: ${currentTime.value}, date: ${currentDate.value}',
    );
  }

  Future<void> fetchUserName() async {
    final username = await authService.getUsername();
    userName.value = username ?? 'User';
    developer.log('Username fetched: ${userName.value}');
  }

  // Update greeting based on time of day
  void updateGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      greeting.value = 'Good Morning';
    } else if (hour < 17) {
      greeting.value = 'Good Afternoon';
    } else {
      greeting.value = 'Good Evening';
    }
    developer.log('Greeting updated: ${greeting.value}');
  }

  Future<String?> _getToken() async {
    final token = await authService.getToken();
    developer.log(
      'Token fetched: ${token != null ? "Token exists" : "No token"}',
    );
    return token;
  }

  Future<int?> _getEmployeeId() async {
    final employeeId = await authService.getEmployeeId();
    developer.log('Employee ID fetched: $employeeId');
    return employeeId;
  }

  String _getCurrentDate() {
    final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    developer.log('Current date: $date');
    return date;
  }

  String _getCurrentTime() {
    final time = DateFormat('HH:mm:ss').format(DateTime.now());
    developer.log('Current time: $time');
    return time;
  }

  Future<int?> _getMatchedOfficeId(List<OfficeLocation> officeLocations) async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      developer.log('Location service enabled: $serviceEnabled');
      if (!serviceEnabled) {
        customSnackBar(
          'Error',
          'Location services are disabled. Please enable them.',
          snackBarType: SnackBarType.error,
        );
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      developer.log('Location permission status: $permission');
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        developer.log('Requested location permission: $permission');
        if (permission == LocationPermission.denied) {
          customSnackBar(
            'Error',
            'Location permissions are denied.',
            snackBarType: SnackBarType.error,
          );
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        customSnackBar(
          'Error',
          'Location permissions are permanently denied. Please enable them in settings.',
          snackBarType: SnackBarType.error,
        );
        return null;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      developer.log(
        'User location: Latitude=${position.latitude}, Longitude=${position.longitude}',
      );

      for (var office in officeLocations) {
        double distance = Geolocator.distanceBetween(
          double.parse(office.latitude),
          double.parse(office.longitude),
          position.latitude,
          position.longitude,
        );
        developer.log(
          'Distance to ${office.name} (ID: ${office.id}): $distance meters (Radius: ${office.radiusMeters})',
        );
        if (distance <= office.radiusMeters) {
          developer.log('Matched office: ${office.name} (ID: ${office.id})');
          return office.id;
        }
      }

      developer.log('No office location matched');
      customSnackBar(
        'Error',
        'You are not within any office location range.',
        snackBarType: SnackBarType.error,
      );
      return null;
    } catch (e) {
      developer.log('Location Error: $e');
      customSnackBar(
        'Error',
        'Failed to fetch location. Please try again.',
        snackBarType: SnackBarType.error,
      );
      return null;
    }
  }

  Future<void> fetchHomeData() async {
    isLoading.value = true;
    isLocationMatched.value = false;
    try {
      final token = await _getToken();
      if (token == null) {
        errorMessage.value = 'No token found. Please log in again.';
        customSnackBar(
          'Error',
          'No token found. Please log in again.',
          snackBarType: SnackBarType.error,
        );
        await authService.clearAuthData();
        developer.log('No token found, clearing auth data');
        isLoading.value = false;
        return;
      }
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      developer.log('Fetching office locations with headers: $headers');
      final officeResponse = await Network.getApi(
        getOfficeLocations,
        headers: headers,
      );
      developer.log('Office locations response: $officeResponse');

      if (officeResponse['status'] == 1) {
        final officeLocations = (officeResponse['payload'] as List)
            .map((e) => OfficeLocation.fromJson(e))
            .toList();
        homeScreenData.value = HomeScreenResponse(
          officeLocations: officeLocations,
        );
        developer.log(
          'Office locations stored: ${officeLocations.length} locations',
        );

        // Find matched office ID
        final officeId = await _getMatchedOfficeId(officeLocations);
        if (officeId != null) {
          matchedOfficeId.value = officeId;
          isLocationMatched.value = true;
          developer.log('Matched office ID: $officeId');
        } else {
          isLoading.value = false;
          developer.log('No matched office ID, stopping fetchHomeData');
          return;
        }
      } else {
        errorMessage.value = officeResponse['message'];
        customSnackBar(
          'Error',
          officeResponse['message'],
          snackBarType: SnackBarType.error,
        );
        isLoading.value = false;
        developer.log(
          'Office locations API failed: ${officeResponse['message']}',
        );
        return;
      }

      // API 2: Get Single Attendance
      final employeeId = await _getEmployeeId();
      if (employeeId == null) {
        errorMessage.value = 'Employee ID not found.';
        customSnackBar(
          'Error',
          'Employee ID not found.',
          snackBarType: SnackBarType.error,
        );
        isLoading.value = false;
        developer.log('Employee ID not found');
        return;
      }

      final attendanceBody = {
        'employee_id': employeeId,
        // 'attendance_date': _getCurrentDate(),
        'attendance_date': "2025-01-05",
      };
      final attendanceHeaders = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      developer.log(
        'Fetching single attendance with body: $attendanceBody, headers: $attendanceHeaders',
      );
      final attendanceResponse = await Network.postApi(
        token,
        getSingleAttendanceUrl,
        attendanceBody,
        attendanceHeaders,
      );
      developer.log('Single attendance response: $attendanceResponse');

      if (attendanceResponse['status'] == 1) {
        homeScreenData.value = HomeScreenResponse(
          officeLocations: homeScreenData.value.officeLocations,
          singleAttendance: (attendanceResponse['payload'] as List)
              .map((e) => Attendance.fromJson(e))
              .toList(),
        );
        developer.log(
          'Single attendance stored: ${homeScreenData.value.singleAttendance?.length ?? 0} records',
        );
      } else {
        errorMessage.value = attendanceResponse['message'];
        // customSnackBar(
        //   'Errorrrrrtrrr',
        //   attendanceResponse['message'],
        //   snackBarType: SnackBarType.error,
        // );
        developer.log(
          'Single attendance API failed: ${attendanceResponse['message']}',
        );
      }

      isLoading.value = false;
    } catch (e) {
      errorMessage.value = 'An error occurred. Please try again.';
      customSnackBar(
        'Error',
        'An error occurred while fetching data.',
        snackBarType: SnackBarType.error,
      );
      developer.log('Home Data Error: $e');
      isLoading.value = false;
    }
  }

  Future<void> checkIn() async {
    if (connectionType == 0) {
      customSnackBar(
        'No Connection',
        'No internet connection available.',
        snackBarType: SnackBarType.error,
      );
      developer.log('No internet connection for check-in');
      return;
    }

    if (matchedOfficeId.value == 0 || !isLocationMatched.value) {
      customSnackBar(
        'Error',
        'You are not within any office location range.',
        snackBarType: SnackBarType.error,
      );
      developer.log('Check-in blocked: No matched office location');
      return;
    }

    if (homeScreenData.value.singleAttendance?.isNotEmpty == true &&
        homeScreenData.value.singleAttendance![0].checkInTime != null) {
      customSnackBar(
        'Info',
        'You have already checked in today.',
        snackBarType: SnackBarType.info,
      );
      developer.log('Check-in blocked: Already checked in today');
      return;
    }

    try {
      final token = await _getToken();
      final employeeId = await _getEmployeeId();
      if (token == null || employeeId == null) {
        errorMessage.value = 'Authentication error. Please log in again.';
        customSnackBar(
          'Error',
          'Authentication error. Please log in again.',
          snackBarType: SnackBarType.error,
        );
        await authService.clearAuthData();
        developer.log('Check-in failed: No token or employee ID');
        return;
      }

      final checkInBody = {
        'employee_id': employeeId,
        // 'attendance_date': _getCurrentDate(),
        "attendance_date": "2025-01-05",
        'check_in_time': _getCurrentTime(),
        'check_in_office_location': matchedOfficeId.value,
      };
      final checkInHeaders = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      developer.log(
        'Checking in with body: $checkInBody, headers: $checkInHeaders',
      );
      final checkInResponse = await Network.postApi(
        token,
        checkInUrl,
        checkInBody,
        checkInHeaders,
      );
      developer.log('Check-in response: $checkInResponse');

      if (checkInResponse['status'] == 1) {
        homeScreenData.value = HomeScreenResponse(
          officeLocations: homeScreenData.value.officeLocations,
          singleAttendance: homeScreenData.value.singleAttendance,
          checkInResponse: (checkInResponse['payload'] as List)
              .map((e) => Attendance.fromJson(e))
              .toList(),
        );
        customSnackBar(
          'Success',
          checkInResponse['message'],
          snackBarType: SnackBarType.success,
        );
        developer.log('Check-in successful: ${checkInResponse['message']}');
        // Refresh attendance data
        await fetchHomeData();
      } else {
        errorMessage.value = checkInResponse['message'];
        customSnackBar(
          'Error',
          checkInResponse['message'],
          snackBarType: SnackBarType.error,
        );
        developer.log('Check-in failed: ${checkInResponse['message']}');
      }
    } catch (e) {
      errorMessage.value = 'Failed to check in. Please try again.';
      customSnackBar(
        'Error',
        'Failed to check in. Please try again.',
        snackBarType: SnackBarType.error,
      );
      developer.log('Check In Error: $e');
    }
  }

  Future<void> checkOut() async {
    if (connectionType == 0) {
      customSnackBar(
        'No Connection',
        'No internet connection available.',
        snackBarType: SnackBarType.error,
      );
      developer.log('No internet connection for check-out');
      return;
    }

    if (matchedOfficeId.value == 0 || !isLocationMatched.value) {
      customSnackBar(
        'Error',
        'You are not within any office location range.',
        snackBarType: SnackBarType.error,
      );
      developer.log('Check-out blocked: No matched office location');
      return;
    }

    try {
      final token = await _getToken();
      final employeeId = await _getEmployeeId();
      if (token == null || employeeId == null) {
        errorMessage.value = 'Authentication error. Please log in again.';
        customSnackBar(
          'Error',
          'Authentication error. Please log in again.',
          snackBarType: SnackBarType.error,
        );
        await authService.clearAuthData();
        developer.log('Check-out failed: No token or employee ID');
        return;
      }

      final checkOutBody = {
        'employee_id': employeeId,
        // 'attendance_date': _getCurrentDate(),
        "attendance_date": "2025-01-05",
        'check_out_time': _getCurrentTime(),
        'check_out_office_location': matchedOfficeId.value,
        // 'check_out_office_location': 1,
      };
      final checkOutHeaders = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      developer.log(
        'Checking out with body: $checkOutBody, headers: $checkOutHeaders',
      );
      final checkOutResponse = await Network.postApi(
        token,
        checkOutUrl,
        checkOutBody,
        checkOutHeaders,
      );
      developer.log('Check-out response: $checkOutResponse');

      if (checkOutResponse['status'] == 1) {
        homeScreenData.value = HomeScreenResponse(
          officeLocations: homeScreenData.value.officeLocations,
          singleAttendance: homeScreenData.value.singleAttendance,
          checkInResponse: homeScreenData.value.checkInResponse,
          checkOutResponse: (checkOutResponse['payload'] as List)
              .map((e) => Attendance.fromJson(e))
              .toList(),
        );
        customSnackBar(
          'Success',
          checkOutResponse['message'],
          snackBarType: SnackBarType.success,
        );
        developer.log('Check-out successful: ${checkOutResponse['message']}');
        // Refresh attendance data
        await fetchHomeData();
      } else {
        errorMessage.value = checkOutResponse['message'];
        customSnackBar(
          'Error',
          checkOutResponse['message'],
          snackBarType: SnackBarType.error,
        );
        developer.log('Check-out failed: ${checkOutResponse['message']}');
      }
    } catch (e) {
      errorMessage.value = 'Failed to check out. Please try again.';
      customSnackBar(
        'Error',
        'Failed to check out. Please try again.',
        snackBarType: SnackBarType.error,
      );
      developer.log('Check Out Error: $e');
    }
  }

  @override
  void onClose() {
    timer?.cancel();
    isLoading.value = true;
    isLocationMatched.value = false;
    homeScreenData.value = HomeScreenResponse();
    matchedOfficeId.value = 0;
    errorMessage.value = '';
    developer.log('HomeScreenController disposed');
    super.onClose();
  }
}
