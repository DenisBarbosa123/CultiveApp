import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherTabs extends StatefulWidget {
  @override
  _WeatherTabsState createState() => _WeatherTabsState();
}

class _WeatherTabsState extends State<WeatherTabs> {

  Widget _getWeatherPrevision({String dayOfTheWeek, IconData icon, String temperature}){
    return Column(
        children: <Widget>[
          Text(dayOfTheWeek),
          SizedBox(
              width: 50,
              height: 50,
              child: IconButton(
              icon: BoxedIcon(icon, size: 20),
              onPressed: () {},
            ),
          ),
          Text(
            temperature,
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ]
    );
  }
  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: Text("Pouso Alegre - MG", style: TextStyle(fontSize: 25.0)),
            ),
            Text("Ensolarado", style: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic)),
            SizedBox(
              width: 120,
              height: 100,
              child: IconButton(
                icon: BoxedIcon(WeatherIcons.day_sunny, size: 60,),
                onPressed: () {},
              ),
            ),
            Text(
              "25°",
              style: TextStyle(
                fontSize: 60.0,
                fontWeight: FontWeight.bold
              ),
            ),
            Divider(color: Colors.grey[400]),
            SizedBox(height: 10),
            Row(
              children: <Widget>[
               _getWeatherPrevision(
                 dayOfTheWeek: "Sex",
                 icon: WeatherIcons.day_sunny,
                 temperature: "25°"
               ),
                _getWeatherPrevision(
                    dayOfTheWeek: "Sab",
                    icon: WeatherIcons.day_sunny,
                    temperature: "25°"
                ),
                _getWeatherPrevision(
                    dayOfTheWeek: "Dom",
                    icon: WeatherIcons.day_sunny,
                    temperature: "25°"
                ),
                _getWeatherPrevision(
                    dayOfTheWeek: "Seg",
                    icon: WeatherIcons.day_sunny,
                    temperature: "25°"
                ),
                _getWeatherPrevision(
                    dayOfTheWeek: "Ter",
                    icon: WeatherIcons.day_sunny,
                    temperature: "25°"
                ),
                _getWeatherPrevision(
                    dayOfTheWeek: "Qua",
                    icon: WeatherIcons.day_sunny,
                    temperature: "25°"
                ),
                _getWeatherPrevision(
                    dayOfTheWeek: "Qui",
                    icon: WeatherIcons.day_sunny,
                    temperature: "25°"
                ),
              ],
            )
        ]

        ));

  }

}
