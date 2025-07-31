import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:orioattendanceapp/Utils/Snack%20Bar/custom_snack_bar.dart';
import 'dart:developer' as developer;
import '../AuthServices/auth_service.dart';
import '../Network/Network Manager/network_manager.dart';
import '../Network/network.dart';
import '../Utils/AppWidget/App_widget.dart';
import '../Utils/Colors/color_resoursec.dart';
import '../Utils/Constant/api_url_constant.dart';
import '../models/home_model.dart';
import 'package:geolocator/geolocator.dart';

// class HomeScreenController extends NetworkManager {
//   final AuthService authService = AuthService();

//   final RxBool isLoading = true.obs;
//   final RxBool isLocationMatched = false.obs;
//   final Rx<HomeScreenResponse> homeScreenData = HomeScreenResponse().obs;
//   final RxString errorMessage = ''.obs;
//   final RxInt matchedOfficeId = 0.obs;
//   final RxString userName = ''.obs;
//   final RxString greeting = ''.obs;
//   final RxString currentTime = ''.obs;
//   final RxString currentDate = ''.obs;
//   Timer? timer;
//   final RxBool isProcessingCheckIn = false.obs;
//   final RxBool isProcessingCheckOut = false.obs;
//   final RxString currentButtonState = 'check_in'.obs;
//   DateTime? startDate;
//   DateTime? endDate;
//   final Rx<AttendanceSummary?> attendanceSummary = Rx<AttendanceSummary?>(null);
//   final RxBool isSummaryLoading = false.obs;
//   final RxString selectedDateRangeText = 'This Month'.obs;
//   final RxBool isLocationEnabled = false.obs;
//   bool _hasFetchedOfficeLocations = false;

//   @override
//   void onInit() async {
//     super.onInit();
//     await Future.wait([
//       fetchUserName(),
//       fetchHomeData(),
//       fetchAttendanceSummary(),
//     ]);
//     updateGreeting();
//     startTimeUpdates();
//     updateButtonState();
//     developer.log('HomeScreenController initialized');
//   }

//   Future<void> checkLocationServiceStatus() async {
//     try {
//       isLocationEnabled.value = await Geolocator.isLocationServiceEnabled();
//     } catch (e) {
//       isLocationEnabled.value = false;
//     }
//   }

//   void startTimeUpdates() {
//     updateTimeAndDate();
//     timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       updateTimeAndDate();
//     });
//     developer.log('Started time update timer');
//   }

//   void updateTimeAndDate() {
//     currentTime.value = DateFormat('hh:mm a').format(DateTime.now());
//     currentDate.value = DateFormat(
//       'MMMM dd, yyyy - EEEE',
//     ).format(DateTime.now());
//   }

//   Future<void> fetchUserName() async {
//     final username = await authService.getUsername();
//     userName.value = username ?? 'User';
//   }

//   void updateGreeting() {
//     final hour = DateTime.now().hour;
//     if (hour < 12) {
//       greeting.value = 'Good Morning';
//     } else if (hour < 17) {
//       greeting.value = 'Good Afternoon';
//     } else {
//       greeting.value = 'Good Evening';
//     }
//   }

//   void updateButtonState() {
//     if (homeScreenData.value.singleAttendance?.isNotEmpty == true) {
//       final attendance = homeScreenData.value.singleAttendance![0];
//       if (attendance.checkInTime != null) {
//         // Always show check-out button if checked in, regardless of check-out status
//         currentButtonState.value = 'check_out';
//       } else {
//         currentButtonState.value = 'check_in';
//       }
//     } else {
//       currentButtonState.value = 'check_in';
//     }
//   }

//   Future<String?> _getToken() async {
//     return await authService.getToken();
//   }

//   Future<int?> _getEmployeeId() async {
//     return await authService.getEmployeeId();
//   }

//   String getCurrentDate() {
//     return DateFormat('yyyy-MM-dd').format(DateTime.now());
//   }

//   String _getCurrentTime() {
//     return DateFormat('HH:mm:ss').format(DateTime.now());
//   }

