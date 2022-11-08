import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_perkiraan_cuaca/network/WeatherApi.dart';
import 'package:flutter_perkiraan_cuaca/notifier/weatherNotifier.dart';
import 'package:flutter_perkiraan_cuaca/utils/SizeConfig.dart';
import 'package:flutter_perkiraan_cuaca/view/DetailWeather.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DailyWeather extends StatelessWidget {
  int timeZoneOffset = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherDailyNotifier>(
      builder: (_, value, __) {
        List daily = value.getDaily();
        timeZoneOffset = value.getTimezoneOfset();
        Map selected = {};
        int Id = value.getId();

        if (Id != 999 && daily.isNotEmpty) {
          for (var val in daily) {
            if (Id == daily.indexOf(val)) {
              selected = val;
              selected['colorSelected'] = true;
              break;
            }
          }
        } else {
          selected = daily.isNotEmpty ? daily[0] : {};
        }

        return selected != {} || daily.isNotEmpty
            ? Scaffold(
                body: Column(
                children: [
                  Expanded(
                    child: DetailWeatherDaily(selected, timeZoneOffset, true),
                  ),
                  Container(
                    // height: 370,
                    height: MySize.scaleFactorHeight * 450,
                    color: const Color(0xFF010a19),
                    padding: EdgeInsets.symmetric(
                        horizontal: MySize.scaleFactorWidth * 40,
                        vertical: MySize.scaleFactorHeight * 20),
                    child: Column(
                      children:
                          ListWeatherDays(context, 0, timeZoneOffset, daily),
                    ),
                  ),
                ],
              )
                // This trailing comma makes auto-formatting nicer for build methods.
                )
            : const Center(
                child: CircularProgressIndicator(
                  color: Colors.blueAccent,
                ),
              );
      },
    );
  }
}

String convertDate(int data, int offset) {
  dynamic dt = DateTime.fromMillisecondsSinceEpoch(data + offset);

  String day = DateFormat("EEE").format(dt).toString();

  return day;
}

List<Widget> ListWeatherDays(
    BuildContext context, int id, dynamic timeoffset, List<dynamic> data) {
  List<Widget> dataWidget = [];
  if (data.isNotEmpty) {
    for (var val in data) {
      if (data.indexOf(val) == id) {
        dataWidget.add(Expanded(
          child: weatherDays(
              context: context,
              id: data.indexOf(val),
              main: val['weather'][0]['main'].toString(),
              suhuMin: val['temp']['min'].toString(),
              suhuMax: val['temp']['max'].toString(),
              pathImage: val['weather'][0]['icon'],
              time: convertDate(timeoffset, val['dt'])),
        ));
      } else {
        dataWidget.add(Expanded(
          child: weatherDays(
              context: context,
              id: data.indexOf(val),
              main: val['weather'][0]['main'].toString(),
              suhuMin: val['temp']['min'].toString(),
              suhuMax: val['temp']['max'].toString(),
              pathImage: val['weather'][0]['icon'],
              time: convertDate(timeoffset, val['dt'])),
        ));
      }
    }
  }
  return dataWidget;
}

Widget weatherDays(
    {required BuildContext context,
    int? id,
    String suhuMax = "",
    String suhuMin = "",
    String main = "",
    String pathImage = "default",
    String time = "--"}) {
  // Color
  return InkWell(
    onTap: () {
      Provider.of<WeatherDailyNotifier>(context, listen: false)
          .updateList(id ?? 0);
    },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          time,
          // suhu + "\u00B0",
          style: const TextStyle(
              color: Color(0XFF68798F),
              fontFamily: 'OpenSauceSans',
              fontWeight: FontWeight.w500,
              fontSize: 16),
        ),
        SizedBox(
          width: MySize.scaleFactorWidth * 30,
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                width: MySize.scaleFactorWidth * 50,
                height: MySize.scaleFactorHeight * 50, fit: BoxFit.fill, //160
                image: AssetImage('assets/images/$pathImage.png'),
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                main,
                style: const TextStyle(
                    color: Color(0XFF68798F),
                    fontFamily: 'OpenSauceSans',
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Text(
              "+" + suhuMax.substring(0, 2) + "\u00B0",
              style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'OpenSauceSans',
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            ),
            const SizedBox(
              width: 2,
            ),
            Text(
              "+" + suhuMin.substring(0, 2) + "\u00B0",
              style: const TextStyle(
                  color: Color(0XFF68798F),
                  fontFamily: 'OpenSauceSans',
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            ),
          ],
        ),
      ],
    ),
  );
}
