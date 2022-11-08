import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_perkiraan_cuaca/model/selectedWeatherModel.dart';
import 'package:flutter_perkiraan_cuaca/utils/SizeConfig.dart';
import 'package:intl/intl.dart';
import 'package:flutter_perkiraan_cuaca/utils/SizeConfig.dart';

class updateTime extends StatefulWidget {
  bool reset = false;
  updateTime({required this.reset});

  @override
  _updateTimeState createState() => _updateTimeState();
}

class _updateTimeState extends State<updateTime> {
  Duration duration = const Duration();

  String desTime = "";
  final addSeconds = 1;

  runTimer() async {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      resetTimer();
      if (duration.inSeconds > 60 && duration.inMinutes < 60) {
        setState(() {
          desTime = "Updated ${duration.inMinutes} min ago";
        });
      } else if (duration.inMinutes >= 60) {
        setState(() {
          desTime = "Updated ${duration.inHours} hour ago";
        });
      }
      final seconds = duration.inSeconds + addSeconds;
      duration = Duration(seconds: seconds);
    });
  }

  initState() {
    super.initState();
    resetTimer();
    runTimer();
  }

  resetTimer() async {
    if (widget.reset) {
      setState(() {
        if (widget.reset) {
          duration = Duration();
          widget.reset = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return duration.inSeconds > 60
        ? Container(
            width: MySize.scaleFactorWidth * 141,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                shape: BoxShape.rectangle,
                border: Border.all(
                  color: Colors.white70,
                  // width: 2.0,
                  style: BorderStyle.solid,
                )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.circle,
                  size: 8,
                  color: Colors.yellow,
                ),
                SizedBox(
                  width: MySize.scaleFactorWidth * 5,
                ),
                Expanded(
                  child: Text(
                    desTime,
                    style: const TextStyle(
                        color: Colors.white,
                        fontFamily: "OpenSauceSans",
                        fontSize: 9,
                        fontWeight: FontWeight.w400),
                  ),
                )
              ],
            ),
          )
        : Container(
            width: MySize.scaleFactorWidth * 141,
            height: MySize.scaleFactorHeight * 22,
          );
  }
}

class DetailWeatherDashboard extends StatelessWidget {
  Map selected = {};
  String timeUpdate = "";
  bool reset = false;
  bool daily = false;
  int timezoneOffset = 0;
  String location = "";
  DetailWeatherDashboard(this.location, this.selected, this.timeUpdate,
      this.timezoneOffset, this.daily, this.reset);

