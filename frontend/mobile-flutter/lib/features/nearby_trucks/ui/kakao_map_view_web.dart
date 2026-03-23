// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/material.dart';

import '../../../core/config/map_api_keys.dart';
import '../models/nearby_trucks_models.dart';

class KakaoMapView extends StatefulWidget {
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
  State<KakaoMapView> createState() => _KakaoMapViewState();
}

class _KakaoMapViewState extends State<KakaoMapView> {
  static const _viewContainerId = 'whereistruck-kakao-map-container';

  static const _scriptId = 'whereistruck-kakao-map-sdk';
  static const _scriptUrlBase =
      'https://dapi.kakao.com/v2/maps/sdk.js?appkey=';

  final GlobalKey _rootKey = GlobalKey();

  bool _loadingSdk = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _renderMarkers();
  }

  @override
  void didUpdateWidget(covariant KakaoMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.centerLat != widget.centerLat ||
        oldWidget.centerLng != widget.centerLng ||
        oldWidget.trucks != widget.trucks) {
      _renderMarkers();
    }
  }

  @override
  void dispose() {
    _removeDomContainer();
    super.dispose();
  }

  bool _kakaoIsAvailable() {
    final win = html.window as dynamic;
    return win.kakao != null;
  }

  void _removeDomContainer() {
    html.document.getElementById(_viewContainerId)?.remove();
  }

  void _syncDomContainerRect() {
    final ctx = _rootKey.currentContext;
    final renderObject = ctx?.findRenderObject();
    if (renderObject is! RenderBox) return;

    final size = renderObject.size;
    final topLeft = renderObject.localToGlobal(Offset.zero);

    final existing = html.document.getElementById(_viewContainerId);
    final div = existing ?? html.DivElement()..id = _viewContainerId;
    if (existing == null) {
      html.document.body?.append(div);
    }

    div.style
      ..position = 'absolute'
      ..left = '${topLeft.dx}px'
      ..top = '${topLeft.dy}px'
      ..width = '${size.width}px'
      ..height = '${size.height}px'
      ..borderRadius = '12px'
      ..overflow = 'hidden'
      ..zIndex = '9999';
  }

  Future<void> _ensureSdkLoaded(String appKey) async {
    if (appKey.isEmpty) {
      throw Exception('KAKAO_JS_API_KEY가 주입되지 않았습니다.');
    }

    if (_kakaoIsAvailable()) return;

    if (html.document.getElementById(_scriptId) == null) {
      final script = html.ScriptElement()
        ..id = _scriptId
        ..type = 'text/javascript'
        ..src = '$_scriptUrlBase$appKey';
      html.document.head?.append(script);
    }

    final start = DateTime.now();
    while (DateTime.now().difference(start) < const Duration(seconds: 15)) {
      if (_kakaoIsAvailable()) return;
      await Future<void>.delayed(const Duration(milliseconds: 200));
    }

    throw Exception('카카오 지도 SDK 로딩이 시간 초과되었습니다.');
  }

  Future<void> _renderMarkers() async {
    setState(() {
      _loadingSdk = true;
      _error = null;
    });

    try {
      _syncDomContainerRect();
      final appKey = MapApiKeys.kakaoMapKeyForCurrentPlatform;
      await _ensureSdkLoaded(appKey);

      final trucksJson = jsonEncode(
        widget.trucks
            .map(
              (t) => <String, dynamic>{
                'lat': t.lat,
                'lng': t.lng,
                'name': t.truckName,
              },
            )
            .toList(),
      );

      final js = '''
(function(){
  var el = document.getElementById('$_viewContainerId');
  if(!el){ return; }

  if(window.__whereistruckMarkers){
    window.__whereistruckMarkers.forEach(function(m){ m.setMap(null); });
  }
  window.__whereistruckMarkers = [];

  var center = new kakao.maps.LatLng(${widget.centerLat}, ${widget.centerLng});
  var map = new kakao.maps.Map(el, { center: center, level: 3 });

  var trucks = $trucksJson;
  trucks.forEach(function(t){
    var pos = new kakao.maps.LatLng(t.lat, t.lng);
    var marker = new kakao.maps.Marker({ position: pos });
    marker.setMap(map);
    window.__whereistruckMarkers.push(marker);
  });
})();
''';

      final script = html.ScriptElement()
        ..type = 'text/javascript'
        ..text = js;
      html.document.body?.append(script);
      script.remove();
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loadingSdk = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _rootKey,
      height: 360,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Stack(
        children: [
          if (_loadingSdk)
            const Positioned.fill(
              child: ColoredBox(
                color: Color.fromARGB(60, 0, 0, 0),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          if (_error != null)
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(191),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

