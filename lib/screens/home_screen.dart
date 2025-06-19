import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_home/core/app_routes.dart';
import '../providers/device_provider.dart';
import '../widgets/device_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceProvider = Provider.of<DeviceProvider>(context);
    final homeDevices = deviceProvider.homeScreenDevices;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мой Умный Дом'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.editDevices);
            },
          ),
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.allDevices);
            },
          ),
        ],
      ),
      body: homeDevices.isEmpty
          ? const Center(
        child: Text(
          'Устройства не найдены. Добавьте их на экране "Все устройства" и выберите для главного экрана.',
          textAlign: TextAlign.center,
        ),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(10.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 1.0,
        ),
        itemCount: homeDevices.length,
        itemBuilder: (context, index) {
          final device = homeDevices[index];
          return DeviceCard(
            device: device,
            onTap: () {
              if (device.type != 'thermo') {
                Provider.of<DeviceProvider>(context, listen: false).toggleDeviceStatus(device.id);
              }
            },
          );
        },
      ),
    );
  }
}
