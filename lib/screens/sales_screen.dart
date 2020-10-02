import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cultiveapp/bloc/user_bloc.dart';
import 'package:cultiveapp/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class SalesScreen extends StatefulWidget {
  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  UserBloc _userBloc;
  @override
  void initState(){
    super.initState();
    _userBloc = BlocProvider.getBloc<UserBloc>();
    _userBloc.loadCurrentUser();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(
          userInformation: _userBloc.userInformation["user"]),
      appBar: AppBar(
        title: Text("VENDAS"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        color: Colors.yellow,
      ),
    );
  }
}
