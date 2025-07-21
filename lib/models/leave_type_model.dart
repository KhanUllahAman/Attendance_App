class LeaveType {
  final int id;
  final String name;
  final int totalQuota;

  LeaveType({
    required this.id,
    required this.name,
    required this.totalQuota,
  });

  factory LeaveType.fromJson(Map<String, dynamic> json) {
    return LeaveType(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      totalQuota: json['total_quota'] ?? 0,
    );
  }
}