import 'dart:convert';

import 'package:cultiveapp/model/user_model.dart';
import 'package:cultiveapp/screens/edit_profile_screen.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final User user;

  const ProfileScreen(this.user);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                        ? MemoryImage(base64.decode(user.fotoPerfil))
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
                  )
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
