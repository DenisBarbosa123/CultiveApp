import 'package:cultiveapp/bloc/user_bloc.dart';
import 'package:cultiveapp/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  //controllers
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatedPasswordController =
      TextEditingController();

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
                          if (value.length != 6)
                            return "Informe um código válido de 5 carateres";
                          return null;
                        },
                        controller: _tokenController,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.code_rounded,
                            color: Colors.black,
                          ),
                          labelText: "Código",
                          hintStyle: TextStyle(color: Colors.black),
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
                    SizedBox(height: 20),
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
                          hintStyle: TextStyle(color: Colors.black),
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
                    TextFormField(
                        obscureText: true,
                        validator: (value) {
                          if (value.isEmpty) return "Campo Obrigatório";
                          if (value.length < 5)
                            return "Informe uma senha com mais de 5 caracteres";
                          return null;
                        },
                        controller: _passwordController,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.lock_outline,
                            color: Colors.black,
                          ),
                          labelText: "Nova senha",
                          hintStyle: TextStyle(color: Colors.black),
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
                    TextFormField(
                        obscureText: true,
                        validator: (value) {
                          if (value.isEmpty) return "Campo Obrigatório";
                          if (value != _passwordController.text)
                            return "Informe uma senha que seja igual ao campo anterior";
                          return null;
                        },
                        controller: _repeatedPasswordController,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.lock,
                            color: Colors.black,
                          ),
                          labelText: "Confirme sua nova senha",
                          hintStyle: TextStyle(color: Colors.black),
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
                      height: 10,
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
                                          title: Text("Alterar senha"),
                                          content: Text(
                                              "Deseja realmente alterar a senha da sua conta?"),
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
                                                  _userBloc.resetUserPassword(
                                                      username:
                                                          _emailController.text,
                                                      newPassword:
                                                          _passwordController
                                                              .text,
                                                      onSuccess: _onSuccess,
                                                      onInvalidEmail:
                                                          _onInvalidEmail,
                                                      onTokenExpired:
                                                          _onTokenExpired,
                                                      onTokenNotFound:
                                                          _onTokenNotFound,
                                                      onFail: _onGenericFail,
                                                      token: _tokenController
                                                          .text);
                                                },
                                                child: Text("Sim"))
                                          ],
                                        );
                                      });
                                }
                              },
                              color: Colors.green[900],
                              child: Text(
                                "CONFIRMAR",
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
                                Navigator.pop(context);
                              },
                              color: Colors.green[900],
                              child: Text(
                                "REENVIAR CÓDIGO",
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
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  void _onInvalidEmail() {
    _onFail("Nenhum usuário encontrado com email informado");
  }

  void _onTokenNotFound() {
    _onFail("Token não encontrado");
  }

  void _onTokenExpired() {
    _onFail(
        "Token informado está expirado, favor atualizar seu token para continuar o reset de senha");
  }

  void _onGenericFail() {
    _onFail("Ocorreu um erro durante reset de senha");
  }

  void _onFail(String erro) {
    pr.hide();
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(erro),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 3),
    ));
  }
}
