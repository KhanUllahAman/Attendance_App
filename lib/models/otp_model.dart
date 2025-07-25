class OtpResponse {
  final int status;
  final String message;
  final List<OtpPayload> payload;

  OtpResponse({
    required this.status,
    required this.message,
    required this.payload,
  });

  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      payload: (json['payload'] as List<dynamic>?)
              ?.map((e) => OtpPayload.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class OtpPayload {
  final String token;
  final int id;
  final String username;
  final String email;
  final String passwordHash;
  final String type;
  final int employeeId;
  final DateTime? lastLogin;
  final String? passwordResetToken;
  final String otpToken;
  final DateTime? tokenExpiry;
  final bool isActive;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Employee employee;
  final List<dynamic> menus;

  OtpPayload({
    required this.token,
    required this.id,
    required this.username,
    required this.email,
    required this.passwordHash,
    required this.type,
    required this.employeeId,
    this.lastLogin,
    this.passwordResetToken,
    required this.otpToken,
    this.tokenExpiry,
    required this.isActive,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.employee,
    required this.menus,
  });

  factory OtpPayload.fromJson(Map<String, dynamic> json) {
    return OtpPayload(
      token: json['token'] ?? '',
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      passwordHash: json['password_hash'] ?? '',
      type: json['type'] ?? '',
      employeeId: json['employee_id'] ?? 0,
      lastLogin: json['last_login'] != null 
          ? DateTime.parse(json['last_login']) 
          : null,
      passwordResetToken: json['password_reset_token'],
      otpToken: json['otp_token'] ?? '',
      tokenExpiry: json['token_expiry'] != null 
          ? DateTime.parse(json['token_expiry']) 
          : null,
      isActive: json['is_active'] ?? false,
      isDeleted: json['is_deleted'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      employee: Employee.fromJson(json['employee'] ?? {}),
      menus: json['menus'] as List<dynamic>? ?? [],
    );
  }
}

class Employee {
  final int id;
  final String employeeCode;
  final String fullName;
  final String fatherName;
  final String email;
  final String phone;
  final String cnic;
  final String gender;
  final DateTime dob;
  final DateTime joinDate;
  final DateTime? leaveDate;
  final int departmentId;
  final int designationId;
  final String profilePicture;
  final String address;
  final String status;
  final bool isActive;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  Employee({
    required this.id,
    required this.employeeCode,
    required this.fullName,
    required this.fatherName,
    required this.email,
    required this.phone,
    required this.cnic,
    required this.gender,
    required this.dob,
    required this.joinDate,
    this.leaveDate,
    required this.departmentId,
    required this.designationId,
    required this.profilePicture,
    required this.address,
    required this.status,
    required this.isActive,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] ?? 0,
      employeeCode: json['employee_code'] ?? '',
      fullName: json['full_name'] ?? '',
      fatherName: json['father_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      cnic: json['cnic'] ?? '',
      gender: json['gender'] ?? '',
      dob: DateTime.parse(json['dob']),
      joinDate: DateTime.parse(json['join_date']),
      leaveDate: json['leave_date'] != null 
          ? DateTime.parse(json['leave_date']) 
          : null,
      departmentId: json['department_id'] ?? 0,
      designationId: json['designation_id'] ?? 0,
      profilePicture: json['profile_picture'] ?? 'default.png',
      address: json['address'] ?? '',
      status: json['status'] ?? '',
      isActive: json['is_active'] ?? false,
      isDeleted: json['is_deleted'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}