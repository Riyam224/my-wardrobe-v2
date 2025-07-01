import 'package:flutter/material.dart';
import 'package:my_wordrobe_v2/core/routing/generated_routes.dart';
import 'package:my_wordrobe_v2/core/services/shared_pref.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPref.init(); // ✅ MUST be called before runApp()

  runApp(const MyWordrobeV2());
}

class MyWordrobeV2 extends StatelessWidget {
  const MyWordrobeV2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: RouteGenerator.mainRoutingInOurApp,
    );
  }
}
