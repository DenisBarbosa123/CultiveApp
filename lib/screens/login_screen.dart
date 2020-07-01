import 'package:cultiveapp/screens/reset_password_screen.dart';
import 'package:cultiveapp/widgets/input_widget.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text("LOGIN"),
          centerTitle: true,
          actions: <Widget>[
            RaisedButton(
              child: Text("CADASTRE-SE"),
              onPressed: () {},
              color: Theme.of(context).primaryColor,
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
              hint: "E-mail",
              obscure: false,
            ),
            InputField(
              icon: Icons.lock_outline,
              hint: "Senha",
              obscure: true,
            ),
            SizedBox(height: 30),
            SizedBox(
              height: 45.0,
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
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ResetPasswordScreen()));
              },
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