//   Future<int?> _getMatchedOfficeId(List<OfficeLocation> officeLocations) async {
//     await checkLocationServiceStatus();
//     if (!isLocationEnabled.value) {
//       customSnackBar(
//         'Error',
//         'Location services are disabled. Please enable them.',
//         snackBarType: SnackBarType.error,
//       );
//       return null;
//     }
//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         customSnackBar(
//           'Error',
//           'Location services are disabled. Please enable them.',
//           snackBarType: SnackBarType.error,
//         );
//         return null;
//       }

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           customSnackBar(
//             'Error',
//             'Location permissions are denied.',
//             snackBarType: SnackBarType.error,
//           );
//           return null;
//         }
//       }

//       if (permission == LocationPermission.deniedForever) {
//         customSnackBar(
//           'Error',
//           'Location permissions are permanently denied. Please enable them in settings.',
//           snackBarType: SnackBarType.error,
//         );
//         return null;
//       }

//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       for (var office in officeLocations) {
//         double distance = Geolocator.distanceBetween(
//           double.parse(office.latitude),
//           double.parse(office.longitude),
//           position.latitude,
//           position.longitude,
//         );
//         if (distance <= office.radiusMeters) {
//           return office.id;
//         }
//       }

//       customSnackBar(
//         'Error',
//         'You are not within any office location range.',
//         snackBarType: SnackBarType.error,
//       );
//       return null;
//     } catch (e) {
//       developer.log('Location Error: $e');
//       customSnackBar(
//         'Error',
//         'Failed to fetch location. Please try again.',
//         snackBarType: SnackBarType.error,
//       );
//       return null;
//     }
//   }

//   Future<void> fetchHomeData() async {
//     isLoading.value = true;
//     isLocationMatched.value = false;

//     try {
//       final connectivityResult = await Connectivity().checkConnectivity();
//       if (connectivityResult == ConnectivityResult.none) {
//         errorMessage.value = 'No internet connection available';
//         isLoading.value = false;
//         return;
//       }

//       final token = await _getToken();
//       if (token == null) {
//         errorMessage.value = 'No token found. Please log in again.';
//         customSnackBar(
//           'Error',
//           'No token found. Please log in again.',
//           snackBarType: SnackBarType.error,
//         );
//         await authService.clearAuthData();
//         isLoading.value = false;
//         return;
//       }

//       final headers = {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       };

//       // Fetch office locations
//       final officeResponse = await Network.getApi(
//         getOfficeLocations,
//         headers: headers,
//       ).timeout(const Duration(seconds: 15));

//       if (officeResponse['status'] != 1) {
//         errorMessage.value =
//             officeResponse['message'] ?? 'Failed to fetch office locations';
//         isLoading.value = false;
//         return;
//       }

//       final officeLocations = (officeResponse['payload'] as List)
//           .map((e) => OfficeLocation.fromJson(e))
//           .toList();

//       homeScreenData.value = HomeScreenResponse(
//         officeLocations: officeLocations,
//       );

//       // Find matched office ID
//       final officeId = await _getMatchedOfficeId(officeLocations);
//       if (officeId == null) {
//         isLoading.value = false;
//         return;
//       }

//       matchedOfficeId.value = officeId;
//       isLocationMatched.value = true;

//       // Fetch single attendance
//       final employeeId = await _getEmployeeId();
//       if (employeeId == null) {
//         errorMessage.value = 'Employee ID not found.';
//         customSnackBar(
//           'Error',
//           'Employee ID not found.',
//           snackBarType: SnackBarType.error,
//         );
//         isLoading.value = false;
//         return;
//       }

//       final attendanceBody = {
//         'employee_id': employeeId,
//         'attendance_date': getCurrentDate(),
//       };

//       final attendanceResponse = await Network.postApi(
//         token,
//         getSingleAttendanceUrl,
//         attendanceBody,
//         headers,
//       ).timeout(const Duration(seconds: 15));

//       if (attendanceResponse['status'] == 1) {
//         homeScreenData.value = HomeScreenResponse(
//           officeLocations: homeScreenData.value.officeLocations,
//           singleAttendance: (attendanceResponse['payload'] as List)
//               .map((e) => Attendance.fromJson(e))
//               .toList(),
//         );
//       } else {
//         errorMessage.value =
//             attendanceResponse['message'] ?? 'Failed to fetch attendance data';
//       }
//     } on TimeoutException catch (_) {
//       errorMessage.value = 'Request timed out. Please try again.';
//     } on SocketException catch (_) {
//       errorMessage.value = 'No internet connection';
//     } catch (e) {
//       errorMessage.value = 'Failed to load data: ${e.toString()}';
//     } finally {
//       updateButtonState();
//       isLoading.value = false;
//     }
//   }

//   Future<void> checkIn() async {
//     if (connectionType.value == 0 || !isLocationMatched.value) {
//       customSnackBar(
//         'Error',
//         connectionType.value == 0
//             ? 'No internet connection available.'
//             : 'You are not within any office location range.',
//         snackBarType: SnackBarType.error,
//       );
//       return;
//     }

//     if (currentButtonState.value != 'check_in') {
//       customSnackBar(
//         'Info',
//         'You cannot check in at this time.',
//         snackBarType: SnackBarType.info,
//       );
//       return;
//     }

//     isProcessingCheckIn.value = true;
//     try {
//       final token = await _getToken();
//       final employeeId = await _getEmployeeId();
//       if (token == null || employeeId == null) {
//         errorMessage.value = 'Authentication error. Please log in again.';
//         customSnackBar(
//           'Error',
//           'Authentication error. Please log in again.',
//           snackBarType: SnackBarType.error,
//         );
//         await authService.clearAuthData();
//         return;
//       }

//       final checkInBody = {
//         'employee_id': employeeId,
//         'attendance_date': getCurrentDate(),
//         'check_in_time': _getCurrentTime(),
//         'check_in_office_location': matchedOfficeId.value,
//       };

//       final headers = {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       };

//       final checkInResponse = await Network.postApi(
//         token,
//         checkInUrl,
//         checkInBody,
//         headers,
//       );

//       if (checkInResponse['status'] == 1) {
//         customSnackBar(
//           'Success',
//           checkInResponse['message'],
//           snackBarType: SnackBarType.success,
//         );
//         await fetchHomeData();
//       } else {
//         errorMessage.value = checkInResponse['message'];
//         customSnackBar(
//           'Error',
//           checkInResponse['message'],
//           snackBarType: SnackBarType.error,
//         );
//       }
//     } catch (e) {
//       errorMessage.value = 'Failed to check in. Please try again.';
//       customSnackBar(
//         'Error',
//         'Failed to check in. Please try again.',
//         snackBarType: SnackBarType.error,
//       );
//       developer.log('Check In Error: $e');
//     } finally {
//       isProcessingCheckIn.value = false;
//     }
//   }

//   Future<void> checkOut() async {
//     if (connectionType.value == 0 || !isLocationMatched.value) {
//       customSnackBar(
//         'Error',
//         connectionType.value == 0
//             ? 'No internet connection available.'
//             : 'You are not within any office location range.',
//         snackBarType: SnackBarType.error,
//       );
//       return;
//     }

//     isProcessingCheckOut.value = true;
//     try {
//       final token = await _getToken();
//       final employeeId = await _getEmployeeId();
//       if (token == null || employeeId == null) {
//         errorMessage.value = 'Authentication error. Please log in again.';
//         customSnackBar(
//           'Error',
//           'Authentication error. Please log in again.',
//           snackBarType: SnackBarType.error,
//         );
//         await authService.clearAuthData();
//         return;
//       }

//       final checkOutBody = {
//         'employee_id': employeeId,
//         'attendance_date': getCurrentDate(),
//         'check_out_time': _getCurrentTime(),
//         'check_out_office_location': matchedOfficeId.value,
//       };

//       final headers = {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       };

//       final checkOutResponse = await Network.postApi(
//         token,
//         checkOutUrl,
//         checkOutBody,
//         headers,
//       );

//       if (checkOutResponse['status'] == 1) {
//         customSnackBar(
//           'Success',
//           checkOutResponse['message'],
//           snackBarType: SnackBarType.success,
//         );
//         await fetchHomeData();
//       } else {
//         errorMessage.value = checkOutResponse['message'];
//         customSnackBar(
//           'Error',
//           checkOutResponse['message'],
//           snackBarType: SnackBarType.error,
//         );
//       }
//     } catch (e) {
//       errorMessage.value = 'Failed to check out. Please try again.';
//       customSnackBar(
//         'Error',
//         'Failed to check out. Please try again.',
//         snackBarType: SnackBarType.error,
//       );
//       developer.log('Check Out Error: $e');
//     } finally {
//       isProcessingCheckOut.value = false;
//     }
//   }

//   // Button state methods
//   Color getButtonColor() {
//     if (!isLocationEnabled.value) return Colors.grey;
//     if (!isLocationMatched.value) return Colors.grey;
//     return currentButtonState.value == 'check_in'
//         ? ColorResources.appMainColor
//         : Colors.orange.shade700;
//   }

//   Color getGlowColor() {
//     if (!isLocationMatched.value) return Colors.grey.withOpacity(0.5);

//     return currentButtonState.value == 'check_in'
//         ? ColorResources.appMainColor.withOpacity(0.5)
//         : Colors.orange.shade700.withOpacity(0.5);
//   }

//   IconData getButtonIcon() {
//     return currentButtonState.value == 'check_in'
//         ? Iconsax.login
//         : Iconsax.logout;
//   }

//   String getButtonText() {
//     if (!isLocationEnabled.value) return 'Enable Location';
//     if (!isLocationMatched.value) return 'Not in Office';
//     return currentButtonState.value == 'check_in' ? 'Check In' : 'Check Out';
//   }

//   Future<void> fetchAttendanceSummary() async {
//     isSummaryLoading.value = true;

//     try {
//       final token = await _getToken();
//       final employeeId = await _getEmployeeId();

//       if (token == null || employeeId == null) {
//         errorMessage.value = 'Authentication error. Please log in again.';
//         return;
//       }
//       final now = DateTime.now();
//       final firstDayOfMonth = DateTime(now.year, now.month, 1);
//       final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
//       final body = {
//         // 'employee_id': employeeId,
//         'employee_id': 2,
//         'start_date':
//             startDate?.toIso8601String().split('T')[0] ??
//             DateFormat('yyyy-MM-dd').format(firstDayOfMonth),
//         'end_date':
//             endDate?.toIso8601String().split('T')[0] ??
//             DateFormat('yyyy-MM-dd').format(lastDayOfMonth),
//       };
//       final headers = {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       };
//       developer.log("This is Header ${headers.toString()}");
//       developer.log("This is Body ${body.toString()}");
//       final response = await Network.postApi(
//         null,
//         fetchAttendanceSummaryApi,
//         body,
//         headers,
//       );
//       developer.log("THis is Resposne ${response.toString()}");
//       if (response['status'] == 1) {
//         attendanceSummary.value = AttendanceSummary.fromJson(
//           response['payload'][0],
//         );
//       } else {
//         errorMessage.value =
//             response['message'] ?? 'Failed to fetch attendance summary';
//       }
//     } catch (e) {
//       errorMessage.value = 'Failed to load attendance summary: ${e.toString()}';
//     } finally {
//       isSummaryLoading.value = false;
//     }
//   }

//   void setDateRange(DateTime? start, DateTime? end) {
//     startDate = start;
//     endDate = end;
//     if (start != null && end != null) {
//       final diff = end.difference(start).inDays + 1;
//       selectedDateRangeText.value =
//           '${DateFormat('MMM d').format(start)} - ${DateFormat('MMM d, y').format(end)} ($diff days)';
//     } else {
//       selectedDateRangeText.value = 'This Month';
//     }
//     fetchAttendanceSummary();
//   }

//   void openDateRangePicker(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) => CustomDateRangePicker(
//         onDateRangeSelected: (start, end) {
//           setDateRange(start, end);
//         },
//       ),
//     );
//   }

//   @override
//   void onClose() {
//     timer?.cancel();
//     isLoading.value = true;
//     isLocationMatched.value = false;
//     homeScreenData.value = HomeScreenResponse();
//     matchedOfficeId.value = 0;
//     errorMessage.value = '';
//     isProcessingCheckIn.value = false;
//     isProcessingCheckOut.value = false;
//     developer.log('HomeScreenController disposed');
//     super.onClose();
//   }
// }

class HomeScreenController extends NetworkManager {
  final AuthService authService = AuthService();

  // State variables
  final RxBool isLoading = true.obs;
  final RxBool isLocationMatched = false.obs;
  final RxBool isLocationEnabled = false.obs;
  final Rx<HomeScreenResponse> homeScreenData = HomeScreenResponse().obs;
  final RxString errorMessage = ''.obs;
  final RxInt matchedOfficeId = 0.obs;
  final RxString userName = ''.obs;
  final RxString greeting = ''.obs;
  final RxString currentTime = ''.obs;
  final RxString currentDate = ''.obs;
  final RxString profileImageUrl = ''.obs;

  Timer? timer;
  final RxBool isProcessingCheckIn = false.obs;
  final RxBool isProcessingCheckOut = false.obs;
  final RxString currentButtonState = 'check_in'.obs;
  DateTime? startDate;
  DateTime? endDate;
  final Rx<AttendanceSummary?> attendanceSummary = Rx<AttendanceSummary?>(null);
  final RxBool isSummaryLoading = false.obs;
  final RxString selectedDateRangeText = 'This Month'.obs;
  bool _hasFetchedOfficeLocations = false;
  double? savedScrollPosition;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() async {
    super.onInit();
    savedScrollPosition = 0;
    await Future.wait([
      fetchUserName(),
      fetchProfileImage(),
      fetchHomeData(),
      fetchAttendanceSummary(),
    ]);
    updateGreeting();
    startTimeUpdates();
    updateButtonState();

    Geolocator.getServiceStatusStream().listen((status) {
      isLocationEnabled.value = status == ServiceStatus.enabled;
    });
  }

  void startTimeUpdates() {
    updateTimeAndDate();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      updateTimeAndDate();
    });
  }

  void updateTimeAndDate() {
    currentTime.value = DateFormat('hh:mm a').format(DateTime.now());
    currentDate.value = DateFormat(
      'MMMM dd, yyyy - EEEE',
    ).format(DateTime.now());
  }

  Future<void> fetchProfileImage() async {
    final imageName = await authService.getProfileImage();
    if (imageName != null && imageName.isNotEmpty) {
      profileImageUrl.value =
          'http://162.211.84.202:3001/uploads/users/$imageName';
    } else {
      profileImageUrl.value = '';
    }
  }

  Future<void> fetchUserName() async {
    final username = await authService.getFullName();
    if (username != null) {
      final firstWord = username.contains(' ')
          ? username.split(' ').first
          : username;
      userName.value = firstWord.length > 8
          ? '${firstWord.substring(0, 8)}...'
          : username.contains(' ')
          ? '$firstWord...'
          : firstWord;
    } else {
      userName.value = 'User';
    }
  }

  void updateGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      greeting.value = 'Good Morning';
    } else if (hour < 17) {
      greeting.value = 'Good Afternoon';
    } else {
      greeting.value = 'Good Evening';
    }
  }

  void updateButtonState() {
    if (homeScreenData.value.singleAttendance?.isNotEmpty == true) {
      final attendance = homeScreenData.value.singleAttendance[0];
      if (attendance.checkInTime != null) {
        currentButtonState.value = 'check_out';
      } else {
        currentButtonState.value = 'check_in';
      }
    } else {
      currentButtonState.value = 'check_in';
    }
  }

  Future<String?> _getToken() async {
    return await authService.getToken();
  }

  Future<int?> _getEmployeeId() async {
    return await authService.getEmployeeId();
  }

  String getCurrentDate() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  String _getCurrentTime() {
    return DateFormat('HH:mm:ss').format(DateTime.now());
  }

  Future<void> checkLocationServiceStatus() async {
    try {
      isLocationEnabled.value = await Geolocator.isLocationServiceEnabled();
    } catch (e) {
      isLocationEnabled.value = false;
    }
  }

  Future<int?> _getMatchedOfficeId(List<OfficeLocation> officeLocations) async {
    await checkLocationServiceStatus();
    if (!isLocationEnabled.value) {
      return null;
    }

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      for (var office in officeLocations) {
        double distance = Geolocator.distanceBetween(
          double.parse(office.latitude),
          double.parse(office.longitude),
          position.latitude,
          position.longitude,
        );
        if (distance <= office.radiusMeters) {
          return office.id;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> _quickLocationCheck() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        timeLimit: const Duration(seconds: 3),
      );

      for (var office in homeScreenData.value.officeLocations ?? []) {
        double distance = Geolocator.distanceBetween(
          double.parse(office.latitude),
          double.parse(office.longitude),
          position.latitude,
          position.longitude,
        );
        if (distance <= office.radiusMeters) {
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> fetchHomeData() async {
    isLoading.value = true;
    isLocationMatched.value = false;

    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        errorMessage.value = 'No internet connection available';
        isLoading.value = false;
        return;
      }

      final token = await _getToken();
      if (token == null) {
        errorMessage.value = 'No token found. Please log in again.';
        await authService.clearAuthData();
        isLoading.value = false;
        return;
      }

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      if (!_hasFetchedOfficeLocations) {
        final officeResponse = await Network.getApi(
          getOfficeLocations,
          headers: headers,
        ).timeout(const Duration(seconds: 15));

        if (officeResponse['status'] != 1) {
          errorMessage.value =
              officeResponse['message'] ?? 'Failed to fetch office locations';
          isLoading.value = false;
          return;
        }

        final officeLocations = (officeResponse['payload'] as List)
            .map((e) => OfficeLocation.fromJson(e))
            .toList();

        homeScreenData.value = HomeScreenResponse(
          officeLocations: officeLocations,
        );
        _hasFetchedOfficeLocations = true;
      }

      final officeId = await _getMatchedOfficeId(
        homeScreenData.value.officeLocations,
      );
      if (officeId == null) {
        isLoading.value = false;
        return;
      }

      matchedOfficeId.value = officeId;
      isLocationMatched.value = true;

      final employeeId = await _getEmployeeId();
      if (employeeId == null) {
        errorMessage.value = 'Employee ID not found.';
        isLoading.value = false;
        return;
      }

      final attendanceBody = {
        'employee_id': employeeId,
        'attendance_date': getCurrentDate(),
      };

      final attendanceResponse = await Network.postApi(
        token,
        getSingleAttendanceUrl,
        attendanceBody,
        headers,
      ).timeout(const Duration(seconds: 15));

      if (attendanceResponse['status'] == 1) {
        homeScreenData.value = HomeScreenResponse(
          officeLocations: homeScreenData.value.officeLocations,
          singleAttendance: (attendanceResponse['payload'] as List)
              .map((e) => Attendance.fromJson(e))
              .toList(),
        );
      } else {
        errorMessage.value =
            attendanceResponse['message'] ?? 'Failed to fetch attendance data';
      }
    } on TimeoutException catch (_) {
      errorMessage.value = 'Request timed out. Please try again.';
    } on SocketException catch (_) {
      errorMessage.value = 'No internet connection';
    } catch (e) {
      errorMessage.value = 'Failed to load data: ${e.toString()}';
    } finally {
      updateButtonState();
      isLoading.value = false;
    }
  }

  Future<void> checkIn() async {
    if (connectionType.value == 0) {
      customSnackBar(
        'Error',
        'No internet connection available.',
        snackBarType: SnackBarType.error,
      );
      return;
    }

    if (!isLocationEnabled.value) {
      customSnackBar(
        'Error',
        'Location services are disabled. Please enable them.',
        snackBarType: SnackBarType.error,
      );
      return;
    }

    if (!isLocationMatched.value) {
      final quickCheck = await _quickLocationCheck();
      if (!quickCheck) {
        customSnackBar(
          'Error',
          'You are not within any office location range.',
          snackBarType: SnackBarType.error,
        );
        return;
      }
    }

    if (currentButtonState.value != 'check_in') {
      customSnackBar(
        'Info',
        'You cannot check in at this time.',
        snackBarType: SnackBarType.info,
      );
      return;
    }

    isProcessingCheckIn.value = true;
    try {
      final token = await _getToken();
      final employeeId = await _getEmployeeId();
      if (token == null || employeeId == null) {
        errorMessage.value = 'Authentication error. Please log in again.';
        await authService.clearAuthData();
        return;
      }

      final checkInBody = {
        'employee_id': employeeId,
        'attendance_date': getCurrentDate(),
        'check_in_time': _getCurrentTime(),
        'check_in_office_location': matchedOfficeId.value,
      };

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final checkInResponse = await Network.postApi(
        token,
        checkInUrl,
        checkInBody,
        headers,
      );

      if (checkInResponse['status'] == 1) {
        // customSnackBar(
        //   'Success',
        //   checkInResponse['message'],
        //   snackBarType: SnackBarType.success,
        // );
        await fetchHomeData();
      } else {
        errorMessage.value = checkInResponse['message'];
        customSnackBar(
          'Error',
          checkInResponse['message'],
          snackBarType: SnackBarType.error,
        );
      }
    } catch (e) {
      errorMessage.value = 'Failed to check in. Please try again.';
    } finally {
      isProcessingCheckIn.value = false;
    }
  }

  Future<void> checkOut() async {
    if (connectionType.value == 0) {
      customSnackBar(
        'Error',
        'No internet connection available.',
        snackBarType: SnackBarType.error,
      );
      return;
    }

    if (!isLocationEnabled.value) {
      customSnackBar(
        'Error',
        'Location services are disabled. Please enable them.',
        snackBarType: SnackBarType.error,
      );
      return;
    }

    isProcessingCheckOut.value = true;
    try {
      final token = await _getToken();
      final employeeId = await _getEmployeeId();
      if (token == null || employeeId == null) {
        errorMessage.value = 'Authentication error. Please log in again.';
        await authService.clearAuthData();
        return;
      }

      final checkOutBody = {
        'employee_id': employeeId,
        'attendance_date': getCurrentDate(),
        'check_out_time': _getCurrentTime(),
        'check_out_office_location': matchedOfficeId.value,
      };

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final checkOutResponse = await Network.postApi(
        token,
        checkOutUrl,
        checkOutBody,
        headers,
      );

      if (checkOutResponse['status'] == 1) {
        // customSnackBar(
        //   'Success',
        //   checkOutResponse['message'],
        //   snackBarType: SnackBarType.success,
        // );
        await fetchHomeData();
      } else {
        errorMessage.value = checkOutResponse['message'];
        customSnackBar(
          'Error',
          checkOutResponse['message'],
          snackBarType: SnackBarType.error,
        );
      }
    } catch (e) {
      errorMessage.value = 'Failed to check out. Please try again.';
    } finally {
      isProcessingCheckOut.value = false;
    }
  }

  Color getButtonColor() {
    if (!isLocationEnabled.value) return Colors.grey;
    if (!isLocationMatched.value) return Colors.grey;
    return currentButtonState.value == 'check_in'
        ? ColorResources.appMainColor
        : Color.fromARGB(255, 245, 80, 69);
  }

  Color getGlowColor() {
    if (!isLocationEnabled.value) return Colors.grey.withOpacity(0.5);
    if (!isLocationMatched.value) return Colors.grey.withOpacity(0.5);
    return currentButtonState.value == 'check_in'
        ? ColorResources.appMainColor.withOpacity(0.5)
        : Color.fromARGB(255, 245, 80, 69).withOpacity(0.5);
  }

  IconData getButtonIcon() {
    return currentButtonState.value == 'check_in'
        ? Iconsax.login
        : Iconsax.logout;
  }

  String getButtonText() {
    if (!isLocationEnabled.value) return 'Enable Location';
    if (!isLocationMatched.value) return 'Not in Office';
    return currentButtonState.value == 'check_in' ? 'Check In' : 'Check Out';
  }

  Future<void> fetchAttendanceSummary() async {
    isSummaryLoading.value = true;
    try {
      final token = await _getToken();
      final employeeId = await _getEmployeeId();
      if (token == null || employeeId == null) {
        errorMessage.value = 'Authentication error. Please log in again.';
        return;
      }

      final now = DateTime.now();
      final firstDayOfMonth = DateTime(now.year, now.month, 1);
      final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

      final body = {
        'employee_id': employeeId,
        'start_date':
            startDate?.toIso8601String().split('T')[0] ??
            DateFormat('yyyy-MM-dd').format(firstDayOfMonth),
        'end_date':
            endDate?.toIso8601String().split('T')[0] ??
            DateFormat('yyyy-MM-dd').format(lastDayOfMonth),
      };

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await Network.postApi(
        null,
        fetchAttendanceSummaryApi,
        body,
        headers,
      );

      if (response['status'] == 1) {
        attendanceSummary.value = AttendanceSummary.fromJson(
          response['payload'][0],
        );
      } else {
        errorMessage.value =
            response['message'] ?? 'Failed to fetch attendance summary';
      }
    } catch (e) {
      errorMessage.value = 'Failed to load attendance summary: ${e.toString()}';
    } finally {
      isSummaryLoading.value = false;
    }
  }

  void setDateRange(DateTime? start, DateTime? end) {
    startDate = start;
    endDate = end;
    if (start != null && end != null) {
      final diff = end.difference(start).inDays + 1;
      selectedDateRangeText.value =
          '${DateFormat('MMM d').format(start)} - ${DateFormat('MMM d, y').format(end)} ($diff days)';
    } else {
      selectedDateRangeText.value = 'This Month';
    }
    fetchAttendanceSummary();
  }

  void openDateRangePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CustomDateRangePicker(
        onDateRangeSelected: (start, end) {
          setDateRange(start, end);
        },
      ),
    );
  }

  @override
  void onClose() {
    timer?.cancel();
    Geolocator.getServiceStatusStream().drain();
    super.onClose();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}

