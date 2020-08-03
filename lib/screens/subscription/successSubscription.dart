import 'package:cultiveapp/widgets/logo_cultive.dart';
import 'package:flutter/material.dart';

class SuccessSubscription extends StatelessWidget {
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
            child: Text("SEJA BEM VINDO, DENIS!"),
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


