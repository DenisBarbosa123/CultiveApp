import 'dart:convert';
import 'dart:io';

import 'package:cultiveapp/api/cep_api.dart';
import 'package:cultiveapp/bloc/user_bloc.dart';
import 'package:cultiveapp/model/user_model.dart';
import 'package:cultiveapp/screens/home_screen.dart';
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

  final _userBloc = UserBloc();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  PickedFile image;

  ProgressDialog pr;

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

  @override
  Widget build(BuildContext context) {
    inicializeTextEditingController();
    configureProgressDialog(context);
    return Scaffold(
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
                          : MemoryImage(base64.decode(widget.user.fotoPerfil)),
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
          Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
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
                              if (_formKey.currentState.validate()) {}
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
        ],
      ),
    );
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
      final fileImage = File(image.path);
      fileImage.readAsBytes().then((value) => setFileImage(value));
    });
  }

  getFileImage(PickedFile pickedFile) {
    final fileImage = File(pickedFile.path);
    return FileImage(fileImage);
  }

  setFileImage(List<int> image) {
    widget.user.fotoPerfil = base64.encode(image);
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
}
