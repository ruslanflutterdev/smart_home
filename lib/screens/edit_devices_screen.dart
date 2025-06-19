import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/models/device_model.dart';
import '../providers/device_provider.dart';

class EditDevicesScreen extends StatefulWidget {
  const EditDevicesScreen({super.key});

  @override
  State<EditDevicesScreen> createState() => _EditDevicesScreenState();
}

class _EditDevicesScreenState extends State<EditDevicesScreen> {
  final List<String> _selectedDeviceIdsForHome = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final deviceProvider = Provider.of<DeviceProvider>(
        context,
        listen: false,
      );
      setState(() {
        _selectedDeviceIdsForHome.addAll(
          deviceProvider.homeScreenDevices.map((d) => d.id),
        );
      });
    });
  }

  void _toggleDeviceSelection(DeviceModel device) {
    setState(() {
      if (_selectedDeviceIdsForHome.contains(device.id)) {
        _selectedDeviceIdsForHome.remove(device.id);
      } else if (_selectedDeviceIdsForHome.length < 6) {
        _selectedDeviceIdsForHome.add(device.id);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Можно выбрать только 6 устройств для главного экрана.',
            ),
          ),
        );
      }
    });
  }

  void _saveChanges() {
    final deviceProvider = Provider.of<DeviceProvider>(context, listen: false);
    deviceProvider.setHomeScreenDevices(_selectedDeviceIdsForHome);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final deviceProvider = Provider.of<DeviceProvider>(context);
    final allDevices = deviceProvider.devices;
    return Scaffold(
      appBar: AppBar(
        title: Text('Редактировать виджеты'),
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _saveChanges)],
      ),
      body: ListView.builder(
        itemCount: allDevices.length,
        itemBuilder: (context, index) {
          final device = allDevices[index];
          final isSelected = _selectedDeviceIdsForHome.contains(device.id);
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ListTile(
              title: Text(device.name),
              subtitle: Text(device.type),
              trailing: Checkbox(
                value: isSelected,
                onChanged: (bool? value) {
                  _toggleDeviceSelection(device);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
