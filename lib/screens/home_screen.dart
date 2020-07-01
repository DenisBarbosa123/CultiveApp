import 'package:cultiveapp/tabs/news_tabs.dart';
import 'package:cultiveapp/tabs/quotation_tabs.dart';
import 'package:cultiveapp/tabs/weather_tabs.dart';
import 'package:cultiveapp/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          DefaultTabController(
              length: 3,
              child: Scaffold(
                drawer: CustomDrawer(_pageController),
                appBar: AppBar(
                  title: Text(
                    "DASHBOARD",
                  ),
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
              )),
        ]);
  }
}
