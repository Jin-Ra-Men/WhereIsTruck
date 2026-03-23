class NearbyTruck {
  NearbyTruck({
    required this.truckId,
    required this.truckName,
    required this.status,
    required this.distanceM,
    required this.lat,
    required this.lng,
    this.addressText,
  });

  final int truckId;
  final String truckName;
  final String status; // open | closed
  final String? addressText;
  final double lat;
  final double lng;
  final num distanceM;

  factory NearbyTruck.fromJson(Map<String, dynamic> json) {
    return NearbyTruck(
      truckId: (json['truck_id'] as num).toInt(),
      truckName: json['truck_name'] as String? ?? '',
      status: json['status'] as String? ?? 'closed',
      addressText: json['address_text'] as String?,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      distanceM: (json['distance_m'] as num),
    );
  }
}

class NearbyTrucksResponse {
  NearbyTrucksResponse({
    required this.data,
    required this.total,
  });

  final List<NearbyTruck> data;
  final int total;

  factory NearbyTrucksResponse.fromJson(Map<String, dynamic> json) {
    return NearbyTrucksResponse(
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => NearbyTruck.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt() ?? 0,
    );
  }
}

