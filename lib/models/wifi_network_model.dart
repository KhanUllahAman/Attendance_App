// wifi_network_model.dart
class WifiNetwork {
  final int id;
  final String name;
  final String password;
  final String notes;
  final bool isActive;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  WifiNetwork({
    required this.id,
    required this.name,
    required this.password,
    required this.notes,
    required this.isActive,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WifiNetwork.fromJson(Map<String, dynamic> json) {
    return WifiNetwork(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      password: json['password'] ?? '',
      notes: json['notes'] ?? '',
      isActive: json['is_active'] ?? false,
      isDeleted: json['is_deleted'] ?? false,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}