////// AUTO REFRESH WORK ////
////////////////////////////

// import 'dart:async';
// import 'dart:io';

// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:intl/intl.dart';
// import 'package:orioattendanceapp/Utils/Snack%20Bar/custom_snack_bar.dart';
// import 'dart:developer' as developer;
// import '../AuthServices/auth_service.dart';
// import '../Network/Network Manager/network_manager.dart';
// import '../Network/network.dart';
// import '../Utils/Colors/color_resoursec.dart';
// import '../Utils/Constant/api_url_constant.dart';
// import '../models/home_model.dart';
// import 'package:geolocator/geolocator.dart';

// class HomeScreenController extends NetworkManager with WidgetsBindingObserver {
//   final AuthService authService = AuthService();

//   final RxBool isLoading = true.obs;
//   final RxBool isLocationMatched = false.obs;
//   final Rx<HomeScreenResponse> homeScreenData = HomeScreenResponse().obs;
//   final RxString errorMessage = ''.obs;
//   final RxInt matchedOfficeId = 0.obs;
//   final RxString userName = ''.obs;
//   final RxString greeting = ''.obs;
//   final RxString currentTime = ''.obs;
//   final RxString currentDate = ''.obs;
//   Timer? timer;
//   Timer? refreshTimer;
//   final RxBool isProcessingCheckIn = false.obs;
//   final RxBool isProcessingCheckOut = false.obs;
//   final RxString currentButtonState = 'check_in'.obs;

