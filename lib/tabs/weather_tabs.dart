import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherTabs extends StatefulWidget {
  @override
  _WeatherTabsState createState() => _WeatherTabsState();
}

class _WeatherTabsState extends State<WeatherTabs> {

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
        child: Column(children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: Text("Pouso Alegre - MG", style: TextStyle(fontSize: 25.0)),
          ),
          Text("Ensolarado",
              style: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic)),
          SizedBox(
            width: 120,
            height: 100,
            child: IconButton(
              icon: BoxedIcon(
                WeatherIcons.day_sunny,
                size: 60,
                color: Colors.yellow,
              ),
              onPressed: () {},
            ),
          ),
          Text(
            "25°",
            style: TextStyle(fontSize: 60.0, fontWeight: FontWeight.bold),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Min: 17°", style: TextStyle(fontSize: 15),),
                VerticalDivider(color: Colors.grey[900]),
                Text("Max: 30°")
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
                    dayOfTheWeek: "Sex",
                    icon: WeatherIcons.day_sunny,
                    temperature: "25°"),
                _getWeatherPrevision(
                    dayOfTheWeek: "Sab",
                    icon: WeatherIcons.day_sunny,
                    temperature: "25°"),
                _getWeatherPrevision(
                    dayOfTheWeek: "Dom",
                    icon: WeatherIcons.day_sunny,
                    temperature: "25°"),
                _getWeatherPrevision(
                    dayOfTheWeek: "Seg",
                    icon: WeatherIcons.day_sunny,
                    temperature: "25°"),
                _getWeatherPrevision(
                    dayOfTheWeek: "Ter",
                    icon: WeatherIcons.day_sunny,
                    temperature: "25°"),
                _getWeatherPrevision(
                    dayOfTheWeek: "Ter",
                    icon: WeatherIcons.day_sunny,
                    temperature: "25°"),
              ],
            ),
          ),
          Divider(color: Colors.grey[400]),
          Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Umidade: 17°", style: TextStyle(fontSize: 15),),
                  VerticalDivider(color: Colors.grey[900]),
                  Text("Ventos: 30°")
                ],
              )
          ),
        ]));
  }

  Widget _getWeatherPrevision(
      {String dayOfTheWeek, IconData icon, String temperature}) {
    return Column(children: <Widget>[
      Text(dayOfTheWeek),
      SizedBox(
        width: 50,
        height: 50,
        child: IconButton(
          icon: BoxedIcon(icon, size: 20),
          onPressed: (){},
        ),
      ),
      Text(
        temperature,
        style: TextStyle(fontWeight: FontWeight.bold),
      )
    ]);
  }
}
