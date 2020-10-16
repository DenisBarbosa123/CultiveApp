import 'package:cultiveapp/bloc/user_bloc.dart';
import 'package:cultiveapp/screens/reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class RequestUpdatePasswordScreen extends StatefulWidget {
  @override
  _RequestUpdatePasswordScreenState createState() =>
      _RequestUpdatePasswordScreenState();
}

class _RequestUpdatePasswordScreenState
    extends State<RequestUpdatePasswordScreen> {
  //controllers
  final TextEditingController _emailController = TextEditingController();

  //global-key
  final _formKey = GlobalKey<FormState>();

  //UserBloc
  final _userBloc = UserBloc();

  //ScaffoldKey
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  //ProgressDialog
  ProgressDialog pr;

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      textDirection: TextDirection.rtl,
      isDismissible: true,
    );

    pr.style(
      message: 'Por favor, aguarde',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      progressWidgetAlignment: Alignment.center,
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
    return Scaffold(
        key: _scaffoldKey,
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
                          if (value.isEmpty) return "Campo Obrigatório";
                          if (!value.contains("@"))
                            return "Informe um e-mail válido";
                          return null;
                        },
                        controller: _emailController,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.person_outline,
                            color: Colors.black,
                          ),
                          labelText: "E-mail",
                          hintText:
                              "E-mail que será enviado código para reset de senha",
                          hintStyle:
                              TextStyle(color: Colors.black54, fontSize: 12),
                          labelStyle: TextStyle(color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                          ),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        padding: EdgeInsets.only(top: 10, right: 10, left: 10),
                        child: ButtonTheme(
                            minWidth: 200,
                            height: 50,
                            child: FlatButton(
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Enviar código!"),
                                          content: Text(
                                              "Deseja realmente enviar o código de troca de senha para e-mail ${_emailController.text} ?"),
                                          actions: <Widget>[
                                            FlatButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Cancelar")),
                                            FlatButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  pr.show();
                                                  _userBloc
                                                      .requestUpdatePassword(
                                                          email:
                                                              _emailController
                                                                  .text,
                                                          onSuccess: _onSuccess,
                                                          onFail: _onFail);
                                                },
                                                child: Text("Sim"))
                                          ],
                                        );
                                      });
                                }
                              },
                              color: Colors.green[900],
                              child: Text(
                                "ENVIAR CÓDIGO",
                                style: TextStyle(color: Colors.white),
                              ),
                              disabledColor: Colors.black54,
                              disabledTextColor: Colors.white,
                            ))),
                    Container(
                        padding: EdgeInsets.only(top: 10, right: 10, left: 10),
                        child: ButtonTheme(
                            minWidth: 200,
                            height: 50,
                            child: FlatButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ResetPasswordScreen()));
                              },
                              color: Colors.green[900],
                              child: Text(
                                "JÁ TEM O CÓDIGO? CLIQUE AQUI",
                                style: TextStyle(color: Colors.white),
                              ),
                              disabledColor: Colors.black54,
                              disabledTextColor: Colors.white,
                            ))),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  void _onSuccess() {
    pr.hide();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ResetPasswordScreen()));
  }

  void _onFail() {
    pr.hide();
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Erro durante a requisição do token de reset de senha"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 3),
    ));
  }
}