  @override
  Widget build(BuildContext context) {
    SelectedWheather objSelected = SelectedWheather.fromMap(selected, daily);

    return Scaffold(
      body: Container(
        height: MySize.scaleFactorHeight * 700,
        color: const Color(0xFF010a19),
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: MySize.scaleFactorWidth * 10),
              child: Center(
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MySize.scaleFactorHeight * 630,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(53.0),
                        bottomRight: Radius.circular(53.0),
                      ),
                      border: Border.all(color: Colors.transparent, width: 0),
                      color: Color(0xFF053F8D).withOpacity(0.6),
                      shape: BoxShape.rectangle,
                    )),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: MySize.scaleFactorHeight * 6.0),
              child: Container(
                width: double.infinity,
                height: MySize.scaleFactorHeight * 640,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(65.0),
                    bottomRight: Radius.circular(65.0),
                  ),
                  border: Border.all(
                      color: const Color(0XFF78D1F5).withOpacity(0.8),
                      width: MySize.scaleFactorWidth * 1),
                  gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF82DAF4), Color(0xFF207AF5)]),
                  shape: BoxShape.rectangle,
                ),
                // height: MySize.scaleFactorHeight * 599,
                // decoration: BoxDecoration(border: ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: const Image(
                              image: AssetImage('assets/images/Group 3.png'),
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.location_pin,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                Text(
                                  location,
                                  // "location",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'OpenSauceSans',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 22),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: IconButton(
                              onPressed: () async {},
                              icon: const Icon(
                                Icons.more_vert,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      updateTime(
                        reset: reset,
                      ),
                      Expanded(
                        child: Image(
                          fit: BoxFit.fill,
                          image: AssetImage(
                              'assets/images/${objSelected.weather!['icon']}.png'),
                        ),
                      ),
                      Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${objSelected.temp.toStringAsFixed(0)}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: "OpenSauceSans",
                                    fontSize: 60,
                                    fontWeight: FontWeight.w700),
                              ),
                              Container(
                                width: MySize.scaleFactorWidth * 20,
                                height: MySize.scaleFactorHeight * 20,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.5),
                                      width: MySize.scaleFactorWidth * 4),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            objSelected.weather!['main'],
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'OpenSauceSans'),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            objSelected.dt != null
                                ? convertDate(
                                    objSelected.dt!, timezoneOffset, daily)
                                : "-----",
                            style: const TextStyle(
                                color: Color(0XFF69B5FF),
                                fontFamily: 'OpenSauceSans',
                                fontWeight: FontWeight.w500,
                                fontSize: 12),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MySize.scaleFactorHeight * 40,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: MySize.scaleFactorWidth * 30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: windHumidityCR(
                                  number:
                                      objSelected.wind_speed.toString() + "m/s",
                                  pathImage: "Wind",
                                  SizeImage: 31,
                                  status: "Wind"),
                            ),
                            Expanded(
                              child: windHumidityCR(
                                  number: objSelected.humidity.toString() + "%",
                                  pathImage: "Humadity",
                                  SizeImage: 12,
                                  status: "Humidity"),
                            ),
                            Expanded(
                              child: windHumidityCR(
                                  number: objSelected.clouds.toString() + "%",
                                  pathImage: "COR",
                                  SizeImage: 21,
                                  status: "Change of Rain"),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailWeatherDaily extends StatelessWidget {
  Map selected = {};

  bool daily = false;
  int timezoneOffset = 0;
  DetailWeatherDaily(this.selected, this.timezoneOffset, this.daily);

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    SelectedWheather objSelected = SelectedWheather.fromMap(selected, daily);

    return Scaffold(
      body: Container(
        // height: 400,
        color: const Color(0xFF010a19),
        child: Stack(
          children: [
            Container(
              // height: 30,
              margin: EdgeInsets.symmetric(
                  horizontal: MySize.scaleFactorWidth * 10),
              child: Center(
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MySize.scaleFactorHeight * 344,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.transparent, width: 0),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(53.0),
                        bottomRight: Radius.circular(53.0),
                      ),
                      color: Color(0xFF053F8D).withOpacity(0.6),
                      shape: BoxShape.rectangle,
                    )),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: MySize.size13!),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(65.0),
                    bottomRight: Radius.circular(65.0),
                  ),
                  border: Border.all(
                      color: const Color(0XFF78D1F5).withOpacity(0.8),
                      width: 1),
                  gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF82DAF4), Color(0xFF207AF5)]),
                  shape: BoxShape.rectangle,
                ),
                height: MySize.scaleFactorHeight * 357,
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Image(
                              image: AssetImage('assets/images/Group 3.png'),
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.calendar_today,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                Text(
                                  // location,
                                  " 7 Days",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'OpenSauceSans',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: IconButton(
                              onPressed: () async {},
                              icon: const Icon(
                                Icons.more_vert,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            width: MySize.scaleFactorWidth * 140,
                            height: MySize.scaleFactorHeight * 140, //160
                            fit: BoxFit.fill,
                            image: AssetImage(
                                'assets/images/${objSelected.weather!['icon']}.png'),
                          ),
                          Column(
                            children: [
                              Text(
                                convertDate(
                                    objSelected.dt!, timezoneOffset, daily),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'OpenSauceSans',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16),
                              ),
                              SizedBox(
                                height: MySize.scaleFactorHeight * 10,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "${objSelected.temp.toStringAsFixed(0)}",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'OpenSauceSans',
                                        fontWeight: FontWeight.w900,
                                        fontSize: 40),
                                  ),
                                  const Text(
                                    "/",
                                    style: TextStyle(
                                        color: Color(0XFF71CBFB),
                                        fontFamily: 'OpenSauceSans',
                                        fontWeight: FontWeight.w900,
                                        fontSize: 20),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${objSelected.tempMin.toStringAsFixed(0)}",
                                        style: const TextStyle(
                                            color: Color(0XFF71CBFB),
                                            fontFamily: 'OpenSauceSans',
                                            fontWeight: FontWeight.w900,
                                            fontSize: 20),
                                      ),
                                      Container(
                                        width: MySize.scaleFactorWidth * 8,
                                        height: MySize.scaleFactorHeight * 8,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          border: Border.all(
                                              color:
                                                  Colors.white.withOpacity(0.5),
                                              width:
                                                  MySize.scaleFactorWidth * 2),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                objSelected.weather!['description'],
                                style: const TextStyle(
                                    color: Color(0XFF71CBFB),
                                    fontFamily: 'OpenSauceSans',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14),
                              ),
                              SizedBox(
                                height: MySize.scaleFactorHeight * 3,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MySize.scaleFactorHeight * 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: windHumidityCR(
                                number:
                                    objSelected.wind_speed.toString() + "m/s",
                                pathImage: "Wind",
                                SizeImage: 31,
                                status: "Wind"),
                          ),
                          Expanded(
                            child: windHumidityCR(
                                number: objSelected.humidity.toString() + "%",
                                pathImage: "Humadity",
                                SizeImage: 12,
                                status: "Humidity"),
                          ),
                          Expanded(
                            child: windHumidityCR(
                                number: objSelected.clouds.toString() + "%",
                                pathImage: "COR",
                                SizeImage: 21,
                                status: "Change of Rain"),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MySize.scaleFactorHeight * 15,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget windHumidityCR(
    {String number = "",
    String pathImage = "default",
    double? SizeImage,
    String status = "hh:mm"}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: MySize.scaleFactorWidth * 8.0),
    child: Column(
      children: [
        Image(
          width: SizeImage,

          height: 19, //160
          image: AssetImage('assets/images/$pathImage.png'),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          number,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              fontFamily: 'OpenSauceSans'),
        ),
        const SizedBox(
          height: 2,
        ),
        Text(
          status,
          style: const TextStyle(
              color: Color(0xFF69B5FF),
              fontSize: 10,
              fontWeight: FontWeight.w500,
              fontFamily: 'OpenSauceSans'),
        ),
      ],
    ),
  );
}

String convertDate(int data, int offset, bool daily) {
  dynamic dt = DateTime.fromMillisecondsSinceEpoch(data + offset);
  String dataFormat = DateFormat("EEEE, dd MMMM").format(dt).toString();
  String day = DateFormat("EEEE").format(dt).toString();
  if (daily) {
    return day;
  }
  return dataFormat;
}

int calc_ranks(ranks) {
  double multiplier = .5;
  return (multiplier * ranks).round();
}
