import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_home/models/device_model.dart';
import '../providers/device_provider.dart';

class DeviceCard extends StatelessWidget {
  final DeviceModel device;
  final VoidCallback? onTap;

  const DeviceCard({super.key, required this.device, this.onTap});

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    Color iconColor;
    String statusText = '';
    String? extraInfo;

    switch (device.type) {
      case 'light':
        iconData = Icons.lightbulb;
        iconColor = device.isOn ? Colors.amber : Colors.grey;
        statusText = device.isOn ? 'Включен' : 'Выключен';
        break;
      case 'lock':
        iconData = device.isOn ? Icons.lock_open : Icons.lock;
        iconColor = device.isOn ? Colors.green : Colors.red;
        statusText = device.isOn ? 'Открыт' : 'Закрыт';
        break;
      case 'ac':
        iconData = Icons.ac_unit;
        iconColor = device.isOn ? Colors.blue : Colors.grey;
        statusText = device.isOn ? 'Включен' : 'Выключен';
        if (device.isOn && device.currentTemperature != null) {
          extraInfo = '${device.currentTemperature}°C';
        }
        break;
      case 'thermo':
        iconData = Icons.thermostat;
        iconColor = Colors.orange;
        extraInfo =
            '${device.currentTemperature?.toStringAsFixed(1) ?? 'N/A'}°C';
        break;
      default:
        iconData = Icons.device_unknown;
        iconColor = Colors.black;
        statusText = device.isOn ? 'Активен' : 'Неактивен';
    }

    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: () {
          if (device.type == 'ac') {
            _showTemperatureDialog(context, device);
          } else {
            onTap?.call();
          }
        },
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(iconData, size: 48.0, color: iconColor),
              SizedBox(height: 10.0),
              Text(
                device.name,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              if (extraInfo != null)
                Text(
                  extraInfo,
                  style: TextStyle(fontSize: 14.0, color: Colors.blueGrey),
                )
              else if (statusText.isNotEmpty)
                Text(
                  statusText,
                  style: TextStyle(
                    color: device.isOn ? Colors.green : Colors.red,
                    fontSize: 14.0,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTemperatureDialog(BuildContext context, DeviceModel device) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Выберите температуру для ${device.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Provider.of<DeviceProvider>(
                    context,
                    listen: false,
                  ).setDeviceTemperature(device.id, 15.0);
                  Navigator.of(dialogContext).pop();
                },
                child: Text('15°C'),
              ),
              ElevatedButton(
                onPressed: () {
                  Provider.of<DeviceProvider>(
                    context,
                    listen: false,
                  ).setDeviceTemperature(device.id, 20.0);
                  Navigator.of(dialogContext).pop();
                },
                child: Text('20°C'),
              ),
              ElevatedButton(
                onPressed: () {
                  Provider.of<DeviceProvider>(
                    context,
                    listen: false,
                  ).setDeviceTemperature(device.id, 25.0);
                  Navigator.of(dialogContext).pop();
                },
                child: Text('25°C'),
              ),
              ElevatedButton(
                onPressed: () {
                  Provider.of<DeviceProvider>(
                    context,
                    listen: false,
                  ).setDeviceTemperature(device.id, 30.0);
                  Navigator.of(dialogContext).pop();
                },
                child: Text('30°C'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text('Отмена'),
            ),
          ],
        );
      },
    );
  }
}
