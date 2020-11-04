import 'package:cultiveapp/bloc/publication_bloc.dart';
import 'package:cultiveapp/model/publication_model.dart';
import 'package:cultiveapp/tiles/publication_tile.dart';
import 'package:flutter/material.dart';

class SearchPublicationScreen extends StatefulWidget {
  final Map<String, dynamic> _userInfo;
  SearchPublicationScreen(this._userInfo);
  @override
  _SearchPublicationScreenState createState() =>
      _SearchPublicationScreenState();
}

class _SearchPublicationScreenState extends State<SearchPublicationScreen> {
  var _radioValue1;

  var editingController = TextEditingController();
  bool isSearching = false;
  //FormKey

  final _formKey = GlobalKey<FormState>();

  bool endOfList = false;

  var _publicationBloc = PublicationBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('BUSCA DE PUBLICACÕES'),
          centerTitle: true,
        ),
        body: ListView(padding: EdgeInsets.all(10), children: [
          ExpansionTile(
            title: Text(
              "Realizar busca",
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontWeight: FontWeight.w500, color: Colors.grey[700]),
            ),
            leading: Icon(
              Icons.filter_alt_sharp,
            ),
            childrenPadding: EdgeInsets.all(10),
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: editingController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty) return "Campo Obrigatório";
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: "Busca",
                          hintText: "Ex: Gado, Milho, Leite",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(1.0)))),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Radio(
                          value: 0,
                          groupValue: _radioValue1,
                          onChanged: (value) {
                            setState(() {
                              _radioValue1 = value;
                            });
                          },
                        ),
                        new Text(
                          'Usuário',
                          style: new TextStyle(fontSize: 12.0),
                        ),
                        new Radio(
                          value: 1,
                          groupValue: _radioValue1,
                          onChanged: (value) {
                            setState(() {
                              _radioValue1 = value;
                            });
                          },
                        ),
                        new Text(
                          'Descrição',
                          style: new TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                        new Radio(
                          value: 2,
                          groupValue: _radioValue1,
                          onChanged: (value) {
                            setState(() {
                              _radioValue1 = value;
                            });
                          },
                        ),
                        new Text(
                          'Tópico',
                          style: new TextStyle(fontSize: 12.0),
                        ),
                      ],
                    ),
                    ButtonTheme(
                        minWidth: 180,
                        height: 30,
                        child: FlatButton(
                          onPressed: _radioValue1 == null
                              ? null
                              : () {
                                  if (_formKey.currentState.validate()) {
                                    print(
                                        "textfield : ${editingController.text} e radiobutton $_radioValue1");
                                    _publicationBloc.getSearchListPublication(
                                        endOfTheList,
                                        0,
                                        _radioValue1,
                                        editingController.text,
                                        true);
                                  }
                                },
                          color: Colors.green[900],
                          child: Text(
                            "BUSCAR",
                            style: TextStyle(color: Colors.white),
                          ),
                          disabledColor: Colors.black54,
                          disabledTextColor: Colors.white,
                        ))
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          StreamBuilder<List<Publication>>(
              initialData: [],
              stream: _publicationBloc.search,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                      color: Colors.white,
                      child: Center(
                          child: LinearProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation(Colors.green))));
                } else if (snapshot.hasData) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: ListView.builder(
                        itemCount: snapshot.data.length + 1,
                        itemBuilder: (context, index) {
                          if (snapshot.data.length == 0) {
                            return Container(
                              padding: EdgeInsets.all(100),
                              child: Center(
                                child: Text("Nenhum resultado encontrado"),
                              ),
                            );
                          } else if (index < snapshot.data.length) {
                            return PublicationTile(
                                snapshot.data[index], widget._userInfo);
                          } else if (endOfList) {
                            return Container(
                              padding: EdgeInsets.all(30),
                              child: Center(
                                child: Text("Você chegou ao final da lista"),
                              ),
                            );
                          } else if (index > 1) {
                            _publicationBloc.getSearchListPublication(
                                endOfTheList,
                                null,
                                _radioValue1,
                                editingController.text,
                                false);
                            return Container(
                                height: 40,
                                width: 40,
                                alignment: Alignment.center,
                                child: Center(
                                    child: LinearProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<
                                                Color>(
                                            Theme.of(context).primaryColor))));
                          } else {
                            return Container();
                          }
                        }),
                  );
                } else {
                  return Container();
                }
              })
        ]));
  }

  void endOfTheList() {
    setState(() {
      endOfList = true;
    });
  }
}
