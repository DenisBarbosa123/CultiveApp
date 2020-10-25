import 'package:cultiveapp/bloc/event_bloc.dart';
import 'package:cultiveapp/model/event_model.dart';
import 'package:cultiveapp/screens/event_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';

class EventTabs extends StatefulWidget {
  final Map<String, dynamic> userInfo;

  EventTabs(this.userInfo);

  @override
  _EventTabsState createState() => _EventTabsState();
}

class _EventTabsState extends State<EventTabs> with TickerProviderStateMixin {
  EventBloc _bloc = EventBloc();
  CardController controller;

  void initState() {
    super.initState();
    _bloc.getListEvent();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                color: Colors.white,
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.green, Colors.blue])),
            child: Column(
              children: [
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
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Divider(color: Colors.black),
                        Container(
                          padding:
                              EdgeInsets.only(top: 10, right: 10, left: 10),
                          child: Text(
                              "Arraste os Cards para os lados para navegar pelos eventos",
                              style: TextStyle(fontSize: 12)),
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(right: 10, left: 10, bottom: 10),
                          child: Text(
                              "Toque no card para ter acesso aos detalhes do evento",
                              style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                ),
                StreamBuilder<List<Event>>(
                  stream: _bloc.output,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Padding(
                          padding: EdgeInsets.only(top: 150),
                          child: Center(
                              child: CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white))));
                    }

                    if (snapshot.data.length == 0) {
                      return Padding(
                        padding: EdgeInsets.only(top: 10, right: 24, left: 24),
                        child: Card(
                          shadowColor: Colors.black,
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Text("Não há eventos disponíveis",
                                style: TextStyle(fontWeight: FontWeight.bold)),
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
                          maxHeight: MediaQuery.of(context).size.width * 0.9,
                          minWidth: MediaQuery.of(context).size.width * 0.8,
                          minHeight: MediaQuery.of(context).size.width * 0.8,
                          cardBuilder: (context, index) {
                            return Card(
                              child: Column(
                                children: [
                                  snapshot.data[index].titulo == null
                                      ? Container()
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                                child: Text(
                                                  "${snapshot.data[index].titulo}",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                padding: EdgeInsets.all(12)),
                                          ],
                                        ),
                                  Expanded(
                                    child: GestureDetector(
                                      child: Image.network(
                                        '${snapshot.data[index].imagens[0].imagemEncoded}',
                                        fit: BoxFit.cover,
                                      ),
                                      onTap: () => Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => DetailPage(
                                                  snapshot.data[index],
                                                  widget.userInfo["user"],
                                                  widget.userInfo["token"]))),
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
                              (CardSwipeOrientation orientation, int index) {
                            /// Get orientation & index of swiped card!
                          },
                        ),
                      ),
                    );
                  },
                )
              ],
            )));
  }
}
