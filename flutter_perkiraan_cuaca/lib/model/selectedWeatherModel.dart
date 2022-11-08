class SelectedWheather {
  int? dt = 0;
  dynamic temp = 0;
  dynamic tempMin = 0;
  dynamic pressure = 0;
  dynamic feels_like = 0;
  dynamic humidity = 0;
  dynamic dew_point = 0;
  dynamic uvi = 0;
  dynamic clouds = 0;
  dynamic visibility = 0;
  dynamic wind_speed = 0;
  dynamic wind_deg = 0;
  Map? weather = {
    "id": 999,
    "main": "Searching",
    "description": "Searching",
    "icon": "default"
  };
  dynamic pop = 0;
  SelectedWheather(
      {this.dt,
      this.temp,
      this.pressure,
      this.feels_like,
      this.humidity,
      this.dew_point,
      this.uvi,
      this.clouds,
      this.visibility,
      this.wind_speed,
      this.wind_deg,
      this.weather,
      this.pop});

  SelectedWheather.fromMap(Map map, bool daily) {
    dt = map['dt'] ?? 0;

    if (daily) {
      if (map['temp'] != null) {
        temp = map['temp']['day'];
        tempMin = map['temp']['min'];
      } else {
        temp = 0;
        tempMin = 0;
      }
      if (map['feels_like'] != null) {
        feels_like = map['feels_like']['day'] ?? 0;
      } else {
        feels_like = 0;
      }
    } else {
      temp = map['temp'] ?? 0;
      feels_like = map['feels_like'] ?? 0;
    }

    pressure = map['pressure'] ?? 0;

    humidity = map['humidity'] ?? 0;
    dew_point = map['dew_point'] ?? 0;
    uvi = map['uvi'] ?? 0;
    clouds = map['clouds'] ?? 0;
    visibility = map['visibility'] ?? 0;
    wind_speed = map['wind_speed'] ?? 0;
    wind_deg = map['wind_deg'] ?? 0;
    if (map['weather'] != null) {
      weather = map['weather'][0];
    }

    pop = map['pop'] ?? 0;
  }
}
