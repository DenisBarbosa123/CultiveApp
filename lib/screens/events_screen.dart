import 'package:cultiveapp/bloc/user_bloc.dart';
import 'package:cultiveapp/screens/search_events_screen.dart';
import 'package:cultiveapp/tabs/event_tabs.dart';
import 'package:cultiveapp/tabs/no_logged_in.dart';
import 'package:cultiveapp/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

import 'create_event_screen.dart';

class EventsScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  UserBloc _userBloc;
  @override
  void initState() {
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
                    title: Text("EVENTOS"),
                    centerTitle: true,
                    backgroundColor: Theme.of(context).primaryColor,
                    actions: <Widget>[
                      IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SearchEventsScreen(
                                    _userBloc.userInformation)));
                          })
                    ],
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CreateEventScreen(
                              _userBloc.userInformation["user"],
                              _userBloc.userInformation["token"])));
                    },
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.green,
                  ),
                  body: EventTabs(_userBloc.userInformation));
            } else {
              return Scaffold(
                  drawer: CustomDrawer(
                      userInformation: _userBloc.userInformation["user"]),
                  appBar: AppBar(
                    title: Text("EVENTOS"),
                    centerTitle: true,
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  body: NoLoggedInTabs());
            }
          }
        });
  }
}
