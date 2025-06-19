import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smart_home/data/initial_devices.dart';
import 'package:smart_home/models/device_model.dart';

class DeviceProvider extends ChangeNotifier {
  List<DeviceModel> _devices = List.from(initialDevices);
  List<String> _homeScreenDeviceIds = [];
  Timer? _thermoTimer;

  DeviceProvider() {
    if (_devices.isNotEmpty) {
      _homeScreenDeviceIds = _devices.take(4).map((d) => d.id).toList();
    }
    _startThermoTemperatureUpdates();
  }

  @override
  void dispose() {
    _thermoTimer?.cancel();
    super.dispose();
  }

  void _startThermoTemperatureUpdates() {
    _thermoTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      final newDevices = _devices.map((device) {
        if (device.type == 'thermo') {
          double newTemp = (device.currentTemperature ?? 20) + 1.5;
          if (newTemp > 30) {
            newTemp = 20;
          }
          return device.copyWith(currentTemperature: newTemp);
        }
        return device;
      }).toList();
      _devices = newDevices;
      notifyListeners();
    });
  }

  List<DeviceModel> get devices => List.unmodifiable(_devices);

  List<DeviceModel> get homeScreenDevices {
    return _homeScreenDeviceIds
        .map(
          (id) => _devices.firstWhere(
            (device) => device.id == id,
            orElse: () =>
                throw Exception('Device with ID $id not found in main list'),
          ),
        )
        .toList();
  }

  bool isDeviceNameTaken(String name, {String? excludeId}) {
    return _devices.any(
      (device) =>
          device.name.toLowerCase() == name.toLowerCase() &&
          (excludeId == null || device.id != excludeId),
    );
  }

  void addDevice(DeviceModel device) {
    if (isDeviceNameTaken(device.name)) {
      return;
    }
    _devices = [..._devices, device];
    notifyListeners();
  }

  void updateDevice(DeviceModel updatedDevice) {
    final index = _devices.indexWhere(
      (device) => device.id == updatedDevice.id,
    );
    if (index != -1) {
      if (isDeviceNameTaken(updatedDevice.name, excludeId: updatedDevice.id)) {
        return;
      }
      final newDevices = List<DeviceModel>.from(_devices);
      newDevices[index] = updatedDevice;
      _devices = newDevices;
      notifyListeners();
    }
  }

  void removeDevice(String id) {
    _devices = _devices.where((device) => device.id != id).toList();
    _homeScreenDeviceIds.removeWhere((deviceId) => deviceId == id);
    notifyListeners();
  }

  void toggleDeviceStatus(String id) {
    final index = _devices.indexWhere((device) => device.id == id);
    if (index != -1) {
      final currentDevice = _devices[index];
      final newDevices = List<DeviceModel>.from(_devices);
      newDevices[index] = currentDevice.copyWith(isOn: !currentDevice.isOn);
      _devices = newDevices;
      notifyListeners();
    }
  }

  void setDeviceTemperature(String id, double temperature) {
    final index = _devices.indexWhere((device) => device.id == id);
    if (index != -1) {
      final currentDevice = _devices[index];
      final newDevices = List<DeviceModel>.from(_devices);
      newDevices[index] = currentDevice.copyWith(
        currentTemperature: temperature,
        isOn: true,
      );
      _devices = newDevices;
      notifyListeners();
    }
  }

  void setHomeScreenDevices(List<String> deviceIds) {
    _homeScreenDeviceIds = deviceIds;
    notifyListeners();
  }
}
