import 'package:cultiveapp/bloc/event_bloc.dart';
import 'package:cultiveapp/model/event_model.dart';
import 'package:cultiveapp/screens/event_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';

class SearchEventsScreen extends StatefulWidget {
  final Map<String, dynamic> _userInfo;
  SearchEventsScreen(this._userInfo);
  @override
  _SearchEventsScreenState createState() => _SearchEventsScreenState();
}

class _SearchEventsScreenState extends State<SearchEventsScreen> {
  var _radioValue1;

  var editingController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool endOfList = false;

  var _bloc = EventBloc();

  CardController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('BUSCA DE EVENTOS'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height * 1.3,
                child: Column(
                  children: [
                    ExpansionTile(
                      backgroundColor: Colors.white,
                      title: Text(
                        "Realizar busca",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700]),
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(1.0)))),
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
                                    'Descrição',
                                    style: new TextStyle(
                                      fontSize: 12.0,
                                    ),
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
                                            if (_formKey.currentState
                                                .validate()) {
                                              print(
                                                  "textfield : ${editingController.text} e radiobutton $_radioValue1");
                                              _bloc.getSearchListEvents(
                                                _radioValue1,
                                                editingController.text,
                                              );
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
                    Padding(
                      padding: EdgeInsets.only(top: 10, right: 24, left: 24),
                      child: Card(
                        shadowColor: Colors.black,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding:
                                  EdgeInsets.only(top: 10, right: 10, left: 10),
                              child: Text("Modo de uso:",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Divider(color: Colors.black),
                            Container(
                              padding:
                                  EdgeInsets.only(top: 10, right: 10, left: 10),
                              child: Text(
                                  "Arraste os cards para os lados para navegar pelos eventos",
                                  style: TextStyle(fontSize: 12)),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  right: 10, left: 10, bottom: 10),
                              child: Text(
                                  "Toque no card para ter acesso aos detalhes do evento",
                                  style: TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    StreamBuilder<List<Event>>(
                      initialData: [],
                      stream: _bloc.search,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Center(
                                  child: LinearProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation(
                                          Colors.white))));
                        }

                        if (snapshot.data.length == 0) {
                          return Padding(
                            padding:
                                EdgeInsets.only(top: 10, right: 24, left: 24),
                            child: Card(
                              shadowColor: Colors.black,
                              child: Container(
                                padding: EdgeInsets.all(20),
                                child: Text("Nenhum resultado encontrado",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                          );
                        }
                        return Center(
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: new TinderSwapCard(
                              swipeUp: true,
                              swipeDown: true,
                              orientation: AmassOrientation.TOP,
                              totalNum: snapshot.data.length,
                              stackNum: 3,
                              swipeEdge: 4.0,
                              maxWidth: MediaQuery.of(context).size.width * 0.9,
                              maxHeight:
                                  MediaQuery.of(context).size.width * 0.9,
                              minWidth: MediaQuery.of(context).size.width * 0.8,
                              minHeight:
                                  MediaQuery.of(context).size.width * 0.8,
                              cardBuilder: (context, index) {
                                return Card(
                                  child: Column(
                                    children: [
                                      snapshot.data[index].titulo == null
                                          ? Container()
                                          : Row(
                                              children: [
                                                Flexible(
                                                  child: Container(
                                                      child: Text(
                                                        "${snapshot.data[index].titulo}",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                      padding:
                                                          EdgeInsets.all(10)),
                                                )
                                              ],
                                            ),
                                      Expanded(
                                        child: GestureDetector(
                                          child: Image.network(
                                            '${snapshot.data[index].imagem}',
                                            fit: BoxFit.cover,
                                          ),
                                          onTap: () => Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailPage(
                                                          snapshot.data[index],
                                                          widget._userInfo[
                                                              "user"],
                                                          widget._userInfo[
                                                              "token"]))),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                              cardController: controller = CardController(),
                              swipeUpdateCallback:
                                  (DragUpdateDetails details, Alignment align) {
                                /// Get swiping card's alignment
                                if (align.x < 0) {
                                  //Card is LEFT swiping
                                } else if (align.x > 0) {
                                  //Card is RIGHT swiping
                                }
                              },
                              swipeCompleteCallback:
                                  (CardSwipeOrientation orientation,
                                      int index) {
                                /// Get orientation & index of swiped card!
                              },
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ))));
  }
}
