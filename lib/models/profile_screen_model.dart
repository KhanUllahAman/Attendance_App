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
      employeeId: int.tryParse(json['employee_id']?.toString() ?? '0') ?? 0,
      employeeCode: json['employee_code']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      fatherName: json['father_name']?.toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      cnic: json['cnic']?.toString(),
      gender: json['gender']?.toString(),
      dob: json['dob']?.toString(),
      joinDate: json['join_date']?.toString(),
      profilePicture: json['profile_picture']?.toString(),
      address: json['address']?.toString(),
      departmentName: json['department_name']?.toString(),
      designationTitle: json['designation_title']?.toString(),
      shiftName: json['shift_name']?.toString(),
      shiftStartTime: json['shift_start_time']?.toString(),
      shiftEndTime: json['shift_end_time']?.toString(),
      teamNames: json['team_names']?.toString(),
      teamLeads: json['team_leads']?.toString(),
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
