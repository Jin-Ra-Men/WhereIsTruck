class TruckDetail {
  TruckDetail({
    required this.id,
    required this.ownerId,
    required this.name,
    this.description,
    required this.status,
    this.menuSummary,
    this.coverImageUrl,
    this.createdAt,
  });

  final int id;
  final int ownerId;
  final String name;
  final String? description;
  final String status; // open | closed
  final String? menuSummary;
  final String? coverImageUrl;
  final DateTime? createdAt;

  factory TruckDetail.fromJson(Map<String, dynamic> json) {
    return TruckDetail(
      id: json['id'] as int,
      ownerId: json['owner_id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      status: json['status'] as String? ?? 'closed',
      menuSummary: json['menu_summary'] as String?,
      coverImageUrl: json['cover_image_url'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }
}

