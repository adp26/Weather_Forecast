import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_perkiraan_cuaca/network/WeatherApi.dart';
import 'package:flutter_perkiraan_cuaca/notifier/weatherNotifier.dart';
import 'package:flutter_perkiraan_cuaca/view/DetailWeather.dart';
import 'package:flutter_perkiraan_cuaca/view/dailyWeather.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_perkiraan_cuaca/utils/SizeConfig.dart';

class DashboadWeather extends StatefulWidget {
  const DashboadWeather({Key? key}) : super(key: key);

  @override
  _DashboadWeatherState createState() => _DashboadWeatherState();
}

class _DashboadWeatherState extends State<DashboadWeather> {
  String location = "Search Location";
  String timeUpdate = "Updated 10 min ago";
  Future<Map<String, dynamic>?> getWeatherAPI() async {
    bool serviceEnabled;
    LocationPermission permission;
    Map<String, dynamic> data = {};

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    } else {
      print("lokasi tidak ditemukan");
      print(serviceEnabled);
      permission = await Geolocator.checkPermission();
      print('permission');
      print(permission);
    }

    permission = await Geolocator.checkPermission();
    var openBox = await Hive.openBox("box_weather");
    var addBox = Hive.box("box_weather");
    if (permission == LocationPermission.denied) {
      print("permission");
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position _locationData = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    //============== geocoding ==============//
    List<Placemark> placemarks = await placemarkFromCoordinates(
        _locationData.latitude, _locationData.longitude);
    String strStreet =
        placemarks[0].street!.split(placemarks[0].subLocality.toString())[0];

    location = "${placemarks[0].subLocality}";

    if (_locationData.latitude != null && _locationData.latitude != 0) {
      GetWeather getWeather = GetWeather();

      data = await getWeather.getWeather(
          _locationData.latitude, _locationData.longitude);

      if (!data.containsKey("error")) {
        //add to local storage

        if (openBox.isOpen) {
          addBox.put("data", data);
          return data;
        }
      } else {
        if (openBox.isOpen) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              duration: Duration(seconds: 1),
              content: Text("you are offline")));
          if (openBox.isNotEmpty) {
            data = openBox.get("data");
          }
        }
      }
    }

    return data;
  }

  refreshPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return FutureBuilder<dynamic>(
        future: getWeatherAPI(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            dynamic objData = snapshot.data!;
            print("objData");
            print(objData);
            if (!objData.containsKey("error")) {
              return Consumer<WeatherNotifier>(builder: (_, value, __) {
                List hourly = value.getHourly();
                bool reset = true;

                int timeZoneOffset = value.getTimezoneOfset();

                Map selected = {};

                int Id = value.getId();

                if (Id != 999 && hourly.isNotEmpty) {
                  for (var val in hourly) {
                    if (Id == hourly.indexOf(val)) {
                      selected = val;
                      selected['colorSelected'] = true;
                      break;
                    }
                  }
                } else {
                  selected = value.getCurrently();
                }

                return Scaffold(
                    body: RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        children: [
                          Expanded(
                            child: DetailWeatherDashboard(location, selected,
                                timeUpdate, timeZoneOffset, false, reset),
                          ),
                          const VerticalDivider(
                            color: Colors.transparent,
                            width: 0,
                            thickness: 0,
                          ),
                          Container(
                            height: MySize.scaleFactorHeight * 180,
                            // height: 180,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 0, color: Colors.transparent)),
                            color: const Color(0xFF010a19),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: MySize.scaleFactorWidth * 39,
                                      vertical: MySize.scaleFactorHeight * 18),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Today",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                            fontFamily: 'OpenSauceSans'),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChangeNotifierProvider<
                                                              WeatherDailyNotifier>(
                                                          create: (context) =>
                                                              WeatherDailyNotifier(),
                                                          child: Builder(
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                            return DailyWeather();
                                                          }))));
                                        },
                                        child: Row(
                                          children: const <Widget>[
                                            Text(
                                              "7 days",
                                              style: TextStyle(
                                                  color: Color(0xFF687B92),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: 'OpenSauceSans'),
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              size: 15,
                                              color: Color(0xFF687B92),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        MySize.scaleFactorWidth * 40,
                                        0,
                                        MySize.scaleFactorWidth * 40,
                                        MySize.scaleFactorHeight * 25),
                                    child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: ListWeatherHours(context, Id,
                                            timeZoneOffset, hourly)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                    // This trailing comma makes auto-formatting nicer for build methods.
                    );
              });
            } else {
              return RefreshIndicator(
                onRefresh: () async {
                  setState(() {});
                },
                child: const Scaffold(
                  body: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: Text(
                            "please close open apps and make sure you have a internet connection")),
                  ),
                ),
              );
            }
          }
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.white,
          ));
        });
  }
}

