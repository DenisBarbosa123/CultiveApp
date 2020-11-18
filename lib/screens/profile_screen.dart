import 'package:cultiveapp/bloc/user_bloc.dart';
import 'package:cultiveapp/model/user_model.dart';
import 'package:cultiveapp/screens/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'home_screen.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  ProfileScreen(this.user);
  @override
  _ProfileScreenState createState() => _ProfileScreenState(user);
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<String> options = ['Excluir Conta'];
  final User user;
  final _userBloc = UserBloc();
  ProgressDialog pr;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  _ProfileScreenState(this.user);
  void handleClick(String option) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Excluir conta"),
            content: Text("Deseja excluir sua conta?"),
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
                    _userBloc.deleteUser(
                        user: this.user,
                        onSuccess: _onSuccess,
                        onFail: _onFail);
                  },
                  child: Text("Sim"))
            ],
          );
        });
  }

  void _onSuccess() {
    pr.hide();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (Route<dynamic> route) => false);
  }

  void _onFail() {
    pr.hide();
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao excluir usuário"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 3),
    ));
  }

  void configureProgressDialog(BuildContext context) {
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
  }

  @override
  Widget build(BuildContext context) {
    configureProgressDialog(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (context) {
              return options.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
        title: Text("PERFIL"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: user.fotoPerfil != null
                        ? NetworkImage(user.fotoPerfil)
                        : AssetImage("assets/person.png"),
                    radius: 50,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${user.nome}",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                      Text("${user.email}",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400)),
                      SizedBox(
                        height: 10,
                      ),
                      OutlineButton(
                        borderSide:
                            BorderSide(color: Colors.green[700], width: 2),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  EditProfileScreen(this.user)));
                        },
                        child: Text(
                          "Editar Perfil",
                          style: TextStyle(
                              color: Colors.green[700],
                              fontWeight: FontWeight.w700),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey[500],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Column(
                children: [
                  Text(
                    "Informações",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
                    textAlign: TextAlign.center,
                  ),
                  ListTile(
                    leading: Icon(Icons.phone),
                    title: Text("Contato"),
                    subtitle: Text("${user.celular}"),
                  ),
                  ListTile(
                    leading: Icon(Icons.home),
                    title: Text("Localização"),
                    subtitle: Text(
                        "${user.localizacao.bairro}, ${user.localizacao.cidade}, ${user.localizacao.estado}"),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
