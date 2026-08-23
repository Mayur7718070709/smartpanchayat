class AuthContext {
  const AuthContext({
    required this.userId,
    required this.appUserId,
    required this.role,
    required this.tenantId,
    required this.citizenId,
  });

  factory AuthContext.fromJson(Map<String, dynamic> json) => AuthContext(
    userId: json['user_id'] as String,
    appUserId: json['app_user_id'] as String,
    role: json['role'] as String,
    tenantId: json['tenant_id'] as String?,
    citizenId: json['citizen_id'] as String?,
  );

  final String userId;
  final String appUserId;
  final String role;
  final String? tenantId;
  final String? citizenId;

  bool get isReadyCitizen =>
      role == 'CITIZEN' && tenantId != null && citizenId != null;
}
