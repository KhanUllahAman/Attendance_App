class OfficeLocation {
  final int id;
  final String name;
  final String latitude;
  final String longitude;
  final int radiusMeters;
  final String address;
  final bool isActive;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;

  OfficeLocation({
    this.id = 0,
    this.name = '',
    this.latitude = '',
    this.longitude = '',
    this.radiusMeters = 0,
    this.address = '',
    this.isActive = false,
    this.isDeleted = false,
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory OfficeLocation.fromJson(Map<String, dynamic>? json) {
    json ??= {}; // Handle null JSON
    return OfficeLocation(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      latitude: json['latitude'] as String? ?? '',
      longitude: json['longitude'] as String? ?? '',
      radiusMeters: json['radius_meters'] as int? ?? 0,
      address: json['address'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? false,
      isDeleted: json['is_deleted'] as bool? ?? false,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }
}


class Attendance {
  final int id;
  final int employeeId;
  final String date;
  final String? checkInTime;
  final int? checkInOfficeId;
  final String? checkOutTime;
  final String? checkOutDeviceId;
  final int? checkOutOfficeId;
  final String? workHours;
  final String? checkInStatus;
  final String? checkOutStatus;
  final String? dayStatus;
  final int? verifiedBy;
  final bool isActive;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;

  Attendance({
    this.id = 0,
    this.employeeId = 0,
    this.date = '',
    this.checkInTime,
    this.checkInOfficeId,
    this.checkOutTime,
    this.checkOutDeviceId,
    this.checkOutOfficeId,
    this.workHours,
    this.checkInStatus,
    this.checkOutStatus,
    this.dayStatus,
    this.verifiedBy,
    this.isActive = false,
    this.isDeleted = false,
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory Attendance.fromJson(Map<String, dynamic>? json) {
    json ??= {}; // Handle null JSON
    return Attendance(
      id: json['id'] as int? ?? 0,
      employeeId: json['employee_id'] as int? ?? 0,
      date: json['date'] as String? ?? '',
      checkInTime: json['check_in_time'] as String?,
      checkInOfficeId: json['check_in_office_id'] as int?,
      checkOutTime: json['check_out_time'] as String?,
      checkOutDeviceId: json['check_out_device_id'] as String?,
      checkOutOfficeId: json['check_out_office_id'] as int?,
      workHours: json['work_hours'] as String?,
      checkInStatus: json['check_in_status'] as String?,
      checkOutStatus: json['check_out_status'] as String?,
      dayStatus: json['day_status'] as String?,
      verifiedBy: json['verified_by'] as int?,
      isActive: json['is_active'] as bool? ?? false,
      isDeleted: json['is_deleted'] as bool? ?? false,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }
}


class HomeScreenResponse {
  final List<OfficeLocation> officeLocations;
  final List<Attendance> singleAttendance;
  final List<Attendance> checkInResponse;
  final List<Attendance> checkOutResponse;

  HomeScreenResponse({
    this.officeLocations = const [],
    this.singleAttendance = const [],
    this.checkInResponse = const [],
    this.checkOutResponse = const [],
  });

  factory HomeScreenResponse.fromJson(Map<String, dynamic>? json) {
    json ??= {}; // Handle null JSON
    return HomeScreenResponse(
      officeLocations: (json['office_locations'] as List<dynamic>?)?.map((e) => OfficeLocation.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      singleAttendance: (json['single_attendance'] as List<dynamic>?)?.map((e) => Attendance.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      checkInResponse: (json['check_in_response'] as List<dynamic>?)?.map((e) => Attendance.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      checkOutResponse: (json['check_out_response'] as List<dynamic>?)?.map((e) => Attendance.fromJson(e as Map<String, dynamic>)).toList() ?? [],
    );
  }
}

///Summery Attendance //

class AttendanceSummary {
  final int employeeId;
  final String totalDays;
  final String workingDays;
  final String presentDays;
  final String absentDays;
  final String leaveDays;
  final String weekendDays;
  final String holidayDays;
  final String manualPresentDays;
  final String workFromHomeDays;
  final String lateCheckIns;
  final String halfDayCheckOuts;
  final String earlyLeaveCheckOuts;

  AttendanceSummary({
    required this.employeeId,
    required this.totalDays,
    required this.workingDays,
    required this.presentDays,
    required this.absentDays,
    required this.leaveDays,
    required this.weekendDays,
    required this.holidayDays,
    required this.manualPresentDays,
    required this.workFromHomeDays,
    required this.lateCheckIns,
    required this.halfDayCheckOuts,
    required this.earlyLeaveCheckOuts,
  });

  factory AttendanceSummary.fromJson(Map<String, dynamic> json) {
    return AttendanceSummary(
      employeeId: json['employee_id'] ?? 0,
      totalDays: json['total_days'] ?? '0',
      workingDays: json['working_days'] ?? '0',
      presentDays: json['present_days'] ?? '0',
      absentDays: json['absent_days'] ?? '0',
      leaveDays: json['leave_days'] ?? '0',
      weekendDays: json['weekend_days'] ?? '0',
      holidayDays: json['holiday_days'] ?? '0',
      manualPresentDays: json['manual_present_days'] ?? '0',
      workFromHomeDays: json['work_from_home_days'] ?? '0',
      lateCheckIns: json['late_check_ins'] ?? '0',
      halfDayCheckOuts: json['half_day_check_outs'] ?? '0',
      earlyLeaveCheckOuts: json['early_leave_check_outs'] ?? '0',
    );
  }
}