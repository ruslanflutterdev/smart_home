import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_home/models/device_model.dart';
import 'package:uuid/uuid.dart';
import '../providers/device_provider.dart';

class AllDevicesScreen extends StatelessWidget {
  const AllDevicesScreen({super.key});

  Future<void> _showRenameDialog(
    BuildContext context,
    DeviceModel device,
  ) async {
    final TextEditingController controller = TextEditingController(
      text: device.name,
    );

    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Переименовать устройство'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: 'Новое имя'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              child: Text('Отмена'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text('Сохранить'),
              onPressed: () {
                final newName = controller.text.trim();
                if (newName.isEmpty) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(content: Text('Имя не может быть пустым')),
                  );
                  return;
                }

                final deviceProvider = Provider.of<DeviceProvider>(
                  context,
                  listen: false,
                );
                if (deviceProvider.isDeviceNameTaken(
                  newName,
                  excludeId: device.id,
                )) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(
                      content: Text('Устройство с таким именем уже существует'),
                    ),
                  );
                  return;
                }

                if (newName != device.name) {
                  final newDevice = device.copyWith(name: newName);
                  deviceProvider.updateDevice(newDevice);
                }
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _addNewDevice(BuildContext context) async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController typeController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Добавить новое устройство'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Название устройства'),
                ),
                TextField(
                  controller: typeController,
                  decoration: InputDecoration(
                    labelText: 'Тип устройства (light, lock, ac, thermo)',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Отмена'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text('Добавить'),
              onPressed: () {
                final name = nameController.text.trim();
                final type = typeController.text.trim().toLowerCase();

                if (name.isEmpty || type.isEmpty) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(content: Text('Поля не могут быть пустыми')),
                  );
                  return;
                }

                final deviceProvider = Provider.of<DeviceProvider>(
                  context,
                  listen: false,
                );
                if (deviceProvider.isDeviceNameTaken(name)) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(
                      content: Text('Устройство с таким именем уже существует'),
                    ),
                  );
                  return;
                }

                final newDevice = DeviceModel(
                  id: Uuid().v4(),
                  name: name,
                  type: type,
                );
                deviceProvider.addDevice(newDevice);
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceProvider = Provider.of<DeviceProvider>(context);
    final allDevices = deviceProvider.devices;
    if (allDevices.isEmpty) {
      return Center(
        child: Text('Устройств пока нет. Нажмите "+" чтобы добавить.'),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Все устройства'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _addNewDevice(context),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: allDevices.length,
        itemBuilder: (context, index) {
          final device = allDevices[index];
          return Dismissible(
            key: ValueKey(device.id),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              deviceProvider.removeDevice(device.id);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('${device.name} удалено')));
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20.0),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ListTile(
                title: Text(device.name),
                subtitle: Text('Тип: ${device.type}'),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _showRenameDialog(context, device),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
