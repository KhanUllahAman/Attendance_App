// asset_complaint_model.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AssetComplaint {
  final int id;
  final int employeeId;
  final int? reviewedBy;
  final String requestType;
  final String category;
  final String assetType;
  final String reason;
  final String status;
  final DateTime requestedAt;
  final DateTime? reviewedAt;
  final String? resolutionRemarks;
  final bool isActive;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  AssetComplaint({
    required this.id,
    required this.employeeId,
    this.reviewedBy,
    required this.requestType,
    required this.category,
    required this.assetType,
    required this.reason,
    required this.status,
    required this.requestedAt,
    this.reviewedAt,
    this.resolutionRemarks,
    required this.isActive,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AssetComplaint.fromJson(Map<String, dynamic> json) {
    return AssetComplaint(
      id: json['id'] as int? ?? 0,
      employeeId: json['employee_id'] as int? ?? 0,
      reviewedBy: json['reviewed_by'] as int?,
      requestType: json['request_type'] as String? ?? 'new',
      category: json['category'] as String? ?? 'hardware',
      assetType: json['asset_type'] as String? ?? 'other',
      reason: json['reason'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      requestedAt: DateTime.parse(json['requested_at'] as String? ?? DateTime.now().toIso8601String()),
      reviewedAt: json['reviewed_at'] != null ? DateTime.parse(json['reviewed_at'] as String) : null,
      resolutionRemarks: json['resolution_remarks'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      isDeleted: json['is_deleted'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String? ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] as String? ?? DateTime.now().toIso8601String()),
    );
  }

  String get formattedRequestedAt => DateFormat('yyyy-MM-dd').format(requestedAt);
  String? get formattedReviewedAt => reviewedAt != null ? DateFormat('yyyy-MM-dd').format(reviewedAt!) : null;
  String get statusText {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'rejected':
        return 'Rejected';
      default:
        return 'Pending';
    }
  }
  Color get statusColor {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'in_progress':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}