//   @override
//   void onInit() async {
//     super.onInit();
//     WidgetsBinding.instance.addObserver(this);
//     await Future.wait([fetchUserName(), fetchHomeData()]);
//     updateGreeting();
//     startTimeUpdates();
//     updateButtonState();
//     startAutoRefresh();
//     developer.log('HomeScreenController initialized');
//   }

//   void startAutoRefresh() {
//     refreshTimer?.cancel();
//     refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
//       if (!isLoading.value && !isLocationMatched.value) {
//         // Only refresh if not loading AND not in office location
//         fetchHomeData();
//       }
//     });
//   }

//   void startTimeUpdates() {
//     updateTimeAndDate();
//     timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       updateTimeAndDate();
//     });
//     developer.log('Started time update timer');
//   }

//   void updateTimeAndDate() {
//     currentTime.value = DateFormat('hh:mm a').format(DateTime.now());
//     currentDate.value = DateFormat(
//       'MMMM dd, yyyy - EEEE',
//     ).format(DateTime.now());
//   }

//   Future<void> fetchUserName() async {
//     final username = await authService.getUsername();
//     userName.value = username ?? 'User';
//   }

//   void updateGreeting() {
//     final hour = DateTime.now().hour;
//     if (hour < 12) {
//       greeting.value = 'Good Morning';
//     } else if (hour < 17) {
//       greeting.value = 'Good Afternoon';
//     } else {
//       greeting.value = 'Good Evening';
//     }
//   }

