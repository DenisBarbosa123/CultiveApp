import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cultiveapp/bloc/user_bloc.dart';
import 'package:cultiveapp/model/weather_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class WeatherBloc extends BlocBase {
  final StreamController<Weather> _streamController =
      StreamController<Weather>();
  Stream<Weather> get output => _streamController.stream;
  UserBloc userBloc = UserBloc();

  String cityName;
  WeatherBloc(this.cityName);

  void getUpdateWeather() async {
    debugPrint("Get Weather from HG Brasil");
    String weatherEndPointPath = _getUrl(cityName);
    Response response = await Dio().get(weatherEndPointPath);
    Weather weather = Weather.fromJson(response.data);
    _streamController.add(weather);
  }

  _getUrl(String cityName) =>
      "https://api.hgbrasil.com/weather?fields=only_results, temp, condition_slug, city, humidity, wind_speedy, forecast, date, weekday, max, min, description, condition&key=695a3e17&city_name=$cityName";

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
  }
}
