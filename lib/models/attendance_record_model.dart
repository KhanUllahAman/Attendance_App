import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceRecord {
  final int id;
  final String employeeCode;
  final String fullName;
  final DateTime date;
  final String? checkInTime;
  final String? checkOutTime;
  final String? checkInStatus;
  final String? checkOutStatus;
  final String? daystatus;
  final String? workHours;
  final String? checkInOffice;
  final String? checkOutOffice;

  AttendanceRecord({
    required this.id,
    required this.employeeCode,
    required this.fullName,
    required this.date,
    this.checkInTime,
    this.checkOutTime,
    this.checkInStatus,
    this.checkOutStatus,
    this.daystatus,
    this.workHours,
    this.checkInOffice,
    this.checkOutOffice,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['employee_id'] ?? 0,
      employeeCode: json['employee_code'] ?? '',
      fullName: json['full_name'] ?? '',
      date: DateTime.parse(json['date']),
      checkInTime: json['check_in_time'],
      checkOutTime: json['check_out_time'],
      checkInStatus: json['check_in_status'],
      checkOutStatus: json['check_out_status'],
      daystatus: json['day_status'],
      workHours: json['work_hours'],
      checkInOffice: json['check_in_office'],
      checkOutOffice: json['check_out_office'],
    );
  }

  String get formattedDate => DateFormat('EEEE, MMMM d, y').format(date);
  String get shortDate => DateFormat('MMM d').format(date);

  static Map<String, Color> dayStatusColor = {
    'present': Colors.green,
    'absent': Colors.red,
    'leave': Colors.orange,
    'weekend': Colors.blue,
    'holiday': Colors.purple,
    'work_from_home': Colors.indigo
  };

  // Color mappings for statuses
  static Map<String, Color> checkInStatusColors = {
    'on_time': Colors.green,
    'late': Colors.orange,
    'absent': Colors.red,
    'manual': Colors.blue,
  };

  static Map<String, Color> checkOutStatusColors = {
    'on_time': Colors.green,
    'early_leave': Colors.orange,
    'early_go': Colors.red,
    'overtime': Colors.blue,
    'manual': Colors.purple,
    'half_day': Colors.amber,
  };

  static Map<String, String> dayStatusLabels = {
    'present': 'Present',
    'absent': 'Absent',
    'leave': 'Leave',
    'weekend': 'Weekend',
    'holiday': 'Holiday',
    'work_from_home': 'Work From Home'
  };

  static Map<String, String> checkInStatusLabels = {
    'on_time': 'On Time',
    'late': 'Late',
    'absent': 'Absent',
    'manual': 'Manual',
  };

  static Map<String, String> checkOutStatusLabels = {
    'on_time': 'On Time',
    'early_leave': 'Early Leave',
    'early_go': 'Early Go',
    'overtime': 'Overtime',
    'manual': 'Manual',
    'half_day': 'Half Day',
  };

  String get dayStatusLabel {
  return dayStatusLabels[daystatus?.toLowerCase() ?? 'absent'] ??
      (checkInTime != null && checkOutTime != null 
          ? 'Present' 
          : checkInTime != null 
              ? 'Half Day' 
              : 'Absent');
}

Color get dayStatusColorValue {
  return dayStatusColor[daystatus?.toLowerCase()] ??
      (checkInTime != null && checkOutTime != null
          ? Colors.green
          : checkInTime != null
              ? Colors.orange
              : Colors.red);
}
}
