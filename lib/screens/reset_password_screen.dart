import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatelessWidget {

  //controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatedPasswordController = TextEditingController();

  //global-key
  final _formKey = GlobalKey<FormState>();

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
            Padding(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if(value.isEmpty) return "Campo Obrigatório";
                          if(!value.contains("@")) return "Informe um e-mail válido";
                          return null;
                        },
                        controller: _emailController,
                        decoration: InputDecoration(
                          icon: Icon(Icons.person_outline, color: Colors.black,),
                          labelText: "E-mail",
                          hintStyle: TextStyle(color: Colors.black),
                          labelStyle: TextStyle(color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 1.0),
                          ),
                        )
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                        obscureText: true,
                        validator: (value) {
                          if(value.isEmpty) return "Campo Obrigatório";
                          if(value.length < 5) return "Informe uma senha com mais de 5 caracteres";
                          return null;
                        },
                        controller: _passwordController,
                        decoration: InputDecoration(
                          icon: Icon(Icons.lock_outline, color: Colors.black,),
                          labelText: "Senha",
                          hintStyle: TextStyle(color: Colors.black),
                          labelStyle: TextStyle(color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 1.0),
                          ),
                        )
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                        obscureText: true,
                        validator: (value) {
                          if(value.isEmpty) return "Campo Obrigatório";
                          if(value != _passwordController.text) return "Informe uma senha que seja igual ao campo anterior";
                          return null;
                        },
                        controller: _repeatedPasswordController,
                        decoration: InputDecoration(
                          icon: Icon(Icons.lock, color: Colors.black,),
                          labelText: "Nova senha novamente",
                          hintStyle: TextStyle(color: Colors.black),
                          labelStyle: TextStyle(color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 1.0),
                          ),
                        )
                    ),
                    SizedBox(height: 10,),
                    Container(
                        padding: EdgeInsets.only(top:10, right: 10, left: 10),
                        child: ButtonTheme(
                            minWidth: 200,
                            height: 50,
                            child: FlatButton(
                              onPressed: (){
                                if(_formKey.currentState.validate()){
                                  debugPrint("Sucesso!");
                                }
                              },
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
                ),
              ),
            ),
          ],
        ));
  }
}
