import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LeaveHistory {
  final int leaveId;  // Changed from 'id' to 'leave_id' to match response
  final int employeeId;
  final int leaveTypeId;
  final String leaveTypeName;  // Added this new field from response
  final String startDate;
  final String endDate;
  final int totalDays;
  final String reason;
  final String status;  // Note: response has 'STATUS' in uppercase
  final String appliedOn;
  final int? approvedBy;
  final String? approvedOn;
  final String? remarks;
  final bool isActive;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;

  LeaveHistory({
    required this.leaveId,
    required this.employeeId,
    required this.leaveTypeId,
    required this.leaveTypeName,
    required this.startDate,
    required this.endDate,
    required this.totalDays,
    required this.reason,
    required this.status,
    required this.appliedOn,
    this.approvedBy,
    this.approvedOn,
    this.remarks,
    required this.isActive,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LeaveHistory.fromJson(Map<String, dynamic> json) {
    return LeaveHistory(
      leaveId: json['leave_id'] ?? 0,  // Changed from 'id' to 'leave_id'
      employeeId: json['employee_id'] ?? 0,
      leaveTypeId: json['leave_type_id'] ?? 0,
      leaveTypeName: json['leave_type_name'] ?? '',  // Added this new field
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      totalDays: json['total_days'] ?? 0,
      reason: json['reason'] ?? '',
      status: json['STATUS']?.toLowerCase() ?? 'pending',  // Note uppercase in response
      appliedOn: json['applied_on'] ?? '',
      approvedBy: json['approved_by'],
      approvedOn: json['approved_on'],
      remarks: json['remarks'],
      isActive: (json['is_active'] ?? 0) == 1,  // Convert int to bool
      isDeleted: (json['is_deleted'] ?? 0) == 1,  // Convert int to bool
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  // Rest of your methods remain the same...
  String get formattedDateRange {
    final start = DateTime.parse(startDate);
    final end = DateTime.parse(endDate);
    return '${DateFormat('MMM d').format(start)} - ${DateFormat('MMM d, y').format(end)} ($totalDays ${totalDays > 1 ? 'Days' : 'Day'})';
  }

  String get formattedAppliedOn {
    try {
      final appliedOnDate = DateTime.parse(appliedOn);
      return '${DateFormat('MMM d, y').format(appliedOnDate)} at ${DateFormat('h:mm a').format(appliedOnDate)}';
    } catch (e) {
      return 'Date not available';
    }
  }

  String get formattedApprovedOn {
    try {
      final appliedOnDate = DateTime.parse(approvedOn.toString());
      return '${DateFormat('MMM d, y').format(appliedOnDate)} at ${DateFormat('h:mm a').format(appliedOnDate)}';
    } catch (e) {
      return 'Date not available';
    }
  }

  String get formattedApprovedBy {
    try {
      final appliedbyDate = DateTime.parse(approvedBy.toString());
      return '${DateFormat('MMM d, y').format(appliedbyDate)} at ${DateFormat('h:mm a').format(appliedbyDate)}';
    } catch (e) {
      return 'Date not available';
    }
  }

  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.greenAccent;
      case 'rejected':
        return Colors.redAccent;
      default:
        return Colors.orangeAccent;
    }
  }

  String get statusText {
    return status[0].toUpperCase() + status.substring(1);
  }
}

// Leave Summary Model
class LeaveSummary {
  final String leaveType;
  final int usedDays;
  final int totalQuota;
  final int remaining;

  LeaveSummary({
    required this.leaveType,
    required this.usedDays,
    required this.totalQuota,
    required this.remaining,
  });

  factory LeaveSummary.fromJson(Map<String, dynamic> json) {
    return LeaveSummary(
      leaveType: json['leave_type'] ?? '',
      usedDays: json['used_days'] ?? 0,
      totalQuota: json['total_quota'] ?? 0,
      remaining: json['remaining'] ?? 0,
    );
  }

  Color get primaryColor {
    switch (leaveType.toLowerCase()) {
      case 'sick':
        return Colors.red.shade700;
      case 'casual':
        return Colors.orange.shade700;
      case 'annual':
        return Colors.teal.shade700;
      default:
        return Colors.blue.shade700;
    }
  }

  Color get secondaryColor {
    switch (leaveType.toLowerCase()) {
      case 'sick':
        return Colors.red.shade100;
      case 'casual':
        return Colors.orange.shade100;
      case 'annual':
        return Colors.teal.shade100;
      default:
        return Colors.blue.shade100;
    }
  }
}
