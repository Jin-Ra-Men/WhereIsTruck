import 'package:flutter/material.dart';

import 'core/firebase/fcm_registration_service.dart';
import 'features/admin/ui/admin_dashboard_page.dart';
import 'features/nearby_trucks/ui/nearby_trucks_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FcmRegistrationService.initializeForAndroidAndRegisterToken();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WhereIsTruck',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('WhereIsTruck'),
            bottom: const TabBar(
              tabs: [
                Tab(text: '주변 트럭'),
                Tab(text: '관리자'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              NearbyTrucksPage(),
              AdminDashboardPage(),
            ],
          ),
        ),
      ),
    );
  }
}
