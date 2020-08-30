import 'package:cultiveapp/bloc/user_bloc.dart';
import 'package:cultiveapp/screens/presentation_screen.dart';
import 'package:cultiveapp/tabs/news_tabs.dart';
import 'package:cultiveapp/tabs/quotation_tabs.dart';
import 'package:cultiveapp/tabs/weather_tabs.dart';
import 'package:cultiveapp/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  PageController _pageController;
  UserBloc _userBloc;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _userBloc = UserBloc();
    _userBloc.loadCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          StreamBuilder<AuthenticationStatus>(
            stream: _userBloc.loginOutput,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.green)),
                );
              } else {
                if (snapshot.data == AuthenticationStatus.authenticated) {
                  return DefaultTabController(
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
                            Tab(
                                text: "Cotação",
                                icon: Icon(Icons.monetization_on)),
                            Tab(
                                text: "Notícias",
                                icon: Icon(Icons.announcement)),
                          ]),
                        ),
                        body: TabBarView(children: [
                          WeatherTabs(),
                          QuotationTabs(),
                          NewsTabs()
                        ]),
                      ));
                } else {
                  return PresentationScreen(_pageController);
                }
              }
            },
          )
        ]);
  }
}
