import 'package:flutter/material.dart';

import '../models/nearby_trucks_models.dart';

class KakaoMapView extends StatelessWidget {
  const KakaoMapView({
    super.key,
    required this.centerLat,
    required this.centerLng,
    required this.trucks,
  });

  final double centerLat;
  final double centerLng;
  final List<NearbyTruck> trucks;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.map_outlined, size: 40),
              const SizedBox(height: 12),
              const Text(
                '모바일에서는 지도 연동이 아직 준비 중입니다.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                '현재 조회 결과: ${trucks.length}개',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

