class SensorReadings {
  final double temperature;
  final double airHumidity;
  final double soilMoisture;
  final double lightKlx;
  final double waterLevelLiters;
  final DateTime updatedAt;

  SensorReadings({
    required this.temperature,
    required this.airHumidity,
    required this.soilMoisture,
    required this.lightKlx,
    required this.waterLevelLiters,
    required this.updatedAt,
  });

  factory SensorReadings.fromMap(Map<String, dynamic> map) {
    return SensorReadings(
      temperature: (map['temperature'] as num?)?.toDouble() ?? 24.6,
      airHumidity: (map['airHumidity'] as num?)?.toDouble() ?? 68.0,
      soilMoisture: (map['soilMoisture'] as num?)?.toDouble() ?? 64.0,
      lightKlx: (map['light'] as num?)?.toDouble() ?? 12.4,
      waterLevelLiters: (map['waterLevel'] as num?)?.toDouble() ?? 984.0,
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'temperature': temperature,
      'airHumidity': airHumidity,
      'soilMoisture': soilMoisture,
      'light': lightKlx,
      'waterLevel': waterLevelLiters,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class DeviceItem {
  final String id;
  final String name;
  final bool state;
  final DateTime updatedAt;

  DeviceItem({
    required this.id,
    required this.name,
    required this.state,
    required this.updatedAt,
  });

  factory DeviceItem.fromMap(String id, Map<String, dynamic> map) {
    final rawState = map['state'];
    final bool isStateOn = rawState is bool
        ? rawState
        : (rawState?.toString().toLowerCase() == 'on');

    return DeviceItem(
      id: id,
      name: map['name'] ?? id,
      state: isStateOn,
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class HistoryEntry {
  final DateTime timestamp;
  final double temperature;
  final double soilMoisture;
  final double airHumidity;

  HistoryEntry({
    required this.timestamp,
    required this.temperature,
    required this.soilMoisture,
    required this.airHumidity,
  });

  factory HistoryEntry.fromMap(Map<String, dynamic> map) {
    return HistoryEntry(
      timestamp: map['timestamp'] != null
          ? DateTime.tryParse(map['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
      temperature: (map['temperature'] as num?)?.toDouble() ?? 24.0,
      soilMoisture: (map['soilMoisture'] as num?)?.toDouble() ?? 60.0,
      airHumidity: (map['airHumidity'] as num?)?.toDouble() ?? 65.0,
    );
  }
}

class AlertNotice {
  final String id;
  final String type; // 'critical', 'warning', 'info'
  final String title;
  final String message;
  final double value;
  final DateTime createdAt;

  AlertNotice({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.value,
    required this.createdAt,
  });

  factory AlertNotice.fromMap(String id, Map<String, dynamic> map) {
    return AlertNotice(
      id: id,
      type: map['type'] ?? 'info',
      title: map['title'] ?? 'Greenhouse alert',
      message: map['message'] ?? '',
      value: (map['value'] as num?)?.toDouble() ?? 0.0,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
