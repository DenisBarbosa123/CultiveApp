import 'package:cultiveapp/bloc/user_bloc.dart';
import 'package:cultiveapp/model/user_model.dart';
import 'package:cultiveapp/screens/events_screen.dart';
import 'package:cultiveapp/screens/home_screen.dart';
import 'package:cultiveapp/screens/login_screen.dart';
import 'package:cultiveapp/screens/profile_screen.dart';
import 'package:cultiveapp/screens/publication_screen.dart';
import 'package:cultiveapp/screens/sales_screen.dart';
import "package:flutter/material.dart";

// ignore: must_be_immutable
class CustomDrawer extends StatefulWidget {
  User userInformation;
  CustomDrawer({this.userInformation});
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  var _userBloc = UserBloc();
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
                              top: 0.0,
                              left: 0.0,
                              child: Text(
                                "Bem-vindo\nao\nCultiveApp!",
                                style: TextStyle(
                                    fontSize: 23.0,
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
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold)),
                                  GestureDetector(
                                    child: Text(
                                      "Entre ou cadastre-se >",
                                      style: TextStyle(
                                          color: Colors.blue[500],
                                          fontSize: 14.0,
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
              ListTile(
                  focusColor: Colors.black,
                  leading: Icon(
                    Icons.home,
                    color: Colors.black,
                    size: 32.0,
                  ),
                  title: Text(
                    "Página Principal",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  }),
              ListTile(
                  focusColor: Colors.black,
                  leading: Icon(
                    Icons.rss_feed,
                    color: Colors.black,
                    size: 32.0,
                  ),
                  title: Text(
                    "Publicações",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => PublicationScreen()));
                  }),
              ListTile(
                  focusColor: Colors.black,
                  leading: Icon(
                    Icons.event_note,
                    color: Colors.black,
                    size: 32.0,
                  ),
                  title: Text(
                    "Eventos",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => EventsScreen()));
                  }),
              ListTile(
                  focusColor: Colors.black,
                  leading: Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                    size: 32.0,
                  ),
                  title: Text(
                    "Vendas",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => SalesScreen()));
                  }),
              widget.userInformation != null
                  ? Column(
                      children: [
                        Divider(color: Colors.grey),
                        ListTile(
                            leading: Icon(
                              Icons.account_box,
                              color: Colors.black,
                            ),
                            title: Text("Conta"),
                            subtitle: Text("Meu perfil"),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ProfileScreen(widget.userInformation)));
                            }),
                        ListTile(
                          leading: Icon(
                            Icons.cancel,
                            color: Colors.black,
                          ),
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
