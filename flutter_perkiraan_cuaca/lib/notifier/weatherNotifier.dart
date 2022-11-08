import 'package:flutter/material.dart';
import 'package:flutter_perkiraan_cuaca/network/WeatherApi.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';

class WeatherNotifier extends ChangeNotifier {
  Map currently = {};
  Map allData = {};
  List daily = [];
  List hourly = [];

  int Id = 999;
  int timeZoneOfset = 0;

  WeatherNotifier() {
    init();
  }

  init() async {
    await getData();

    notifyListeners();
  }

  getCurrently() => currently;

  getAlldata() => allData;
  getHourly() => hourly;
  getDaily() => daily;
  getTimezoneOfset() => timeZoneOfset;
  getId() => Id;

  Future<void> getData() async {
    var openBox = await Hive.openBox("box_weather");
    var addBox = Hive.box("box_weather");
    if (openBox.isOpen) {
      if (openBox.isNotEmpty) {
        allData = openBox.get("data");
        hourly = allData['hourly'];
        daily = allData['daily'];
        currently = allData['current'];
        timeZoneOfset = allData['timezone_offset'];
      }
    }
    notifyListeners();
  }

  updateList(int id) async {
    if (Id == id) {
      Id = 999;
    } else {
      Id = id;
    }

    notifyListeners();
  }
}

class WeatherDailyNotifier extends ChangeNotifier {
  Map currently = {};
  Map allData = {};
  List daily = [];
  List hourly = [];

  int Id = 999;
  int timeZoneOfset = 0;

  WeatherDailyNotifier() {
    init();
  }

  init() async {
    await getData();

    notifyListeners();
  }

  getCurrently() => currently;

  getAlldata() => allData;
  getHourly() => hourly;
  getDaily() => daily;
  getTimezoneOfset() => timeZoneOfset;
  getId() => Id;

  Future<void> getData() async {
    var openBox = await Hive.openBox("box_weather");
    var addBox = Hive.box("box_weather");
    if (openBox.isOpen) {
      if (openBox.isNotEmpty) {
        allData = openBox.get("data");
        hourly = allData['hourly'];
        daily = allData['daily'];
        currently = allData['current'];
        timeZoneOfset = allData['timezone_offset'];
      }
    }
    notifyListeners();
  }

  updateList(int id) async {
    if (Id == id) {
      Id = 999;
    } else {
      Id = id;
    }

    notifyListeners();
  }
}
