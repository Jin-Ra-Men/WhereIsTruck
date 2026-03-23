import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/config/api_base_url.dart';
import '../models/nearby_trucks_models.dart';

class LocationsApiClient {
  LocationsApiClient({
    http.Client? httpClient,
    String? baseUrl,
  })  : _httpClient = httpClient ?? http.Client(),
        _baseUrl = baseUrl ?? ApiBaseUrl.value;

  final http.Client _httpClient;
  final String _baseUrl;

  Future<NearbyTrucksResponse> getNearby({
    required double lat,
    required double lng,
    double radiusKm = 2,
    int limit = 20,
  }) async {
    final uri = Uri.parse('$_baseUrl/locations/nearby').replace(
      queryParameters: {
        'lat': lat.toString(),
        'lng': lng.toString(),
        'radius_km': radiusKm.toString(),
        'limit': limit.toString(),
      },
    );

    final res = await _httpClient.get(uri);
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('주변 트럭 조회 실패: ${res.statusCode} ${res.body}');
    }

    return NearbyTrucksResponse.fromJson(
      jsonDecode(res.body) as Map<String, dynamic>,
    );
  }
}

