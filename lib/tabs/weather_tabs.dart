import 'package:cultiveapp/bloc/weather_bloc.dart';
import 'package:cultiveapp/model/weather_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherTabs extends StatefulWidget {
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
          builder: (context, snapshot) {
            if(!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                ),
              );
            }
            return Column(children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: Text("${snapshot.data.city}", style: TextStyle(fontSize: 25.0)),
              ),
              Text("${snapshot.data.description}",
                  style: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic)),
              SizedBox(
                width: 120,
                height: 100,
                child: _provideWeatherIcon("${snapshot.data.condition_slug}", 60),
              ),
              Text(
                "${snapshot.data.temp}°",
                style: TextStyle(fontSize: 60.0, fontWeight: FontWeight.bold),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Min: ${snapshot.data.forecast[0].min}°", style: TextStyle(fontSize: 15),),
                    VerticalDivider(color: Colors.grey[900]),
                    Text("Max: ${snapshot.data.forecast[0].max}°")
                  ],
                )
              ),
              SizedBox(height: 5),
              Divider(color: Colors.grey[400]),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(right: 25, left: 25),
                child: Row(
                  children: <Widget>[
                    _getWeatherPrevision(
                        dayOfTheWeek: "${snapshot.data.forecast[2].weekday}",
                        icon: _provideWeatherIcon("${snapshot.data.forecast[2].condition}", 20),
                        temperature: "${snapshot.data.forecast[2].max}°"),
                    _getWeatherPrevision(
                        dayOfTheWeek: "${snapshot.data.forecast[3].weekday}",
                        icon: _provideWeatherIcon("${snapshot.data.forecast[3].condition}", 20),
                        temperature: "${snapshot.data.forecast[3].max}°"),
                    _getWeatherPrevision(
                        dayOfTheWeek: "${snapshot.data.forecast[4].weekday}",
                        icon: _provideWeatherIcon("${snapshot.data.forecast[4].condition}", 20),
                        temperature: "${snapshot.data.forecast[4].max}°"),
                    _getWeatherPrevision(
                        dayOfTheWeek: "${snapshot.data.forecast[5].weekday}",
                        icon: _provideWeatherIcon("${snapshot.data.forecast[5].condition}", 20),
                        temperature: "${snapshot.data.forecast[5].max}°"),
                    _getWeatherPrevision(
                        dayOfTheWeek: "${snapshot.data.forecast[6].weekday}",
                        icon: _provideWeatherIcon("${snapshot.data.forecast[6].condition}", 20),
                        temperature: "${snapshot.data.forecast[6].max}°"),
                    _getWeatherPrevision(
                        dayOfTheWeek: "${snapshot.data.forecast[7].weekday}",
                        icon: _provideWeatherIcon("${snapshot.data.forecast[7].condition}", 20),
                        temperature: "${snapshot.data.forecast[7].max}°"),
                  ],
                ),
              ),
              Divider(color: Colors.grey[400]),
              Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Umidade: ${snapshot.data.humidity}%", style: TextStyle(fontSize: 15),),
                      VerticalDivider(color: Colors.grey[900]),
                      Text("Ventos:  ${snapshot.data.windSpeedy}")
                    ],
                  )
              ),
            ]);
          }
        ));
  }

  Widget _getWeatherPrevision(
      {String dayOfTheWeek, IconButton icon, String temperature}) {
    return Column(children: <Widget>[
      Text(dayOfTheWeek),
      SizedBox(
        width: 50,
        height: 50,
        child: icon
      ),
      Text(
        temperature,
        style: TextStyle(fontWeight: FontWeight.bold),
      )
    ]);
  }

  IconButton _provideWeatherIcon(String condition, double size){
    if(condition == 'storm') return _buildWeatherIconButton(WeatherIcons.storm_warning, Colors.grey[800], size);
    if(condition == 'snow') return _buildWeatherIconButton(WeatherIcons.snow, Colors.grey[800], size);
    if(condition == 'hail') return _buildWeatherIconButton(WeatherIcons.hail, Colors.grey[800], size);
    if(condition == 'rain') return _buildWeatherIconButton(WeatherIcons.rain, Colors.blueAccent, size);
    if(condition == 'fog') return _buildWeatherIconButton(WeatherIcons.fog, Colors.grey[800], size);
    if(condition == 'cloud') return _buildWeatherIconButton(WeatherIcons.cloud, Colors.blueAccent, size);
    if(condition == 'clear_day') return _buildWeatherIconButton(WeatherIcons.day_sunny, Colors.yellow, size);
    if(condition == 'cloudly_day') return _buildWeatherIconButton(WeatherIcons.day_cloudy, Colors.black54, size);
    if(condition == 'clear_night') return _buildWeatherIconButton(WeatherIcons.night_clear, Colors.blueAccent, size);
    if(condition == 'cloudly_night') return _buildWeatherIconButton(WeatherIcons.night_cloudy, Colors.blueAccent, size);

    return _buildWeatherIconButton(Icons.block, Colors.black54, size);
  }

  IconButton _buildWeatherIconButton(IconData icon, Color color, double size) {
    return IconButton(
      icon: BoxedIcon(
        icon,
        size: size,
        color: color,
      ),
      onPressed: (){}
    );
  }

  @override
  void initState() {
    super.initState();
    _weatherBloc = WeatherBloc();
    _weatherBloc.getUpdateWeather();
  }
}
