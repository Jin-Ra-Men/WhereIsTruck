import 'package:flutter/material.dart';

import '../../../core/config/api_base_url.dart';
import '../data/locations_api_client.dart';
import '../models/nearby_trucks_models.dart';
import 'kakao_map_view_stub.dart'
    if (dart.library.html) 'kakao_map_view_web.dart';
import '../../trucks/ui/truck_detail_page.dart';

class NearbyTrucksPage extends StatefulWidget {
  const NearbyTrucksPage({super.key});

  @override
  State<NearbyTrucksPage> createState() => _NearbyTrucksPageState();
}

class _NearbyTrucksPageState extends State<NearbyTrucksPage> {
  final _latController = TextEditingController(text: '37.5665');
  final _lngController = TextEditingController(text: '126.9780');
  final _radiusController = TextEditingController(text: '2');

  late final LocationsApiClient _api;

  bool _loading = false;
  String? _error;
  List<NearbyTruck> _trucks = [];
  double? _centerLat;
  double? _centerLng;

  @override
  void initState() {
    super.initState();
    _api = LocationsApiClient(baseUrl: ApiBaseUrl.value);
  }

  @override
  void dispose() {
    _latController.dispose();
    _lngController.dispose();
    _radiusController.dispose();
    super.dispose();
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _error = '현재 위치 기능은 다음 단계에서 붙입니다.');
  }

  Future<void> _loadNearby() async {
    final lat = double.tryParse(_latController.text.trim());
    final lng = double.tryParse(_lngController.text.trim());
    final radiusKm = double.tryParse(_radiusController.text.trim());
    if (lat == null || lng == null || radiusKm == null) {
      setState(() => _error = 'lat/lng/radius 값을 숫자로 입력해 주세요.');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
      _trucks = [];
      _centerLat = lat;
      _centerLng = lng;
    });

    try {
      final res = await _api.getNearby(
        lat: lat,
        lng: lng,
        radiusKm: radiusKm,
        limit: 50,
      );
      setState(() => _trucks = res.data);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final centerLat = _centerLat ?? double.tryParse(_latController.text) ?? 37.5665;
    final centerLng = _centerLng ?? double.tryParse(_lngController.text) ?? 126.9780;

    return Scaffold(
      appBar: AppBar(
        title: const Text('주변 트럭'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('검색 조건', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _latController,
                            decoration: const InputDecoration(
                              labelText: 'lat',
                              hintText: '37.5665',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _lngController,
                            decoration: const InputDecoration(
                              labelText: 'lng',
                              hintText: '126.9780',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _radiusController,
                            decoration: const InputDecoration(
                              labelText: 'radius_km',
                              hintText: '2',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _useCurrentLocation,
                          child: const Text('현재 위치'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _loading ? null : _loadNearby,
                          child: const Text('주변 트럭 조회'),
                        ),
                        const SizedBox(width: 12),
                        if (_error != null)
                          Expanded(
                            child: Text(
                              _error!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            KakaoMapView(
              centerLat: centerLat,
              centerLng: centerLng,
              trucks: _trucks,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('결과: ${_trucks.length}개'),
                    const SizedBox(height: 8),
                    if (_trucks.isEmpty)
                      const Text('아직 조회된 트럭이 없습니다.')
                    else
                      ..._trucks.map(
                        (t) => ListTile(
                          title: Text(t.truckName),
                          subtitle: Text(
                            '${t.status} | ${t.addressText ?? '-'}',
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => TruckDetailPage(
                                  truckId: t.truckId,
                                ),
                              ),
                            );
                          },
                          trailing: Text('${t.distanceM.toStringAsFixed(0)}m'),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

