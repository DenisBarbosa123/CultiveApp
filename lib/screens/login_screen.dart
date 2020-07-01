import 'package:cultiveapp/utils/color_util.dart';
import 'package:cultiveapp/widgets/input_widget.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final Color _backColor = HexColor("6FCF97");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: _backColor,
        appBar: AppBar(
          backgroundColor: _backColor,
          title: Text("LOGIN"),
          centerTitle: true,
          actions: <Widget>[
            RaisedButton(
              child: Text("CADASTRE-SE", style: TextStyle(color: Colors.white)),
              onPressed: () {},
              color: _backColor,
            )
          ],
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Image.asset("assets/leaf.png", width: 250, height: 150),
            ),
            Text("CultiveApp",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            SizedBox(height: 20),
            InputField(
              icon: Icons.person_outline,
              hint: "Usuário",
              obscure: false,
            ),
            InputField(
              icon: Icons.lock_outline,
              hint: "Senha",
              obscure: true,
            ),
            SizedBox(height: 30),
            SizedBox(
              height: 40.0,
              child: RaisedButton(
                onPressed: () {},
                child: Text(
                  "Entrar",
                  style: TextStyle(fontSize: 18.0),
                ),
                textColor: Colors.white,
                color: Colors.green[900],
                disabledColor: Colors.grey,
              ),
            ),
            Center(
                child: FlatButton(
              onPressed: () {},
              child: Text(
                "Esqueceu sua senha?",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
              padding: EdgeInsets.only(top: 40),
            )),
          ],
        ));
  }
}
