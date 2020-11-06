import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:cultiveapp/bloc/publication_bloc.dart';
import 'package:cultiveapp/bloc/topic_bloc.dart';
import 'package:cultiveapp/model/publication_model.dart';
import 'package:cultiveapp/model/topico_model.dart';
import 'package:cultiveapp/model/user_model.dart';
import 'package:cultiveapp/screens/publication_screen.dart';
import 'package:cultiveapp/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';

class CreatePublicationScreen extends StatefulWidget {
  final User user;
  final String token;
  CreatePublicationScreen(this.user, this.token);
  @override
  _CreatePublicationScreenState createState() =>
      _CreatePublicationScreenState(this.user, this.token);
}

class _CreatePublicationScreenState extends State<CreatePublicationScreen> {
  int userId;
  final User user;
  final String token;
  //All Topic List
  List<TopicoModel> _topicList = List<TopicoModel>();

  //User Topic List
  final List<String> _pubTopicList = List<String>();

  //TopicApi
  TopicApi _topicApi = new TopicApi();

  //Progress Dialog
  ProgressDialog pr;

  List<Asset> assetsList = [];

  PublicationBloc _bloc;

  //Scaffold Key
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _descriptionController = TextEditingController();

  //FormKey
  final _formKey = GlobalKey<FormState>();

  _CreatePublicationScreenState(this.user, this.token) {
    _bloc = PublicationBloc();
    _topicApi.getTopicList();
    userId = user.id;
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: false,
        selectedAssets: assetsList,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } catch (e) {
      debugPrint("Exception during multi image picker" + e.toString());
    }

    setState(() {
      assetsList = resultList;
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
          title: Text("CRIAR PUBLICAÇÃO"),
          centerTitle: true,
        ),
        body: ListView(children: <Widget>[
          Form(
              key: _formKey,
              child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(children: <Widget>[
                    TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        validator: (value) {
                          if (value.isEmpty) return "Campo Obrigatório";
                          return null;
                        },
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: "Descrição",
                          hintText: "O que gostaria de compartilhar?",
                          hintStyle: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w200),
                          labelStyle: TextStyle(color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                          ),
                        ))
                  ]))),
          SizedBox(height: 10),
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
                      labelText: "Tópicos relacionados a publicação",
                      hintText: "Exemplo: Plantio de Milho, Criação de Gado...",
                      hintStyle: TextStyle(color: Colors.black54, fontSize: 14),
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
                          _pubTopicList.remove(topic.nome);
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
                            _pubTopicList.add(topic.nome);
                          });
                    },
                    onChanged: (List<dynamic> value) {},
                  );
                }),
          ),
          assetsList.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.all(10),
                  child: AspectRatio(
                    aspectRatio: 0.9,
                    child: Carousel(
                      images: assetsList.map((imagem) {
                        return AssetThumb(
                            asset: imagem, height: 200, width: 200);
                      }).toList(),
                      dotSize: 4.0,
                      dotSpacing: 15.0,
                      dotBgColor: Colors.transparent,
                      dotColor: Colors.white,
                      dotIncreasedColor: Theme.of(context).primaryColor,
                      autoplay: false,
                    ),
                  ))
              : Container(),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Add imagens"),
              IconButton(
                icon: Icon(
                  Icons.image,
                  color: Colors.black,
                  size: 40,
                ),
                onPressed: loadAssets,
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
              padding: EdgeInsets.only(right: 10, left: 10),
              child: ButtonTheme(
                  minWidth: 200,
                  height: 50,
                  child: FlatButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        pr.show();
                        Publication publication =
                            await buildPublicationToSave();
                        _bloc.createPublication(
                            token: token,
                            userId: userId,
                            publication: publication,
                            onFail: _onFail,
                            onSuccess: _onSuccess);
                      }
                    },
                    color: Colors.green[900],
                    child: Text(
                      "SALVAR PUBLICAÇÃO",
                      style: TextStyle(color: Colors.white),
                    ),
                    disabledColor: Colors.black54,
                    disabledTextColor: Colors.white,
                  ))),
          SizedBox(height: 20),
        ]));
  }

  Future<Publication> buildPublicationToSave() async {
    List<File> filesImg = await ImageUtils.getFileListFromAssetList(assetsList);
    List<Imagens> imagensSaved = await ImageUtils.uploadListImage(filesImg);

    Publication publication = Publication();
    publication.corpo = _descriptionController.text;
    publication.data = DateTime.now().toLocal().toIso8601String();
    publication.imagens = imagensSaved;

    Status status = new Status();
    status.nome = "Criada";
    publication.status = status;

    Tipo tipo = Tipo();
    tipo.nome = "Geral";
    publication.tipo = tipo;

    publication.topicos = Topicos.buildTopicList(_pubTopicList);

    return publication;
  }

  void _onSuccess() {
    Future.delayed(Duration(seconds: 5)).then((_) {
      pr.hide();
      _showMyDialog();
    });
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Publicação criada com sucesso!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Tudo ok com criação de sua publicação!'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => PublicationScreen()),
                    (Route<dynamic> route) => false);
              },
            ),
          ],
        );
      },
    );
  }

  void _onFail() {
    pr.hide();
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao criar publicação, tente novamente."),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 3),
    ));
  }
}
