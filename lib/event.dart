class Event {
  late int id;
  late double timestamp;
  late DateTime date;

  late String timezone;
  late String datetime;
  late dynamic device;
  late dynamic build;
  late dynamic address;
  late int noAddress;

  late dynamic battery;
  late dynamic activity;
  late dynamic gps;
  late dynamic network;

  // Gyro & Accelerometer props
  late dynamic gyroscope;
  late dynamic accelerometer;

  late int proximityChanging;
  late dynamic barometer;
  late int syncedAt;
  late dynamic weather;
  late dynamic health;

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

  Event.map(Map _params) {
    var map = Map.from(_params);
    id = map["id"];
    timestamp = map["timestamp"];
    timezone = map["timezone"];
    datetime = map["datetime"];
    device = map["device"];
    build = map["build"];
    noAddress = map["no_address"];
    gps = map["gps"];
    network = map["network"];
    address = map["locator"];
    battery = map["battery"];
    activity = map["activity"];
    gyroscope = map["gyroscope"];
    accelerometer = map["accelerometer"];
    proximityChanging = map["proximity_changing"];
    barometer = map["barometer"];
    syncedAt = map["synced_at"];
    weather = map["weather"];
    health = map["health"];
  }
}
