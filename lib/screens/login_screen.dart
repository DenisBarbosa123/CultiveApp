import 'file:///C:/Users/Denis%20Barbosa/AndroidStudioProjects/cultiveapp/lib/screens/reset_password_screen.dart';
import 'package:cultiveapp/screens/subscription/screen1.dart';
import 'package:cultiveapp/utils/textField_util.dart';
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
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => Screen1()));
                },
                color: Theme.of(context).primaryColor,
              )
            ],
          ),
          body: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Image.asset("assets/leaf.png", width: 200, height: 100),
              ),
              Text("CultiveApp",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              SizedBox(height: 40),
              TextFieldUtil.buildTextField("E-mail", Icon(Icons.person_outline, color: Colors.black,), null, Colors.black),
              SizedBox(height: 20),
              TextFieldUtil.buildTextField("Senha", Icon(Icons.lock_outline, color: Colors.black,), null, Colors.black),
              SizedBox(height: 20),
              Container(
                  padding: EdgeInsets.only(top:20, right: 10, left: 10),
                  child: ButtonTheme(
                      height: 50,
                      child: FlatButton(
                        onPressed: (){},
                        color: Colors.green[900],
                        child: Text(
                          "ENTRAR",
                          style: TextStyle(color: Colors.white),
                        ),
                        disabledColor: Colors.black54,
                        disabledTextColor: Colors.white,
                      )
                  )
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
                padding: EdgeInsets.only(top: 30, bottom: 10),
              )),
            ],
          ));
  }
}
