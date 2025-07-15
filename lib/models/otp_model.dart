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
              ?.map((e) => OtpPayload.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class OtpPayload {
  final String username;
  final int userId;
  final int employeeId;
  final String employeeCode;
  final String token;

  OtpPayload({
    required this.username,
    required this.userId,
    required this.employeeId,
    required this.employeeCode,
    required this.token,
  });

  factory OtpPayload.fromJson(Map<String, dynamic> json) {
    return OtpPayload(
      username: json['username'] ?? '',
      userId: json['user_id'] ?? 0,
      employeeId: json['employee_id'] ?? 0,
      employeeCode: json['employee_code'] ?? '',
      token: json['token'] ?? '',
    );
  }
}