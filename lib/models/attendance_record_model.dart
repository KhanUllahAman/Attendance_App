import 'package:intl/intl.dart';

class AttendanceRecord {
  final int id;
  final String employeeCode;
  final String fullName;
  final DateTime date;
  final String? checkInTime;
  final String? checkOutTime;
  final String? workHours;

  AttendanceRecord({
    required this.id,
    required this.employeeCode,
    required this.fullName,
    required this.date,
    this.checkInTime,
    this.checkOutTime,
    this.workHours,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'] ?? 0,
      employeeCode: json['employee_code'] ?? '',
      fullName: json['full_name'] ?? '',
      date: DateTime.parse(json['date']),
      checkInTime: json['check_in_time'],
      checkOutTime: json['check_out_time'],
      workHours: json['work_hours'],
    );
  }

  String get formattedDate => DateFormat('EEEE, MMMM d, y').format(date);
  String get shortDate => DateFormat('MMM d').format(date);
  String get status {
    if (checkInTime != null && checkOutTime != null) return 'Present';
    if (checkInTime != null) return 'Half Day';
    return 'Absent';
  }
}