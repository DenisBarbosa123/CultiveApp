import 'dart:io';

import 'package:cultiveapp/model/user_model.dart';
import 'package:cultiveapp/screens/subscription/successSubscription.dart';
import 'package:cultiveapp/utils/CircleUtil.dart';
import 'package:cultiveapp/utils/base64Convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class Screen3 extends StatefulWidget {
  //User
  User user;
  Screen3({this.user});
  @override
  _Screen3State createState() => _Screen3State(user: user);
}

class _Screen3State extends State<Screen3> {

  //Topic List
  final _topicList = ["Plantio", "Criação de gado", "Sementes"];
  final List<String> _userTopicList = List<String>();

  //User
  User user;

  //Profile image
  PickedFile image;

  ImagePicker _picker = ImagePicker();

  //Constructor
  _Screen3State({this.user, this.image});

  Future getImageFromGallery() async {
    var image = await _picker.getImage(source: ImageSource.gallery);
    setState((){
      this.image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text("CADASTRO"),
          centerTitle: true,
        ),
        body: ListView(children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 30, top: 10),
            child: Row(
              children: <Widget>[
                Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26, width: 1.0),
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: image == null ? AssetImage("assets/person.png") :
                        AssetImage(this.image.path),
                        fit: BoxFit.cover)
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 40),
                    child: ButtonTheme(
                      minWidth: 100,
                        height: 50,
                        child: FlatButton(
                          onPressed: () {
                            getImageFromGallery();
                          },
                          color: Colors.green[900],
                          child: Icon(Icons.photo_library, color: Colors.white),
                        )))
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(10),
            child: ChipsInput(
              initialValue: [],
              decoration: InputDecoration(
                labelText: "Adicione seus interesses",
                hintStyle: TextStyle(color: Colors.black),
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.0),
                ),
              ),
              maxChips: _topicList.length,
              findSuggestions: (String query) {
                if (query.length != 0) {
                  var lowercaseQuery = query.toLowerCase();
                  return _topicList.where((profile) {
                    return profile.toLowerCase().contains(query.toLowerCase());
                  }).toList(growable: false)
                    ..sort((a, b) => a
                        .toLowerCase()
                        .indexOf(lowercaseQuery)
                        .compareTo(b.toLowerCase().indexOf(lowercaseQuery)));
                } else {
                  return const <String>[];
                }
              },
              onChanged: (data) {

              },
              chipBuilder: (context, state, topic) {
                return InputChip(
                  key: ObjectKey(topic),
                  label: Text(topic),
                  onDeleted: () {
                    state.deleteChip(topic);
                    _userTopicList.remove(topic);
                  },
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                );
              },
              suggestionBuilder: (context, state, topic) {
                return ListTile(
                    key: ObjectKey(topic),
                    title: Text(topic),
                    onTap: () {
                      debugPrint("$topic");
                      debugPrint("${_userTopicList.length}");
                      state.selectSuggestion(topic);
                      _userTopicList.add(topic);
                    }
                );
              },
            ),
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CircleUtil.buildCircle("1", 3, 1),
              Container(height: 1.0, width: 40.0, color: Colors.grey[500]),
              CircleUtil.buildCircle("2", 3, 2),
              Container(height: 1.0, width: 40.0, color: Colors.grey[500]),
              CircleUtil.buildCircle("3", 3, 3)
            ],
          ),
          SizedBox(height: 50),
          Container(
              padding: EdgeInsets.only(right: 10, left: 10),
              child: ButtonTheme(
                minWidth: 200,
                  height: 50,
                  child: FlatButton(
                    onPressed: () {
                      user.topicos = Topicos.buildTopicList(_userTopicList);
                      user.fotoPerfil = Base64Convert.convertImagePathToBase64(File(this.image.path));
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => SuccessSubscription()));
                    },
                    color: Colors.green[900],
                    child: Text(
                      "CONCLUIR CADASTRO",
                      style: TextStyle(color: Colors.white),
                    ),
                    disabledColor: Colors.black54,
                    disabledTextColor: Colors.white,
                  )))
        ]));
  }
}

