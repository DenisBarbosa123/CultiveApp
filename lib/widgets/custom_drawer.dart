import 'package:cultiveapp/bloc/user_bloc.dart';
import 'package:cultiveapp/model/user_model.dart';
import 'package:cultiveapp/screens/home_screen.dart';
import 'package:cultiveapp/screens/login_screen.dart';
import 'package:cultiveapp/screens/profile_screen.dart';
import 'package:cultiveapp/tiles/drawer_tile.dart';
import "package:flutter/material.dart";

// ignore: must_be_immutable
class CustomDrawer extends StatefulWidget {
  PageController pageController;
  User userInformation;
  CustomDrawer(this.pageController, {this.userInformation});
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  UserBloc _userBloc = UserBloc();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              widget.userInformation != null
                  ? UserAccountsDrawerHeader(
                      accountName: Text(
                        "${widget.userInformation.nome}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                      accountEmail: Text(
                        "${widget.userInformation.email}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                      ),
                      currentAccountPicture: CircleAvatar(
                        foregroundColor: Colors.white,
                        radius: 30.0,
                        backgroundImage: widget.userInformation.fotoPerfil !=
                                null
                            ? NetworkImage(widget.userInformation.fotoPerfil)
                            : AssetImage("assets/person.png"),
                        backgroundColor:
                            widget.userInformation.fotoPerfil != null
                                ? Colors.transparent
                                : Colors.white,
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.only(bottom: 8.0),
                      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                      height: 170.0,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                              top: 8.0,
                              left: 0.0,
                              child: Text(
                                "Bem-vindo\nao\nCultiveApp!",
                                style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold),
                              )),
                          Positioned(
                              left: 0.0,
                              bottom: 0.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Olá, visitante!",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold)),
                                  GestureDetector(
                                    child: Text(
                                      "Entre ou cadastre-se >",
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginScreen()));
                                    },
                                  )
                                ],
                              ))
                        ],
                      ),
                    ),
              widget.userInformation != null
                  ? DrawerTile(Icons.home, "Home", widget.pageController, 0)
                  : Container(),
              DrawerTile(
                  Icons.rss_feed, "Publicações", widget.pageController, 1),
              DrawerTile(
                  Icons.event_available, "Eventos", widget.pageController, 2),
              DrawerTile(
                  Icons.shopping_cart, "Vendas", widget.pageController, 3),
              widget.userInformation != null
                  ? Column(
                      children: [
                        Divider(color: Colors.grey),
                        ListTile(
                            leading: Icon(Icons.account_box),
                            title: Text("Conta"),
                            subtitle: Text("Meu perfil"),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ProfileScreen(widget.userInformation)));
                            }),
                        ListTile(
                          leading: Icon(Icons.cancel),
                          title: Text("Sair"),
                          subtitle: Text("Logout da conta"),
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Sair da conta"),
                                    content: Text(
                                        "Deseja realmente sair da sua conta?"),
                                    actions: <Widget>[
                                      FlatButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("Cancelar")),
                                      FlatButton(
                                          onPressed: () {
                                            _userBloc.logout();
                                            Navigator.pop(context);
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            HomeScreen()));
                                          },
                                          child: Text("Sim"))
                                    ],
                                  );
                                });
                          },
                        )
                      ],
                    )
                  : Container()
            ],
          )
        ],
      ),
    );
  }
}
