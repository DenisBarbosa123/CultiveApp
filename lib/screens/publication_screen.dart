import 'package:cultiveapp/bloc/user_bloc.dart';
import 'package:cultiveapp/tabs/no_logged_in.dart';
import 'package:cultiveapp/tabs/publication_tabs.dart';
import 'package:cultiveapp/widgets/custom_drawer.dart';
import "package:flutter/material.dart";

import 'create_publication_screen.dart';

class PublicationScreen extends StatefulWidget {
  @override
  _PublicationScreenState createState() => _PublicationScreenState();
}

class _PublicationScreenState extends State<PublicationScreen> {
  UserBloc _userBloc;
  @override
  void initState(){
    super.initState();
    _userBloc = UserBloc();
    _userBloc.loadCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthenticationStatus>(
        stream: _userBloc.loginOutput,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
                color: Colors.white,
                child: Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.green))));
          } else {
            if (snapshot.data == AuthenticationStatus.authenticated) {
              return Scaffold(
                  drawer: CustomDrawer(
                      userInformation: _userBloc.userInformation["user"]),
                  appBar: AppBar(
                    title: Text("PUBLICAÇÕES"),
                    centerTitle: true,
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CreatePublicationScreen(
                              _userBloc.userInformation["user"],
                              _userBloc.userInformation["token"])));
                    },
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.green,
                  ),
                  body: PublicationTabs());
            } else {
              return Scaffold(
                  drawer: CustomDrawer(
                      userInformation: _userBloc.userInformation["user"]),
                  appBar: AppBar(
                    title: Text("PUBLICAÇÕES"),
                    centerTitle: true,
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  body: NoLoggedInTabs());
            }
          }
        });
  }
}