//   void updateButtonState() {
//     if (homeScreenData.value.singleAttendance?.isNotEmpty == true) {
//       final attendance = homeScreenData.value.singleAttendance![0];
//       if (attendance.checkInTime != null) {
//         currentButtonState.value = 'check_out';
//       } else {
//         currentButtonState.value = 'check_in';
//       }
//     } else {
//       currentButtonState.value = 'check_in';
//     }
//   }

//   Future<String?> _getToken() async {
//     return await authService.getToken();
//   }

//   Future<int?> _getEmployeeId() async {
//     return await authService.getEmployeeId();
//   }

//   String getCurrentDate() {
//     return DateFormat('yyyy-MM-dd').format(DateTime.now());
//   }

//   String _getCurrentTime() {
//     return DateFormat('HH:mm:ss').format(DateTime.now());
//   }

//   Future<int?> _getMatchedOfficeId(List<OfficeLocation> officeLocations) async {
//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         customSnackBar(
//           'Error',
//           'Location services are disabled. Please enable them.',
//           snackBarType: SnackBarType.error,
//         );
//         return null;
//       }

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           customSnackBar(
//             'Error',
//             'Location permissions are denied.',
//             snackBarType: SnackBarType.error,
//           );
//           return null;
//         }
//       }

//       if (permission == LocationPermission.deniedForever) {
//         customSnackBar(
//           'Error',
//           'Location permissions are permanently denied. Please enable them in settings.',
//           snackBarType: SnackBarType.error,
//         );
//         return null;
//       }

//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       for (var office in officeLocations) {
//         double distance = Geolocator.distanceBetween(
//           double.parse(office.latitude),
//           double.parse(office.longitude),
//           position.latitude,
//           position.longitude,
//         );
//         if (distance <= office.radiusMeters) {
//           return office.id;
//         }
//       }

//       customSnackBar(
//         'Error',
//         'You are not within any office location range.',
//         snackBarType: SnackBarType.error,
//       );
//       return null;
//     } catch (e) {
//       developer.log('Location Error: $e');
//       customSnackBar(
//         'Error',
//         'Failed to fetch location. Please try again.',
//         snackBarType: SnackBarType.error,
//       );
//       return null;
//     }
//   }

//   Future<void> fetchHomeData() async {
//     isLoading.value = true;
//     isLocationMatched.value = false;

//     try {
//       final connectivityResult = await Connectivity().checkConnectivity();
//       if (connectivityResult == ConnectivityResult.none) {
//         errorMessage.value = 'No internet connection available';
//         isLoading.value = false;
//         return;
//       }

//       final token = await _getToken();
//       if (token == null) {
//         errorMessage.value = 'No token found. Please log in again.';
//         customSnackBar(
//           'Error',
//           'No token found. Please log in again.',
//           snackBarType: SnackBarType.error,
//         );
//         await authService.clearAuthData();
//         isLoading.value = false;
//         return;
//       }

//       final headers = {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       };

//       final officeResponse = await Network.getApi(
//         getOfficeLocations,
//         headers: headers,
//       ).timeout(const Duration(seconds: 15));

//       if (officeResponse['status'] != 1) {
//         errorMessage.value =
//             officeResponse['message'] ?? 'Failed to fetch office locations';
//         isLoading.value = false;
//         return;
//       }

//       final officeLocations = (officeResponse['payload'] as List)
//           .map((e) => OfficeLocation.fromJson(e))
//           .toList();

//       homeScreenData.value = HomeScreenResponse(
//         officeLocations: officeLocations,
//       );

//       final officeId = await _getMatchedOfficeId(officeLocations);
//       if (officeId == null) {
//         isLoading.value = false;
//         if (!isLocationMatched.value) {
//           startAutoRefresh();
//         }
//         return;
//       }

//       matchedOfficeId.value = officeId;
//       isLocationMatched.value = true;

//       refreshTimer?.cancel();

//       final employeeId = await _getEmployeeId();
//       if (employeeId == null) {
//         errorMessage.value = 'Employee ID not found.';
//         customSnackBar(
//           'Error',
//           'Employee ID not found.',
//           snackBarType: SnackBarType.error,
//         );
//         isLoading.value = false;
//         return;
//       }

//       final attendanceBody = {
//         'employee_id': employeeId,
//         'attendance_date': getCurrentDate(),
//       };

//       final attendanceResponse = await Network.postApi(
//         token,
//         getSingleAttendanceUrl,
//         attendanceBody,
//         headers,
//       ).timeout(const Duration(seconds: 15));

//       if (attendanceResponse['status'] == 1) {
//         homeScreenData.value = HomeScreenResponse(
//           officeLocations: homeScreenData.value.officeLocations,
//           singleAttendance: (attendanceResponse['payload'] as List)
//               .map((e) => Attendance.fromJson(e))
//               .toList(),
//         );
//       } else {
//         errorMessage.value =
//             attendanceResponse['message'] ?? 'Failed to fetch attendance data';
//       }
//     } on TimeoutException catch (_) {
//       errorMessage.value = 'Request timed out. Please try again.';
//     } on SocketException catch (_) {
//       errorMessage.value = 'No internet connection';
//     } catch (e) {
//       errorMessage.value = 'Failed to load data: ${e.toString()}';
//     } finally {
//       updateButtonState();
//       isLoading.value = false;

//       if (!isLocationMatched.value &&
//           (refreshTimer == null || !refreshTimer!.isActive)) {
//         startAutoRefresh();
//       }
//     }
//   }

//   Future<void> checkIn() async {
//     if (connectionType.value == 0 || !isLocationMatched.value) {
//       customSnackBar(
//         'Error',
//         connectionType.value == 0
//             ? 'No internet connection available.'
//             : 'You are not within any office location range.',
//         snackBarType: SnackBarType.error,
//       );
//       return;
//     }

//     if (currentButtonState.value != 'check_in') {
//       customSnackBar(
//         'Info',
//         'You cannot check in at this time.',
//         snackBarType: SnackBarType.info,
//       );
//       return;
//     }

//     isProcessingCheckIn.value = true;
//     try {
//       final token = await _getToken();
//       final employeeId = await _getEmployeeId();
//       if (token == null || employeeId == null) {
//         errorMessage.value = 'Authentication error. Please log in again.';
//         customSnackBar(
//           'Error',
//           'Authentication error. Please log in again.',
//           snackBarType: SnackBarType.error,
//         );
//         await authService.clearAuthData();
//         return;
//       }

//       final checkInBody = {
//         'employee_id': employeeId,
//         'attendance_date': getCurrentDate(),
//         'check_in_time': _getCurrentTime(),
//         'check_in_office_location': matchedOfficeId.value,
//       };

//       final headers = {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       };

//       final checkInResponse = await Network.postApi(
//         token,
//         checkInUrl,
//         checkInBody,
//         headers,
//       );

//       if (checkInResponse['status'] == 1) {
//         customSnackBar(
//           'Success',
//           checkInResponse['message'],
//           snackBarType: SnackBarType.success,
//         );
//         await fetchHomeData();
//       } else {
//         errorMessage.value = checkInResponse['message'];
//         customSnackBar(
//           'Error',
//           checkInResponse['message'],
//           snackBarType: SnackBarType.error,
//         );
//       }
//     } catch (e) {
//       errorMessage.value = 'Failed to check in. Please try again.';
//       customSnackBar(
//         'Error',
//         'Failed to check in. Please try again.',
//         snackBarType: SnackBarType.error,
//       );
//       developer.log('Check In Error: $e');
//     } finally {
//       isProcessingCheckIn.value = false;
//     }
//   }

//   Future<void> checkOut() async {
//     if (connectionType.value == 0 || !isLocationMatched.value) {
//       customSnackBar(
//         'Error',
//         connectionType.value == 0
//             ? 'No internet connection available.'
//             : 'You are not within any office location range.',
//         snackBarType: SnackBarType.error,
//       );
//       return;
//     }

//     isProcessingCheckOut.value = true;
//     try {
//       final token = await _getToken();
//       final employeeId = await _getEmployeeId();
//       if (token == null || employeeId == null) {
//         errorMessage.value = 'Authentication error. Please log in again.';
//         customSnackBar(
//           'Error',
//           'Authentication error. Please log in again.',
//           snackBarType: SnackBarType.error,
//         );
//         await authService.clearAuthData();
//         return;
//       }

//       final checkOutBody = {
//         'employee_id': employeeId,
//         'attendance_date': getCurrentDate(),
//         'check_out_time': _getCurrentTime(),
//         'check_out_office_location': matchedOfficeId.value,
//       };

//       final headers = {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       };

//       final checkOutResponse = await Network.postApi(
//         token,
//         checkOutUrl,
//         checkOutBody,
//         headers,
//       );

//       if (checkOutResponse['status'] == 1) {
//         customSnackBar(
//           'Success',
//           checkOutResponse['message'],
//           snackBarType: SnackBarType.success,
//         );
//         await fetchHomeData();
//       } else {
//         errorMessage.value = checkOutResponse['message'];
//         customSnackBar(
//           'Error',
//           checkOutResponse['message'],
//           snackBarType: SnackBarType.error,
//         );
//       }
//     } catch (e) {
//       errorMessage.value = 'Failed to check out. Please try again.';
//       customSnackBar(
//         'Error',
//         'Failed to check out. Please try again.',
//         snackBarType: SnackBarType.error,
//       );
//       developer.log('Check Out Error: $e');
//     } finally {
//       isProcessingCheckOut.value = false;
//     }
//   }

//   // Button state methods
//   Color getButtonColor() {
//     if (!isLocationMatched.value) return Colors.grey;

//     return currentButtonState.value == 'check_in'
//         ? ColorResources.appMainColor
//         : Colors.orange.shade700;
//   }

//   Color getGlowColor() {
//     if (!isLocationMatched.value) return Colors.grey.withOpacity(0.5);

//     return currentButtonState.value == 'check_in'
//         ? ColorResources.appMainColor.withOpacity(0.5)
//         : Colors.orange.shade700.withOpacity(0.5);
//   }

//   IconData getButtonIcon() {
//     return currentButtonState.value == 'check_in'
//         ? Iconsax.login
//         : Iconsax.logout;
//   }

//   String getButtonText() {
//     if (!isLocationMatched.value) return 'Not in Office';

//     return currentButtonState.value == 'check_in' ? 'Check In' : 'Check Out';
//   }

//   @override
//   void onClose() {
//     WidgetsBinding.instance.removeObserver(this);
//     timer?.cancel();
//     refreshTimer?.cancel();
//     isLoading.value = true;
//     isLocationMatched.value = false;
//     homeScreenData.value = HomeScreenResponse();
//     matchedOfficeId.value = 0;
//     errorMessage.value = '';
//     isProcessingCheckIn.value = false;
//     isProcessingCheckOut.value = false;
//     developer.log('HomeScreenController disposed');
//     super.onClose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.paused) {
//       refreshTimer?.cancel();
//     } else if (state == AppLifecycleState.resumed) {
//       if (!isLocationMatched.value) {
//         startAutoRefresh();
//       }
//     }
//   }
// }
