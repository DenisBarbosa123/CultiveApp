import 'package:cultiveapp/widgets/logo_cultive.dart';
import 'package:flutter/material.dart';

import '../home_screen.dart';

class SuccessScreen extends StatefulWidget {
  final String name;
  SuccessScreen(this.name);
  @override
  _SuccessScreenState createState() => _SuccessScreenState(this.name);
}

class _SuccessScreenState extends State<SuccessScreen> {
  final String name;
  _SuccessScreenState(this.name);

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5)).then((_) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: <Widget>[
          LogoCultive(),
          SizedBox(height: 70),
          Center(
            child: Text("CADASTRO REALIZADO COM SUCESSO"),
          ),
          Center(
            child: Text("Seja Bem-vindo, $name!"),
          ),
          SizedBox(height: 70),
          Center(
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.green[900],
              child: Icon(Icons.check, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
