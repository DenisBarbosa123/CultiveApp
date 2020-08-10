import 'package:cultiveapp/utils/textField_util.dart';
import 'package:cultiveapp/widgets/input_widget.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text("ESQUECEU A SENHA"),
            centerTitle: true),
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
            SizedBox(height: 20),
            TextFieldUtil.buildTextField("E-mail", Icon(Icons.person_outline, color: Colors.black,), null, Colors.black),
            SizedBox(height: 10),
            TextFieldUtil.buildTextField("Nova Senha", Icon(Icons.lock, color: Colors.black,), null, Colors.black),
            SizedBox(height: 10),
            TextFieldUtil.buildTextField("Repita a nova senha", Icon(Icons.lock_outline, color: Colors.black,), null, Colors.black),
            SizedBox(height: 30),
            Container(
                padding: EdgeInsets.only(top:20, right: 10, left: 10),
                child: ButtonTheme(
                    height: 50,
                    child: FlatButton(
                      onPressed: (){},
                      color: Colors.green[900],
                      child: Text(
                        "CONFIRMAR",
                        style: TextStyle(color: Colors.white),
                      ),
                      disabledColor: Colors.black54,
                      disabledTextColor: Colors.white,
                    )
                )
            ),
          ],
        ));
  }
}
