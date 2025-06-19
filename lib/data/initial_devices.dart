import 'package:smart_home/models/device_model.dart';
import 'package:uuid/uuid.dart';

final Uuid _uuid = const Uuid();

final List<DeviceModel> initialDevices = [
  DeviceModel(
    id: _uuid.v4(),
    name: 'Свет в гостинной',
    type: 'light',
    isOn: true,
  ),
  DeviceModel(id: _uuid.v4(), name: 'Замок входной двери', type: 'lock'),
  DeviceModel(
    id: _uuid.v4(),
    name: 'Кондиционер в спальне',
    type: 'ac',
    currentTemperature: 20.0,
  ),
  DeviceModel(
    id: _uuid.v4(),
    name: 'Термо-датчик кухни',
    type: 'thermo',
    currentTemperature: 22.5,
  ),
  DeviceModel(
    id: _uuid.v4(),
    name: 'Потолочный вентилятор',
    type: 'ac',
    currentTemperature: 25.0,
  ),
  DeviceModel(id: _uuid.v4(), name: 'Лампа у кровати', type: 'light'),
  DeviceModel(
    id: _uuid.v4(),
    name: 'Датчик движения',
    type: 'thermo',
    currentTemperature: 21.0,
  ),
];
