import 'package:cultiveapp/bloc/weather_bloc.dart';
import 'package:cultiveapp/model/user_model.dart';
import 'package:cultiveapp/model/weather_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

// ignore: must_be_immutable
class WeatherTabs extends StatefulWidget {
  final User user;
  String cityName;
  WeatherTabs(this.user) {
    cityName = user.localizacao.cidade;
  }
  @override
  _WeatherTabsState createState() => _WeatherTabsState();
}

class _WeatherTabsState extends State<WeatherTabs> {
  WeatherBloc _weatherBloc;

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
        child: StreamBuilder<Weather>(
            stream: _weatherBloc.output,
            initialData: null,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                  ),
                );
              }
              return Column(children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: Text("${snapshot.data.city}",
                      style: TextStyle(fontSize: 20.0)),
                ),
                Text("${snapshot.data.description}",
                    style:
                        TextStyle(fontSize: 17.0, fontStyle: FontStyle.italic)),
                SizedBox(
                  width: 120,
                  height: 100,
                  child:
                      _provideWeatherIcon("${snapshot.data.conditionSlug}", 60),
                ),
                Text(
                  "${snapshot.data.temp}°",
                  style: TextStyle(fontSize: 55.0, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Min: ${snapshot.data.forecast[0].min}°",
                      style: TextStyle(fontSize: 15),
                    ),
                    VerticalDivider(color: Colors.grey[900]),
                    Text("Max: ${snapshot.data.forecast[0].max}°")
                  ],
                ),
                SizedBox(height: 5),
                Divider(color: Colors.grey[400]),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _getWeatherPrevision(
                        dayOfTheWeek: "${snapshot.data.forecast[1].weekday}",
                        icon: _provideWeatherIcon(
                            "${snapshot.data.forecast[1].condition}", 20),
                        temperatureMax:
                            " Max ${snapshot.data.forecast[1].max}°",
                        temperatureMin:
                            "Min ${snapshot.data.forecast[2].min}°"),
                    _getWeatherPrevision(
                        dayOfTheWeek: "${snapshot.data.forecast[2].weekday}",
                        icon: _provideWeatherIcon(
                            "${snapshot.data.forecast[2].condition}", 20),
                        temperatureMax: "Max ${snapshot.data.forecast[2].max}°",
                        temperatureMin:
                            "Min ${snapshot.data.forecast[2].min}°"),
                    _getWeatherPrevision(
                        dayOfTheWeek: "${snapshot.data.forecast[3].weekday}",
                        icon: _provideWeatherIcon(
                            "${snapshot.data.forecast[3].condition}", 20),
                        temperatureMax: "Max ${snapshot.data.forecast[3].max}°",
                        temperatureMin:
                            "Min ${snapshot.data.forecast[2].min}°"),
                    _getWeatherPrevision(
                        dayOfTheWeek: "${snapshot.data.forecast[4].weekday}",
                        icon: _provideWeatherIcon(
                            "${snapshot.data.forecast[4].condition}", 20),
                        temperatureMax: "Max ${snapshot.data.forecast[4].max}°",
                        temperatureMin: "Min ${snapshot.data.forecast[2].min}°")
                  ],
                ),
                Divider(color: Colors.grey[400]),
                Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Umidade: ${snapshot.data.humidity}%",
                      style: TextStyle(fontSize: 15),
                    ),
                    VerticalDivider(color: Colors.grey[900]),
                    Text("Ventos:  ${snapshot.data.windSpeedy}")
                  ],
                )),
              ]);
            }));
  }

  Widget _getWeatherPrevision(
      {String dayOfTheWeek,
      IconButton icon,
      String temperatureMax,
      String temperatureMin}) {
    return Column(children: <Widget>[
      Text(dayOfTheWeek),
      SizedBox(width: 50, height: 50, child: icon),
      Text(
        temperatureMin,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Text(
        temperatureMax,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ]);
  }

  IconButton _provideWeatherIcon(String condition, double size) {
    if (condition == 'storm')
      return _buildWeatherIconButton(
          WeatherIcons.storm_showers, Colors.grey[800], size);
    if (condition == 'snow')
      return _buildWeatherIconButton(WeatherIcons.snow, Colors.grey[800], size);
    if (condition == 'hail')
      return _buildWeatherIconButton(WeatherIcons.hail, Colors.grey[800], size);
    if (condition == 'rain')
      return _buildWeatherIconButton(
          WeatherIcons.rain, Colors.blueAccent, size);
    if (condition == 'fog')
      return _buildWeatherIconButton(WeatherIcons.fog, Colors.grey[800], size);
    if (condition == 'cloud')
      return _buildWeatherIconButton(
          WeatherIcons.cloud, Colors.blueAccent, size);
    if (condition == 'clear_day')
      return _buildWeatherIconButton(
          WeatherIcons.day_sunny, Colors.yellow, size);
    if (condition == 'cloudly_day')
      return _buildWeatherIconButton(
          WeatherIcons.day_cloudy, Colors.black54, size);
    if (condition == 'clear_night')
      return _buildWeatherIconButton(
          WeatherIcons.night_clear, Colors.blueAccent, size);
    if (condition == 'cloudly_night')
      return _buildWeatherIconButton(
          WeatherIcons.night_cloudy, Colors.blueAccent, size);

    return _buildWeatherIconButton(Icons.block, Colors.black54, size);
  }

  IconButton _buildWeatherIconButton(IconData icon, Color color, double size) {
    return IconButton(
        icon: BoxedIcon(
          icon,
          size: size,
          color: color,
        ),
        onPressed: () {});
  }

  @override
  void initState() {
    super.initState();
    _weatherBloc = WeatherBloc(widget.cityName);
    _weatherBloc.getUpdateWeather();
  }
}
