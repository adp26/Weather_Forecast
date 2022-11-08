import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class GetWeather {
  final String _Url = "https://api.openweathermap.org/data/2.5/onecall?";
  Future<Map<String, dynamic>> getWeather(
    double lat,
    double long,
  ) async {
    String units = "metric";
    String lang = "id";
    String appid = "45865970ebbfbc127eb2a16dd7f753e7";

    dynamic objResult = {};
    dynamic headers = {'Content-Type': 'application/json'};

    print('$_Url' +
        'lat=$lat&lon=$long&exclude=minutely&appid=$appid&units=$units&lang=$lang');
    try {
      var request = http.Request(
          'GET',
          Uri.parse('$_Url' +
              'lat=$lat&lon=$long&exclude=minutely&appid=$appid&units=$units'));

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String strResult = await response.stream.bytesToString();
        if (strResult != "") {
          dynamic data = await jsonDecode(strResult);
          objResult = Map<String, dynamic>.from(data);
        }
      }
    } catch (e) {
      print(e);

      objResult = {"error": "data is empty, please try again"};
    }

    return objResult;
  }
}
