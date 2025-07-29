// Model for FCM token response
class FcmTokenResponse {
  final int status;
  final String message;
  final List<FcmTokenPayload> payload;

  FcmTokenResponse({
    required this.status,
    required this.message,
    required this.payload,
  });

  factory FcmTokenResponse.fromJson(Map<String, dynamic> json) {
    return FcmTokenResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      payload:
          (json['payload'] as List<dynamic>?)
              ?.map((e) => FcmTokenPayload.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class FcmTokenPayload {
  final int id;
  final String token;
  final int userId;
  final bool isActive;
  final String createdAt;

  FcmTokenPayload({
    required this.id,
    required this.token,
    required this.userId,
    required this.isActive,
    required this.createdAt,
  });

  factory FcmTokenPayload.fromJson(Map<String, dynamic> json) {
    return FcmTokenPayload(
      id: json['id'] ?? 0,
      token: json['token'] ?? '',
      userId: json['user_id'] ?? 0,
      isActive: json['is_active'] ?? false,
      createdAt: json['created_at'] ?? '',
    );
  }
}
