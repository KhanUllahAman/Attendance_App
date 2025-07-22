// attendance_correction_model.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AttendanceCorrection {
  final int id;
  final int employeeId;
  final DateTime attendanceDate;
  final String requestType;
  final String? originalCheckIn;
  final String? originalCheckOut;
  final String? requestedCheckIn;
  final String? requestedCheckOut;
  final String reason;
  final String status;
  final int? reviewedBy;
  final DateTime? reviewedOn;
  final String? remarks;
  final bool isActive;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  AttendanceCorrection({
    required this.id,
    required this.employeeId,
    required this.attendanceDate,
    required this.requestType,
    this.originalCheckIn,
    this.originalCheckOut,
    this.requestedCheckIn,
    this.requestedCheckOut,
    required this.reason,
    required this.status,
    this.reviewedBy,
    this.reviewedOn,
    this.remarks,
    required this.isActive,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AttendanceCorrection.fromJson(Map<String, dynamic> json) {
    return AttendanceCorrection(
      id: json['id'] as int? ?? 0,
      employeeId: json['employee_id'] as int? ?? 0,
      attendanceDate: DateTime.parse(
        json['attendance_date'] as String? ?? DateTime.now().toIso8601String(),
      ),
      requestType: json['request_type'] as String? ?? '',
      originalCheckIn: json['original_check_in'] as String?,
      originalCheckOut: json['original_check_out'] as String?,
      requestedCheckIn: json['requested_check_in'] as String?,
      requestedCheckOut: json['requested_check_out'] as String?,
      reason: json['reason'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      reviewedBy: json['reviewed_by'] as int?,
      reviewedOn: json['reviewed_on'] != null
          ? DateTime.parse(json['reviewed_on'] as String)
          : null,
      remarks: json['remarks'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      isDeleted: json['is_deleted'] as bool? ?? false,
      createdAt: DateTime.parse(
        json['created_at'] as String? ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] as String? ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  // Helper methods for formatted dates
  String get formattedAttendanceDate =>
      DateFormat('yyyy-MM-dd').format(attendanceDate);
  String? get formattedReviewedOn => reviewedOn != null
      ? DateFormat('yyyy-MM-dd HH:mm').format(reviewedOn!)
      : null;
  String get formattedCreatedAt =>
      DateFormat('yyyy-MM-dd HH:mm').format(createdAt);

  // Status display properties
  String get statusText {
    switch (status.toLowerCase()) {
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      case 'pending':
        return 'Pending';
      default:
        return status;
    }
  }

  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  // Request type display
  String get requestTypeDisplay {
    switch (requestType) {
      case 'missed_check_in':
        return 'Missed Check-In';
      case 'missed_check_out':
        return 'Missed Check-Out';
      case 'wrong_time':
        return 'Wrong Time';
      default:
        return requestType.replaceAll('_', ' ').capitalizeFirst ?? requestType;
    }
  }
}
