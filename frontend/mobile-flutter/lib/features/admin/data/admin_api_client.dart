import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/admin_models.dart';

class AdminApiClient {
  AdminApiClient({
    required this.baseUrl,
    required this.bearerToken,
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  final String baseUrl;
  final String bearerToken;
  final http.Client _httpClient;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $bearerToken',
      };

  Future<List<AdminUser>> getUsers({String? role, String? q}) async {
    final uri = Uri.parse('$baseUrl/admin/users').replace(
      queryParameters: {
        if (role != null && role.isNotEmpty) 'role': role,
        if (q != null && q.isNotEmpty) 'q': q,
      },
    );
    final response = await _httpClient.get(uri, headers: _headers);
    _ensureSuccess(response);
    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((item) => AdminUser.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<AdminUser> updateUserRole({
    required int userId,
    required String role,
  }) async {
    final uri = Uri.parse('$baseUrl/admin/users/$userId/role');
    final response = await _httpClient.patch(
      uri,
      headers: _headers,
      body: jsonEncode({'role': role}),
    );
    _ensureSuccess(response);
    return AdminUser.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<List<AdminTruck>> getTrucks({String? status, String? q}) async {
    final uri = Uri.parse('$baseUrl/admin/trucks').replace(
      queryParameters: {
        if (status != null && status.isNotEmpty) 'status': status,
        if (q != null && q.isNotEmpty) 'q': q,
      },
    );
    final response = await _httpClient.get(uri, headers: _headers);
    _ensureSuccess(response);
    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((item) => AdminTruck.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<AdminTruck> updateTruckStatus({
    required int truckId,
    required String status,
  }) async {
    final uri = Uri.parse('$baseUrl/admin/trucks/$truckId/status');
    final response = await _httpClient.patch(
      uri,
      headers: _headers,
      body: jsonEncode({'status': status}),
    );
    _ensureSuccess(response);
    return AdminTruck.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<List<AuditLogItem>> getAuditLogs() async {
    final uri = Uri.parse('$baseUrl/admin/audit-logs');
    final response = await _httpClient.get(uri, headers: _headers);
    _ensureSuccess(response);
    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((item) => AuditLogItem.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  void _ensureSuccess(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        '관리자 API 요청 실패: ${response.statusCode} ${response.body}',
      );
    }
  }
}
