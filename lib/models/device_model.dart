class DeviceModel {
  final String id;
  final String name;
  final String type;
  final bool isOn;
  final double? currentTemperature;

  const DeviceModel({
    required this.id,
    required this.name,
    required this.type,
    this.isOn = false,
    this.currentTemperature,
  });

  DeviceModel copyWith({
    String? id,
    String? name,
    String? type,
    bool? isOn,
    double? currentTemperature,
  }) {
    return DeviceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      isOn: isOn ?? this.isOn,
      currentTemperature: currentTemperature ?? this.currentTemperature,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DeviceModel &&
        other.id == id &&
        other.name == name &&
        other.type == type &&
        other.isOn == isOn &&
        other.currentTemperature == currentTemperature;
  }

  @override
  int get hashCode => Object.hash(id, name, type, isOn, currentTemperature);
}
