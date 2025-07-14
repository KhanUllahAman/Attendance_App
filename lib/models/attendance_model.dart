import 'package:flutter/material.dart';

class AttendanceModel {
  final String formattedDate;
  final List<String> dayStatuses;
  final String checkInTime;
  final String checkOutTime;
  final String workHours;
  final String? officeLocation;
  final String? leaveType;
  final String? holidayTitle;
  final String? holidayDescription;
  final String? checkInStatus;
  final String? checkOutStatus;

  AttendanceModel({
    required this.formattedDate,
    required this.dayStatuses,
    required this.checkInTime,
    required this.checkOutTime,
    required this.workHours,
    this.officeLocation,
    this.leaveType,
    this.holidayTitle,
    this.holidayDescription,
    this.checkInStatus,
    this.checkOutStatus,
  });
}

List<AttendanceModel> dummyAttendanceList = [
  AttendanceModel(
    formattedDate: "12 July 2025 (Saturday)",
    dayStatuses: ["leave"],
    leaveType: "Sick",
    checkInTime: "--",
    checkOutTime: "--",
    workHours: "--",
    checkInStatus: "manual",
    checkOutStatus: "--",
  ),
  AttendanceModel(
    formattedDate: "13 July 2025 (Sunday)",
    dayStatuses: ["weekend", "holiday"],
    holidayTitle: "Eid ul Adha",
    holidayDescription: "Religious holiday observed nationwide.",
    checkInTime: "--",
    checkOutTime: "--",
    workHours: "--",
  ),
  AttendanceModel(
    formattedDate: "14 July 2025 (Monday)",
    dayStatuses: ["present"],
    checkInTime: "10:00",
    checkOutTime: "6:00",
    workHours: "8 Hours",
    checkInStatus: "late",
    checkOutStatus: "on_time",
    officeLocation: "Main Office",
  ),
];

class AttendanceColorHelper {
  static Color getDayStatusColor(String status) {
    switch (status) {
      case 'present': return Colors.green;
      case 'late_arrival': return Colors.orange;
      case 'early_leave': return Colors.redAccent;
      case 'half_day': return Colors.amber;
      case 'absent': return Colors.red;
      case 'leave': return Colors.blue;
      case 'weekend': return Colors.grey;
      case 'holiday': return Colors.purple;
      default: return Colors.white70;
    }
  }

  static String getDayStatusLabel(String status) {
    switch (status) {
      case 'present': return 'Present';
      case 'late_arrival': return 'Late Arrival';
      case 'early_leave': return 'Early Leave';
      case 'half_day': return 'Half Day';
      case 'absent': return 'Absent';
      case 'leave': return 'Leave';
      case 'weekend': return 'Weekend';
      case 'holiday': return 'Holiday';
      default: return status;
    }
  }
}

class CheckStatusHelper {
  static Color getColor(String status) {
    switch (status) {
      case 'on_time': return Colors.green;
      case 'late': return Colors.orange;
      case 'early_leave': return Colors.redAccent;
      case 'missing': return Colors.grey;
      case 'manual': return Colors.blue;
      case 'overtime': return Colors.teal;
      case 'half_day': return Colors.amber;
      default: return Colors.white70;
    }
  }

  static String getLabel(String status) {
    switch (status) {
      case 'on_time': return 'On Time';
      case 'late': return 'Late';
      case 'early_leave': return 'Early Leave';
      case 'missing': return 'Missing';
      case 'manual': return 'Manual';
      case 'overtime': return 'Overtime';
      case 'half_day': return 'Half Day';
      default: return status;
    }
  }
}