class WeatherPerHour extends StatelessWidget {
  const WeatherPerHour({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

String convertToHHmm(int data, int offset) {
  dynamic dt = DateTime.fromMillisecondsSinceEpoch(data + offset);
  String dataFormat = DateFormat("HH:mm").format(dt).toString();

  return dataFormat;
}

List<Widget> ListWeatherHours(
    BuildContext context, int id, dynamic timeoffset, List<dynamic> data) {
  List<Widget> dataWidget = [];
  if (data.isNotEmpty) {
    for (var val in data) {
      if (data.indexOf(val) == id) {
        dataWidget.add(weatherHour(
            colorSelected: val['colorSelected'],
            context: context,
            id: data.indexOf(val),
            suhu: val['temp'],
            pathImage: val['weather'][0]['icon'],
            time: convertToHHmm(timeoffset, val['dt'])));
      } else {
        dataWidget.add(weatherHour(
            colorSelected: false,
            context: context,
            id: data.indexOf(val),
            suhu: val['temp'],
            pathImage: val['weather'][0]['icon'],
            time: convertToHHmm(timeoffset, val['dt'])));
      }
    }
  }
  return dataWidget;
}

String readTimestamp(int timestamp) {
  var now = new DateTime.now();
  var format = new DateFormat('HH:mm a');
  var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
  var diff = date.difference(now) * (-1);

  var time = '';

  if (diff.inHours > 0 && diff.inDays == 0) {
    time = format.format(date);
    return time;
  } else if (diff.inSeconds >= 0 && diff.inMinutes == 0) {
    time = diff.inSeconds.toString() + ' Detik lalu';
    return time;
  } else if (diff.inMinutes > 0 && diff.inHours == 0) {
    time = diff.inMinutes.toString() + ' Menit lalu';
    return time;
  } else {
    if (diff.inDays >= 1) {
      time = diff.inDays.toString() + ' Hari lalu';
    }
    return time;
  }
}

Widget weatherHour(
    {required BuildContext context,
    int? id,
    bool colorSelected = false,
    dynamic suhu = 0,
    String pathImage = "default",
    String time = "hh:mm"}) {
  // Color
  return InkWell(
    onTap: () {
      Provider.of<WeatherNotifier>(context, listen: false).updateList(id ?? 0);
    },
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: Color(0xFF272727), width: MySize.scaleFactorWidth * 1),
        borderRadius: BorderRadius.circular(27.0),
        gradient: colorSelected
            ? const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xFF82DAF4), Color(0xFF207AF5)])
            : const LinearGradient(
                colors: [Color(0xFF010a19), Color(0xFF010a19)]),
        shape: BoxShape.rectangle,
      ),
      margin: EdgeInsets.symmetric(horizontal: MySize.scaleFactorWidth * 7.0),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Text(
            suhu.toStringAsFixed(0),
            // suhu + "\u00B0",
            style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontFamily: 'OpenSauceSans'),
          ),
          Expanded(
            child: Image(
              width: MySize.scaleFactorWidth * 48,
              height: MySize.scaleFactorHeight * 48, fit: BoxFit.fill, //160
              image: AssetImage('assets/images/$pathImage.png'),
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: 'OpenSauceSans',
              color: Color(0xFF687B92),
            ),
          ),
        ],
      ),
    ),
  );
}
