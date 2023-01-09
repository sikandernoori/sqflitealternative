class Event {
  int id;
  final double timestamp;
  final DateTime date;

  final String timezone;
  final String datetime;
  final dynamic device;
  final dynamic build;
  final dynamic address;
  final int noAddress;

  final dynamic battery;
  final dynamic activity;
  final dynamic gps;
  final dynamic network;

  // Gyro & Accelerometer props
  final dynamic gyroscope;
  final dynamic accelerometer;

  final int proximityChanging;
  final dynamic barometer;
  final int syncedAt;
  final dynamic weather;
  final dynamic health;

  Event(
    this.id,
    this.timezone,
    this.datetime,
    this.device,
    this.build,
    this.address,
    this.noAddress,
    this.battery,
    this.activity,
    this.gps,
    this.network,
    this.gyroscope,
    this.accelerometer,
    this.proximityChanging,
    this.barometer,
    this.syncedAt,
    this.weather,
    this.health,
    this.timestamp,
    this.date,
  );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["timestamp"] = timestamp;
    map["timezone"] = timezone;
    map["datetime"] = datetime;
    map["device"] = device;
    map["build"] = build;
    map["no_address"] = noAddress;
    map["gps"] = gps;
    map["network"] = network;
    map["locator"] = address;
    map["battery"] = battery;
    map["activity"] = activity;
    map["gyroscope"] = gyroscope;
    map["accelerometer"] = accelerometer;
    map["proximity_changing"] = proximityChanging;
    map["barometer"] = barometer;
    map["synced_at"] = syncedAt;
    map["weather"] = weather;
    map["health"] = health;
    return Map.fromEntries(map.entries.where((e) => e.value != null));
  }
}
