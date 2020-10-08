import 'dart:io';
import 'package:cultiveapp/bloc/topic_bloc.dart';
import 'package:cultiveapp/bloc/user_bloc.dart';
import 'package:cultiveapp/model/topico_model.dart';
import 'package:cultiveapp/model/user_model.dart';
import 'package:cultiveapp/screens/subscription/successSubscription.dart';
import 'package:cultiveapp/utils/CircleUtil.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';

// ignore: must_be_immutable
class Screen3 extends StatefulWidget {
  //User
  User user;

  Screen3({this.user});
  @override
  _Screen3State createState() => _Screen3State(user: user);
}

class _Screen3State extends State<Screen3> {
  //All Topic List
  List<TopicoModel> _topicList = List<TopicoModel>();

  //User Topic List
  final List<String> _userTopicList = List<String>();

  //TopicApi
  TopicApi _topicApi = new TopicApi();

  //User
  User user;

  //Profile image
  PickedFile image;

  //ImagePicker plugin
  ImagePicker _picker = ImagePicker();

  //UserBloc
  UserBloc _userBloc;

  //Scaffold Key
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  //Progress Dialog
  ProgressDialog pr;

  //Image File
  File _image;

  //Constructor
  _Screen3State({this.user, this.image}) {
    _userBloc = UserBloc();
    _topicApi.getTopicList();
  }

  Future getImageFromGallery() async {
    var image = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      this.image = image;
      _image = File(this.image.path);
    });
  }

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
                          image: image == null
                              ? AssetImage("assets/person.png")
                              : FileImage(_image),
                          fit: BoxFit.cover)),
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
            child: StreamBuilder<List<TopicoModel>>(
                initialData: [],
                stream: _topicApi.output,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    _topicList = snapshot.data;
                  } else {
                    return Container();
                  }
                  return ChipsInput(
                    initialValue: [],
                    decoration: InputDecoration(
                      labelText: "Adicione seus tópicos de interesses",
                      hintText: "Exemplo : Plantio de Milho, Criação de Gado...",
                      hintStyle: TextStyle(color: Colors.black54,  fontSize: 14),
                      labelStyle: TextStyle(color: Colors.black,),
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
                          return profile.nome
                              .toLowerCase()
                              .contains(query.toLowerCase());
                        }).toList(growable: false)
                          ..sort((a, b) => a.nome
                              .toLowerCase()
                              .indexOf(lowercaseQuery)
                              .compareTo(b.nome
                                  .toLowerCase()
                                  .indexOf(lowercaseQuery)));
                      } else {
                        return const <String>[];
                      }
                    },
                    chipBuilder: (context, state, topic) {
                      return InputChip(
                        key: ObjectKey(topic),
                        label: Text(topic.nome),
                        onDeleted: () {
                          state.deleteChip(topic);
                          _userTopicList.remove(topic.nome);
                        },
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      );
                    },
                    suggestionBuilder: (context, state, topic) {
                      return ListTile(
                          key: ObjectKey(topic),
                          title: Text(topic.nome),
                          subtitle: Text(topic.descricao),
                          onTap: () {
                            state.selectSuggestion(topic);
                            _userTopicList.add(topic.nome);
                          });
                    },
                    onChanged: (List<dynamic> value) {},
                  );
                }),
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
                    onPressed: () async {
                      pr.show();
                      uploadFile();
                      user.topicos = Topicos.buildTopicList(_userTopicList);
                      _userBloc.submitSubscription(
                          userPayload: user.toJson(),
                          onSuccess: _onSuccess,
                          onFail: _onFail);
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

  void _onSuccess() {
    pr.hide();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SuccessScreen(this.user.nome)));
  }

  void _onFail() {
    pr.hide();
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao criar usuário"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 3),
    ));
  }

  uploadFile() async {
    if (_image == null) {
      return;
    }
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('profiles_photos/${_image.path.split("/").last}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    var fileURL = await storageReference.getDownloadURL();
    setState(() {
      this.user.fotoPerfil = fileURL;
    });
  }
}
