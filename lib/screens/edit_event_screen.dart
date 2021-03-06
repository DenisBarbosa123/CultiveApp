import 'dart:io';

import 'package:cultiveapp/bloc/event_bloc.dart';
import 'package:cultiveapp/model/event_model.dart';
import 'package:cultiveapp/model/user_model.dart';
import 'package:cultiveapp/screens/events_screen.dart';
import 'package:cultiveapp/utils/input_dropdown.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

class EditEventScreen extends StatefulWidget {
  final User user;
  final String token;
  final Event event;
  EditEventScreen(this.user, this.token, this.event);
  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  //Controllers
  final _descriptionController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _titleController = TextEditingController();

  Localizacao localizacao = Localizacao();

  //FormKey
  final _formKey = GlobalKey<FormState>();

  Event eventToBeUpdated = Event();

  DateTime selectedDate;

  TimeOfDay selectedTime;

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
    initializeTextEditingController();
  }

  Future getImageFromGallery() async {
    var image = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      this.image = image;
      if (this.image != null) {
        _image = File(this.image.path);
      }
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

  initializeTextEditingController() {
    _descriptionController.text = widget.event.descricao;
    _stateController.text = widget.event.localizacao.estado;
    _cityController.text = widget.event.localizacao.cidade;
    _neighborhoodController.text = widget.event.localizacao.bairro;
    _titleController.text = widget.event.titulo;
  }

  @override
  Widget build(BuildContext context) {
    configureProgressDialog(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("EDITAR EVENTO"),
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
                      onChanged: (value) {
                        if (value != widget.event.titulo) {
                          eventToBeUpdated.titulo = value;
                        }
                      },
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
                      onChanged: (value) {
                        if (value != widget.event.descricao) {
                          eventToBeUpdated.descricao = value;
                        }
                      },
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
                          valueText: selectedDate == null
                              ? DateFormat.yMMMd()
                                  .format(DateTime.parse(widget.event.data))
                              : DateFormat.yMMMd().format(DateTime.parse(
                                  selectedDate.toIso8601String())),
                          onPressed: () {
                            _selectDate(context);
                          },
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      new Expanded(
                        flex: 3,
                        child: new InputDropdown(
                          valueText: selectedTime == null
                              ? TimeOfDay.fromDateTime(
                                      DateTime.parse(widget.event.data))
                                  .format(context)
                              : selectedTime.format(context),
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
                      onChanged: (value) {
                        if (value != widget.event.localizacao.bairro) {
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
                        if (value != widget.event.localizacao.cidade) {
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
                        if (value != widget.event.localizacao.estado) {
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
                  widget.event.imagem == null && _image == null
                      ? Container()
                      : Container(
                          width: 300.0,
                          height: 200.0,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black26, width: 1.0),
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                  image: _image == null
                                      ? NetworkImage(widget.event.imagem)
                                      : FileImage(_image),
                                  fit: BoxFit.cover)),
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
                      if (_formKey.currentState.validate()) {
                        pr.show();
                        validateAndSetDate();
                        await validateAndSetImage();
                        eventToBeUpdated.localizacao = localizacao;
                        _bloc.editEvent(
                            eventId: widget.event.id,
                            event: eventToBeUpdated,
                            token: widget.token,
                            onSuccess: _onSuccess,
                            onFail: _onFail);
                      }
                    },
                    color: Colors.green[900],
                    child: Text(
                      "EDITAR EVENTO",
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
        initialDate: selectedDate == null
            ? DateTime.parse(widget.event.data)
            : selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
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

  validateAndSetImage() async {
    if (_image == null) {
      return;
    }

    eventToBeUpdated.imagem = await uploadFileAndReturnURL();
  }

  validateAndSetDate() {
    DateTime oldEventDate = DateTime.parse(widget.event.data);
    if (selectedDate == null) {
      selectedDate = oldEventDate;
    }
    if (selectedTime == null) {
      selectedTime = TimeOfDay.fromDateTime(oldEventDate);
    }
    DateTime date = DateTime(selectedDate.year, selectedDate.month,
        selectedDate.day, selectedTime.hour, selectedTime.minute);

    if (date != oldEventDate) {
      eventToBeUpdated.data = date.toLocal().toIso8601String();
    }
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
          title: Text('Evento editado com sucesso!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Tudo ok com edição de seu evento!'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => EventsScreen()),
                    (Route<dynamic> route) => false);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: selectedTime == null
            ? TimeOfDay.fromDateTime(DateTime.parse(widget.event.data))
            : selectedTime);
    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
      });
  }

  void _onFail() {
    pr.hide();
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao editar evento, tente novamente."),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 3),
    ));
  }
}
