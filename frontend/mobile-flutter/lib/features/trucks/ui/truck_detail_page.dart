import 'package:flutter/material.dart';

import '../../../core/config/api_base_url.dart';
import '../data/trucks_api_client.dart';
import '../models/truck_models.dart';

class TruckDetailPage extends StatefulWidget {
  const TruckDetailPage({
    super.key,
    required this.truckId,
  });

  final int truckId;

  @override
  State<TruckDetailPage> createState() => _TruckDetailPageState();
}

class _TruckDetailPageState extends State<TruckDetailPage> {
  late final TrucksApiClient _api;

  bool _loading = false;
  String? _error;
  TruckDetail? _detail;

  @override
  void initState() {
    super.initState();
    _api = TrucksApiClient(baseUrl: ApiBaseUrl.value);
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final detail = await _api.getTruckDetail(widget.truckId);
      setState(() => _detail = detail);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('트럭 상세 (#${widget.truckId})'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                )
              : _detail == null
                  ? const Center(child: Text('데이터 없음'))
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        if (_detail!.coverImageUrl != null &&
                            _detail!.coverImageUrl!.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              _detail!.coverImageUrl!,
                              height: 160,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const SizedBox(
                                height: 160,
                                child: Center(child: Text('이미지 로드 실패')),
                              ),
                            ),
                          ),
                        const SizedBox(height: 12),
                        Text(
                          _detail!.name,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '상태: ${_detail!.status}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 16),
                        if (_detail!.description != null &&
                            _detail!.description!.isNotEmpty)
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('소개', style: TextStyle(fontSize: 16)),
                                  const SizedBox(height: 8),
                                  Text(_detail!.description!),
                                ],
                              ),
                            ),
                          ),
                        if (_detail!.menuSummary != null &&
                            _detail!.menuSummary!.isNotEmpty)
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('메뉴', style: TextStyle(fontSize: 16)),
                                  const SizedBox(height: 8),
                                  Text(_detail!.menuSummary!),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
      floatingActionButton: _error != null
          ? FloatingActionButton(
              onPressed: _load,
              child: const Icon(Icons.refresh),
            )
          : null,
    );
  }
}

