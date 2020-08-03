class Weather {
  int temp;
  String date;
  String description;
  String city;
  int humidity;
  String conditionSlug;
  String windSpeedy;
  List<Forecast> forecast;

  Weather(
      {this.temp,
      this.date,
      this.description,
      this.city,
      this.conditionSlug,
      this.humidity,
      this.windSpeedy,
      this.forecast});

  Weather.fromJson(Map<String, dynamic> json) {
    temp = json['temp'];
    date = json['date'];
    description = json['description'];
    conditionSlug = json['condition_slug'];
    city = json['city'];
    humidity = json['humidity'];
    windSpeedy = json['wind_speedy'];
    if (json['forecast'] != null) {
      forecast = new List<Forecast>();
      json['forecast'].forEach((v) {
        forecast.add(new Forecast.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['temp'] = this.temp;
    data['date'] = this.date;
    data['description'] = this.description;
    data['city'] = this.city;
    data['humidity'] = this.humidity;
    data['currently '] = this.conditionSlug;
    data['wind_speedy'] = this.windSpeedy;
    if (this.forecast != null) {
      data['forecast'] = this.forecast.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Forecast {
  String date;
  String weekday;
  int max;
  int min;
  String description;
  String condition;

  Forecast(
      {this.date,
      this.weekday,
      this.max,
      this.min,
      this.description,
      this.condition});

  Forecast.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    weekday = json['weekday'];
    max = json['max'];
    min = json['min'];
    description = json['description'];
    condition = json['condition'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['weekday'] = this.weekday;
    data['max'] = this.max;
    data['min'] = this.min;
    data['description'] = this.description;
    data['condition'] = this.condition;
    return data;
  }
}
