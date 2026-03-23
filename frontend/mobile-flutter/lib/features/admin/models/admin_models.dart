class AdminUser {
  AdminUser({
    required this.id,
    required this.firebaseUid,
    required this.role,
    this.displayName,
    this.email,
  });

  final int id;
  final String firebaseUid;
  final String role;
  final String? displayName;
  final String? email;

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['id'] as int,
      firebaseUid: json['firebase_uid'] as String? ?? '',
      role: json['role'] as String? ?? 'user',
      displayName: json['display_name'] as String?,
      email: json['email'] as String?,
    );
  }
}

class AdminTruck {
  AdminTruck({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.status,
  });

  final int id;
  final int ownerId;
  final String name;
  final String status;

  factory AdminTruck.fromJson(Map<String, dynamic> json) {
    return AdminTruck(
      id: json['id'] as int,
      ownerId: json['owner_id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      status: json['status'] as String? ?? 'closed',
    );
  }
}

class AuditLogItem {
  AuditLogItem({
    required this.id,
    required this.actorUserId,
    required this.action,
    required this.targetType,
    required this.targetId,
    required this.createdAt,
  });

  final int id;
  final int actorUserId;
  final String action;
  final String targetType;
  final int targetId;
  final DateTime createdAt;

  factory AuditLogItem.fromJson(Map<String, dynamic> json) {
    return AuditLogItem(
      id: json['id'] as int,
      actorUserId: json['actor_user_id'] as int? ?? 0,
      action: json['action'] as String? ?? '',
      targetType: json['target_type'] as String? ?? '',
      targetId: json['target_id'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
