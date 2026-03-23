import 'package:flutter/material.dart';
import '../data/admin_api_client.dart';
import '../models/admin_models.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  // 실제 운영 시 로그인 토큰을 주입하고 환경별 baseUrl을 분리하세요.
  final _api = AdminApiClient(
    baseUrl: 'http://localhost:3000',
    bearerToken: 'REPLACE_WITH_ADMIN_FIREBASE_ID_TOKEN',
  );

  final _userSearchController = TextEditingController();
  final _truckSearchController = TextEditingController();

  List<AdminUser> _users = [];
  List<AdminTruck> _trucks = [];
  List<AuditLogItem> _auditLogs = [];
  bool _loading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  @override
  void dispose() {
    _userSearchController.dispose();
    _truckSearchController.dispose();
    super.dispose();
  }

  Future<void> _loadAll() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    try {
      final users = await _api.getUsers(q: _userSearchController.text.trim());
      final trucks = await _api.getTrucks(q: _truckSearchController.text.trim());
      final logs = await _api.getAuditLogs();
      setState(() {
        _users = users;
        _trucks = trucks;
        _auditLogs = logs;
      });
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _changeUserRole(AdminUser user, String role) async {
    await _api.updateUserRole(userId: user.id, role: role);
    await _loadAll();
  }

  Future<void> _changeTruckStatus(AdminTruck truck, String status) async {
    await _api.updateTruckStatus(truckId: truck.id, status: status);
    await _loadAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WhereIsTruck Admin'),
        actions: [
          IconButton(onPressed: _loadAll, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : RefreshIndicator(
                  onRefresh: _loadAll,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildUsersCard(),
                      const SizedBox(height: 16),
                      _buildTrucksCard(),
                      const SizedBox(height: 16),
                      _buildAuditLogsCard(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildUsersCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('계정 관리', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            TextField(
              controller: _userSearchController,
              decoration: InputDecoration(
                hintText: '이름/이메일/UID 검색',
                suffixIcon: IconButton(
                  onPressed: _loadAll,
                  icon: const Icon(Icons.search),
                ),
              ),
              onSubmitted: (_) => _loadAll(),
            ),
            const SizedBox(height: 12),
            ..._users.map(
              (u) => ListTile(
                title: Text(u.displayName ?? '(이름 없음)'),
                subtitle: Text('${u.email ?? '-'} | ${u.firebaseUid}'),
                trailing: DropdownButton<String>(
                  value: u.role,
                  items: const [
                    DropdownMenuItem(value: 'user', child: Text('user')),
                    DropdownMenuItem(value: 'owner', child: Text('owner')),
                    DropdownMenuItem(value: 'admin', child: Text('admin')),
                  ],
                  onChanged: (value) {
                    if (value != null && value != u.role) {
                      _changeUserRole(u, value);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrucksCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('트럭 상태 관리', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            TextField(
              controller: _truckSearchController,
              decoration: InputDecoration(
                hintText: '트럭 이름 검색',
                suffixIcon: IconButton(
                  onPressed: _loadAll,
                  icon: const Icon(Icons.search),
                ),
              ),
              onSubmitted: (_) => _loadAll(),
            ),
            const SizedBox(height: 12),
            ..._trucks.map(
              (t) => ListTile(
                title: Text(t.name),
                subtitle: Text('owner_id=${t.ownerId}, status=${t.status}'),
                trailing: DropdownButton<String>(
                  value: t.status,
                  items: const [
                    DropdownMenuItem(value: 'open', child: Text('open')),
                    DropdownMenuItem(value: 'closed', child: Text('closed')),
                  ],
                  onChanged: (value) {
                    if (value != null && value != t.status) {
                      _changeTruckStatus(t, value);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuditLogsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('운영 감사 로그', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            ..._auditLogs.map(
              (log) => ListTile(
                dense: true,
                title: Text(log.action),
                subtitle: Text(
                  'actor=${log.actorUserId}, target=${log.targetType}:${log.targetId}',
                ),
                trailing: Text(
                  '${log.createdAt.month}/${log.createdAt.day} ${log.createdAt.hour}:${log.createdAt.minute.toString().padLeft(2, '0')}',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
