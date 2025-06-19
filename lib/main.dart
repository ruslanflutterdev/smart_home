import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_home/providers/device_provider.dart';
import 'package:smart_home/screens/all_devices_screen.dart';
import 'package:smart_home/screens/edit_devices_screen.dart';
import 'core/app_routes.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DeviceProvider(),
      child: MaterialApp(
        title: 'Smart Home',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: AppRoutes.home,
        routes: {
          AppRoutes.home: (context) => HomeScreen(),
          AppRoutes.editDevices: (context) => EditDevicesScreen(),
          AppRoutes.allDevices: (context) => AllDevicesScreen(),
        },
      ),
    );
  }
}
