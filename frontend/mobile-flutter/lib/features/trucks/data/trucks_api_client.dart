import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/config/api_base_url.dart';
import '../models/truck_models.dart';

class TrucksApiClient {
  TrucksApiClient({
    http.Client? httpClient,
    String? baseUrl,
  })  : _httpClient = httpClient ?? http.Client(),
        _baseUrl = baseUrl ?? ApiBaseUrl.value;

  final http.Client _httpClient;
  final String _baseUrl;

  Future<TruckDetail> getTruckDetail(int truckId) async {
    final uri = Uri.parse('$_baseUrl/trucks/$truckId');
    final res = await _httpClient.get(uri);
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('트럭 상세 조회 실패: ${res.statusCode} ${res.body}');
    }

    final json = jsonDecode(res.body) as Map<String, dynamic>;
    return TruckDetail.fromJson(json);
  }
}

