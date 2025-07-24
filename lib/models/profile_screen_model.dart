import 'package:intl/intl.dart';

class EmployeeProfile {
  final int employeeId;
  final String employeeCode;
  final String fullName;
  final String? fatherName;
  final String? email;
  final String? phone;
  final String? cnic;
  final String? gender;
  final String? dob;
  final String? joinDate;
  final String? profilePicture;
  final String? address;
  final String? departmentName;
  final String? designationTitle;
  final String? shiftName;
  final String? shiftStartTime;
  final String? shiftEndTime;
  final String? teamNames;
  final String? teamLeads;

  EmployeeProfile({
    required this.employeeId,
    required this.employeeCode,
    required this.fullName,
    this.fatherName,
    this.email,
    this.phone,
    this.cnic,
    this.gender,
    this.dob,
    this.joinDate,
    this.profilePicture,
    this.address,
    this.departmentName,
    this.designationTitle,
    this.shiftName,
    this.shiftStartTime,
    this.shiftEndTime,
    this.teamNames,
    this.teamLeads,
  });

  factory EmployeeProfile.fromJson(Map<String, dynamic> json) {
    return EmployeeProfile(
      employeeId: json['employee_id'] ?? 0,
      employeeCode: json['employee_code'] ?? '',
      fullName: json['full_name'] ?? '',
      fatherName: json['father_name'],
      email: json['email'],
      phone: json['phone'],
      cnic: json['cnic'],
      gender: json['gender'],
      dob: json['dob'],
      joinDate: json['join_date'],
      profilePicture: json['profile_picture'],
      address: json['address'],
      departmentName: json['department_name'],
      designationTitle: json['designation_title'],
      shiftName: json['shift_name'],
      shiftStartTime: json['shift_start_time'],
      shiftEndTime: json['shift_end_time'],
      teamNames: json['team_names'],
      teamLeads: json['team_leads'],
    );
  }

  String get formattedJoinDate {
    if (joinDate == null) return '--';
    final date = DateTime.tryParse(joinDate!);
    return date != null ? DateFormat('MMM d, y').format(date) : '--';
  }

  String get formattedShiftTime {
    if (shiftStartTime == null || shiftEndTime == null) return '--';
    return '${_formatTime(shiftStartTime!)} - ${_formatTime(shiftEndTime!)}';
  }

  String _formatTime(String time) {
    try {
      final parts = time.split(':');
      final hour = int.parse(parts[0]);
      final minute = parts[1];
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:$minute $period';
    } catch (e) {
      return time;
    }
  }
}