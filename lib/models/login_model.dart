class LoginResponse {
  final int status;
  final String message;
  final List<LoginPayload> payload;

  LoginResponse({
    required this.status,
    required this.message,
    required this.payload,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      payload:
          (json['payload'] as List<dynamic>?)
              ?.map((e) => LoginPayload.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class LoginPayload {
  final String username;

  LoginPayload({required this.username});

  factory LoginPayload.fromJson(Map<String, dynamic> json) {
    return LoginPayload(username: json['username'] ?? '');
  }
}
