import 'dart:async';
import 'package:geolocator/geolocator.dart';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cultiveapp/model/weather_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class WeatherBloc extends BlocBase {
  String url = "";
  final StreamController<Weather> _streamController =
      StreamController<Weather>();
  Sink<Weather> get input => _streamController.sink;
  Stream<Weather> get output => _streamController.stream;

  void getUpdateWeather() async {
    debugPrint("Get Weather from HG Brasil");
    Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    Response response = await Dio().get(
        _getUrl(position.latitude.toString(), position.longitude.toString()));
    Weather weather = Weather.fromJson(response.data);
    _streamController.add(weather);
  }

  _getUrl(String lat, String log) =>
      "https://api.hgbrasil.com/weather?fields=only_results, temp, condition_slug, city, humidity, wind_speedy, forecast, date, weekday, max, min, description, condition&key=695a3e17&lat=$lat&log=$log&user_ip=remote";

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
  }
}
