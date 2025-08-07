import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationModel {
  final int id;
  final int? userId;
  final String title;
  final String message;
  final String type;
  final String priority;
  final String status;
  final bool broadcast;
  final DateTime sentAt;
  final bool isActive;
  final bool isDeleted;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.priority,
    required this.status,
    required this.broadcast,
    required this.sentAt,
    required this.isActive,
    required this.isDeleted,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      message: json['message'],
      type: json['type'],
      priority: json['priority'],
      status: json['status'],
      broadcast: json['broadcast'],
      sentAt: DateTime.parse(json['sent_at']),
      isActive: json['is_active'],
      isDeleted: json['is_deleted'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  String get formattedSentAt {
    try {
      final sentAtDateUtc = DateTime.parse(sentAt.toString());
      final sentAtDatePst = sentAtDateUtc.toLocal();
      return DateFormat('dd-MM-yyyy hh:mm a').format(sentAtDatePst);
    } catch (e) {
      return 'Date not available';
    }
  }

  Color get priorityColor {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'unread':
        return Colors.red;
      case 'read':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
