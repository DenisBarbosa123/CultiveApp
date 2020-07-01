import 'package:cultiveapp/tabs/news_tabs.dart';
import 'package:cultiveapp/tabs/quotation_tabs.dart';
import 'package:cultiveapp/tabs/weather_tabs.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text("DASHBOARD"),
            centerTitle: true,
            backgroundColor: Theme.of(context).primaryColor,
            bottom: TabBar(indicatorColor: Colors.white, tabs: [
              Tab(text: "Clima", icon: Icon(Icons.ac_unit)),
              Tab(text: "Cotação", icon: Icon(Icons.monetization_on)),
              Tab(text: "Notícias", icon: Icon(Icons.announcement)),
            ]),
          ),
          body: TabBarView(
              children: [WeatherTabs(), QuotationTabs(), NewsTabs()]),
        ));
  }
}
