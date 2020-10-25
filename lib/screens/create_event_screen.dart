import 'dart:io';

import 'package:cultiveapp/api/cep_api.dart';
import 'package:cultiveapp/bloc/event_bloc.dart';
import 'package:cultiveapp/model/event_model.dart';
import 'package:cultiveapp/model/publication_model.dart';
import 'package:cultiveapp/model/user_model.dart';
import 'package:cultiveapp/screens/events_screen.dart';
import 'package:cultiveapp/utils/input_dropdown.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:progress_dialog/progress_dialog.dart';

class CreateEventScreen extends StatefulWidget {
  final String token;
  final User user;
  CreateEventScreen(this.user, this.token);
  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  //Controllers
  final _descriptionController = TextEditingController();
  final _cepController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _titleController = TextEditingController();

  //FormKey
  final _formKey = GlobalKey<FormState>();

  //Bloc
  final _cepAPI = CepAPI();

  bool _hasFocus = false;

  final _cepMask = MaskTextInputFormatter(
      mask: "#####-###", filter: {"#": RegExp(r'[0-9]')});

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay.fromDateTime(DateTime.now());

  //Image File
  File _image;

  ProgressDialog pr;

  //Profile image
  PickedFile image;

  //ImagePicker plugin
  ImagePicker _picker = ImagePicker();

  EventBloc _bloc;

  //Scaffold Key
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _bloc = EventBloc();
  }

  Future getImageFromGallery() async {
    var image = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      this.image = image;
      _image = File(this.image.path);
    });
  }

  configureProgressDialog(BuildContext context) {
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("CRIAR EVENTO"),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10),
                  Text("Informações do evento",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  TextFormField(
                      validator: (value) {
                        if (value.isEmpty) return "Campo Obrigatório";
                        return null;
                      },
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: "Título",
                        hintText: "Título do evento",
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
                      )),
                  SizedBox(height: 20),
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
                        hintText: "Descrição do evento",
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
                      )),
                  SizedBox(height: 20),
                  Text("Data do evento",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      new Expanded(
                        flex: 4,
                        child: InputDropdown(
                          labelText: "Data",
                          valueText:
                              new DateFormat.yMMMd().format(selectedDate),
                          onPressed: () {
                            _selectDate(context);
                          },
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      new Expanded(
                        flex: 3,
                        child: new InputDropdown(
                          valueText: selectedTime.format(context),
                          labelText: 'Hora',
                          onPressed: () {
                            _selectTime(context);
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text("Localicação do evento",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  TextFormField(
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value.isEmpty) return "Campo Obrigatório";
                        if (value.length < 7) return "Informe um CEP Válido";
                        return null;
                      },
                      onChanged: (value) async {
                        if (value.replaceFirst("-", "").trim().length == 8) {
                          Cep cep = await _cepAPI
                              .searchCep(value.replaceFirst("-", "").trim());
                          if (cep != null) {
                            _populateAddressFields(cep);
                            setState(() {
                              _hasFocus = true;
                            });
                          }
                        }
                      },
                      inputFormatters: [_cepMask],
                      controller: _cepController,
                      decoration: InputDecoration(
                        labelText: "CEP",
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
                      enabled: _hasFocus,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty) return "Campo Obrigatório";
                        return null;
                      },
                      controller: _neighborhoodController,
                      decoration: InputDecoration(
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
                      enabled: _hasFocus,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty) return "Campo Obrigatório";
                        return null;
                      },
                      controller: _cityController,
                      decoration: InputDecoration(
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
                      enabled: _hasFocus,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty) return "Campo Obrigatório";
                        return null;
                      },
                      controller: _stateController,
                      decoration: InputDecoration(
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
                  Text(
                    "Cartaz do evento",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  _image == null
                      ? Container()
                      : Container(
                          width: 300.0,
                          height: 200.0,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black26, width: 1.0),
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                  image: FileImage(_image), fit: BoxFit.cover)),
                        ),
                  SizedBox(height: 20),
                  ButtonTheme(
                      minWidth: 100,
                      height: 50,
                      child: FlatButton(
                        onPressed: () {
                          getImageFromGallery();
                        },
                        color: Colors.green[900],
                        child: Icon(Icons.photo_library, color: Colors.white),
                      )),
                ],
              ),
            ),
          ),
          Container(
              padding: EdgeInsets.all(20),
              child: ButtonTheme(
                  minWidth: 200,
                  height: 50,
                  child: FlatButton(
                    onPressed: () async {
                      if (_image == null) {
                        _showErrorImageDialog();
                      }
                      if (_formKey.currentState.validate() && _image != null) {
                        pr.show();
                        Event event = await buildEventToSave();
                        _bloc.createEvent(
                            event: event,
                            userId: widget.user.id,
                            token: widget.token,
                            onSuccess: _onSuccess,
                            onFail: _onFail);
                      }
                    },
                    color: Colors.green[900],
                    child: Text(
                      "CRIAR EVENTO",
                      style: TextStyle(color: Colors.white),
                    ),
                    disabledColor: Colors.black54,
                    disabledTextColor: Colors.white,
                  )))
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  _populateAddressFields(Cep cep) {
    _stateController.text = cep.uf;
    _cityController.text = cep.localidade;
    _neighborhoodController.text = cep.bairro;
  }

  Future<String> uploadFileAndReturnURL() async {
    if (_image == null) {
      return Future.value();
    }
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('events_photos/${_image.path.split("/").last}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    return await storageReference.getDownloadURL();
  }

  buildEventToSave() async {
    Event event = Event();

    List<Imagens> imagens = [];
    Imagens imagem = Imagens();
    imagem.imagemEncoded = await uploadFileAndReturnURL();
    imagens.add(imagem);
    event.imagens = imagens;

    event.titulo = _titleController.text;
    event.descricao = _descriptionController.text;

    Localizacao localizacao = Localizacao();
    localizacao.bairro = _neighborhoodController.text;
    localizacao.cidade = _cityController.text;
    localizacao.estado = _stateController.text;
    event.localizacao = localizacao;

    Status status = Status();
    status.nome = "Criada";
    event.status = status;
    DateTime date = DateTime(selectedDate.year, selectedDate.month,
        selectedDate.day, selectedTime.hour, selectedTime.minute);
    event.data = date.toIso8601String();
    return event;
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
          title: Text('Evento criado com sucesso!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Tudo ok com criação de seu evento!'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => EventsScreen()));
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: selectedTime);
    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
      });
  }

  Future<void> _showErrorImageDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Campo Imagem Obrigatório'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Necessário informar campo imagem do evento'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
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
      content: Text("Falha ao criar evento, tente novamente."),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 3),
    ));
  }
}
