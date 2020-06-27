import 'package:cultiveapp/screens/login_screen.dart';
import 'package:cultiveapp/tiles/drawer_tile.dart';
import "package:flutter/material.dart";
class CustomDrawer extends StatelessWidget {

  final PageController pageController;
  CustomDrawer(this.pageController);

  @override
  Widget build(BuildContext context) {
    Widget _buildDrawerBack() => Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 211, 236, 241),
                Colors.green[300]
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter
          )
      ),
    );

    return Drawer(
      child: Stack(
        children: <Widget>[
          _buildDrawerBack(),
          ListView(
            padding: EdgeInsets.only(left: 32.0, top: 16.0),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 8.0),
                padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                height: 170.0,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                        top: 8.0,
                        left: 0.0,
                        child: Text("Bem-vindo\nao\nCultiveApp!",
                          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                        )
                    ),
                    Positioned(
                        left: 0.0,
                        bottom: 0.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Olá, visitante!",
                                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)
                            ),
                            GestureDetector(
                              child: Text(
                                "Entre ou cadastre-se >",
                                style: TextStyle(
                                    color:Theme.of(context).primaryColor,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => LoginScreen())
                                  );
                              },
                            )
                          ],
                        )
                    )
                  ],
                ),
              ),
              Divider(color: Colors.white),
              DrawerTile(Icons.dashboard, "Dashboard", pageController, 0),
              DrawerTile(Icons.rss_feed, "Publicações", pageController, 1),
              DrawerTile(Icons.event_available, "Eventos", pageController, 2),
              DrawerTile(Icons.shopping_cart, "Vendas", pageController, 3),
            ],
          )
        ],
      ),
    );
  }
}
