import 'dart:io';

import 'package:cultiveapp/bloc/user_bloc.dart';
import 'package:cultiveapp/model/user_model.dart';
import 'package:cultiveapp/screens/home_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:progress_dialog/progress_dialog.dart';

class EditProfileScreen extends StatefulWidget {
  //User to be edited
  final User user;

  EditProfileScreen(this.user);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  ImagePicker _picker = ImagePicker();

  User userToBeUpdated = User();

  final _userBloc = UserBloc();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  PickedFile image;

  ProgressDialog pr;

  int userId;

  File _image;

  Localizacao localizacao = Localizacao();

  //Mask
  final _phoneMask = MaskTextInputFormatter(
      mask: "(##) #####-####", filter: {"#": RegExp(r'[0-9]')});

  //Controllers
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _neighborhoodController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  //FormKey
  final _formKey = GlobalKey<FormState>();

  bool _userEdited = false;

  @override
  void initState() {
    super.initState();
    inicializeTextEditingController();
    configureProgressDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _requestPop,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text("EDITAR PERFIL"),
            centerTitle: true,
          ),
          body: ListView(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 50,
                          backgroundImage: widget.user.fotoPerfil == null
                              ? AssetImage("assets/person.png")
                              : _image == null
                                  ? NetworkImage(widget.user.fotoPerfil)
                                  : FileImage(_image),
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
                                  child: Icon(Icons.photo_library,
                                      color: Colors.white),
                                ))),
                      ])),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                              onChanged: (value) {
                                if (value != widget.user.nome) {
                                  _userEdited = true;
                                  userToBeUpdated.nome = value;
                                }
                              },
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value.isEmpty) return "Campo Obrigatório";
                                return null;
                              },
                              controller: _nameController,
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.person_outline,
                                  color: Colors.black,
                                ),
                                labelText: "Nome",
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
                              onChanged: (value) {
                                if (value != widget.user.email) {
                                  _userEdited = true;
                                  userToBeUpdated.email = value;
                                }
                              },
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
                                  Icons.email,
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
                              onChanged: (value) {
                                if (value != widget.user.celular) {
                                  _userEdited = true;
                                  userToBeUpdated.celular = value;
                                }
                              },
                              inputFormatters: [_phoneMask],
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value.isEmpty) return "Campo Obrigatório";
                                if (value.length < 11)
                                  return "Informe um numero válido";
                                return null;
                              },
                              controller: _phoneController,
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.phone_android,
                                  color: Colors.black,
                                ),
                                labelText: "Celular",
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
                              onChanged: (value) {
                                if (value != widget.user.localizacao.bairro) {
                                  _userEdited = true;
                                  localizacao.bairro = value;
                                }
                              },
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value.isEmpty) return "Campo Obrigatório";
                                return null;
                              },
                              controller: _neighborhoodController,
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.home,
                                  color: Colors.black,
                                ),
                                labelText: "Bairro",
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
                              onChanged: (value) {
                                if (value != widget.user.localizacao.cidade) {
                                  _userEdited = true;
                                  localizacao.cidade = value;
                                }
                              },
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value.isEmpty) return "Campo Obrigatório";
                                return null;
                              },
                              controller: _cityController,
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.home,
                                  color: Colors.black,
                                ),
                                labelText: "Cidade",
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
                              onChanged: (value) {
                                if (value != widget.user.localizacao.estado) {
                                  _userEdited = true;
                                  localizacao.estado = value;
                                }
                              },
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value.isEmpty) return "Campo Obrigatório";
                                return null;
                              },
                              controller: _stateController,
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.home,
                                  color: Colors.black,
                                ),
                                labelText: "Estado",
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
                          Container(
                              padding: EdgeInsets.only(right: 10, left: 10),
                              child: ButtonTheme(
                                  minWidth: 200,
                                  height: 50,
                                  child: FlatButton(
                                    onPressed: () async {
                                      if (userToBeUpdated == null) {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text("Editar Perfil"),
                                                content: Text(
                                                    "Nenhum dado foi alterado, necessário alterar algum dado para editar o perfil"),
                                                actions: <Widget>[
                                                  FlatButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text("Ok"))
                                                ],
                                              );
                                            });
                                      }
                                      if (_formKey.currentState.validate()) {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text("Editar Perfil"),
                                                content: Text(
                                                    "Deseja realmente alterar os dados da sua conta?"),
                                                actions: <Widget>[
                                                  FlatButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text("Cancelar")),
                                                  FlatButton(
                                                      onPressed: () async {
                                                        Navigator.pop(context);
                                                        pr.show();
                                                        userToBeUpdated.localizacao = localizacao;
                                                        if (_image != null)
                                                          await uploadFile();
                                                        _userBloc.editUser(
                                                            user: userToBeUpdated,
                                                            userId: widget.user.id,
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
                                      "CONCLUIR EDIÇÃO",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    disabledColor: Colors.black54,
                                    disabledTextColor: Colors.white,
                                  ))),
                          SizedBox(height: 20),
                        ],
                      ))
              )
            ],
          ),
        ));
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar Alterações?"),
              content: Text("Se sair as alterações serão perdidas"),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancelar")),
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                             HomeScreen()));
                    },
                    child: Text("Sim"))
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  void inicializeTextEditingController() {
    _phoneController.text = widget.user.celular;
    _stateController.text = widget.user.localizacao.estado;
    _cityController.text = widget.user.localizacao.cidade;
    _neighborhoodController.text = widget.user.localizacao.bairro;
    _nameController.text = widget.user.nome;
    _emailController.text = widget.user.email;
  }

  Future getImageFromGallery() async {
    var image = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      this.image = image;
      _image = File(this.image.path);
    });
  }

  void _onSuccess() {
    pr.hide();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  void _onFail() {
    pr.hide();
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao editar usuário"),
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

  uploadFile() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('profiles_photos/${_image.path.split("/").last}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    var fileURL = await storageReference.getDownloadURL();
    setState(() {
      widget.user.fotoPerfil = fileURL;
      userToBeUpdated.fotoPerfil = fileURL;
    });
  }
}
