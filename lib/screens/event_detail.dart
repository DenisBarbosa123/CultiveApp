import 'package:cultiveapp/bloc/event_bloc.dart';
import 'package:cultiveapp/model/event_model.dart';
import 'package:cultiveapp/model/user_model.dart';
import 'package:cultiveapp/screens/events_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

class DetailPage extends StatefulWidget {
  final Event event;
  final User user;
  final String token;
  DetailPage(this.event, this.user, this.token);
  @override
  _DetailPageState createState() => new _DetailPageState(this.event);
}

enum AppBarBehavior { normal, pinned, floating, snapping }

class _DetailPageState extends State<DetailPage> with TickerProviderStateMixin {
  AnimationController _containerController;
  Animation<double> width;
  Animation<double> heigth;

  ProgressDialog pr;
  _DetailPageState(this.event);
  Event event;
  double _appBarHeight = 256.0;
  AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;
  final DateFormat _dateFormat = DateFormat('dd-MM-yyyy hh:mm');
  List<String> options = ['Editar Evento', 'Excluir Evento'];
  EventBloc _bloc = EventBloc();

  @override
  void initState() {
    _containerController = new AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this);
    super.initState();
    width = new Tween<double>(
      begin: 200.0,
      end: 220.0,
    ).animate(
      new CurvedAnimation(
        parent: _containerController,
        curve: Curves.ease,
      ),
    );
    heigth = new Tween<double>(
      begin: 400.0,
      end: 400.0,
    ).animate(
      new CurvedAnimation(
        parent: _containerController,
        curve: Curves.ease,
      ),
    );
    heigth.addListener(() {
      setState(() {
        if (heigth.isCompleted) {}
      });
    });
    _containerController.forward();
  }

  void handleClick(String option) {
    showDialog(
        context: context,
        builder: (context) {
          switch (option) {
            case 'Editar Evento':
              {
                return showEditCommentDialog();
              }
              break;
            case 'Excluir Evento':
              {
                return showDeleteCommentDialog();
              }
              break;
            default:
              {
                return Container();
              }
              break;
          }
        });
  }

  showEditCommentDialog() {
    return AlertDialog(
      title: Text("Editar Evento"),
      content: Text("Deseja editar este evento?"),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancelar")),
        FlatButton(
            onPressed: () {
              pr.show();
            },
            child: Text("Sim"))
      ],
    );
  }

  showDeleteCommentDialog() {
    return AlertDialog(
      title: Text("Excluir Evento"),
      content: Text("Deseja excluir este evento?"),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancelar")),
        FlatButton(
            onPressed: () async {
              pr.show();
              _bloc.deleteEvent(
                  event: event,
                  token: widget.token,
                  onDeleteSuccess: onDeleteSuccess,
                  onDeleteFail: onDeleteFail);
            },
            child: Text("Sim"))
      ],
    );
  }

  void onDeleteSuccess() {
    pr.hide();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Sucesso"),
            content: Text("Evento deletado com sucesso"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => EventsScreen()));
                  },
                  child: Text("OK")),
            ],
          );
        });
  }

  void onDeleteFail() {
    pr.hide();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Erro"),
            content: Text("Erro ao deletar a venda desejada"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("OK")),
            ],
          );
        });
  }

  void configureProgressDialog(BuildContext context) {
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
  void dispose() {
    _containerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    configureProgressDialog(context);
    timeDilation = 0.7;
    //print("detail");
    return new Theme(
      data: new ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.green[600],
        platform: Theme.of(context).platform,
      ),
      child: new Container(
        width: width.value,
        height: heigth.value,
        color: Colors.green[600],
        child: new Hero(
          tag: "event",
          child: new Card(
            color: Colors.transparent,
            child: new Container(
              alignment: Alignment.center,
              width: width.value,
              height: heigth.value,
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.circular(10.0),
              ),
              child: new Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                  new CustomScrollView(
                    shrinkWrap: false,
                    slivers: <Widget>[
                      new SliverAppBar(
                        actions: [
                          _bloc.isMine(widget.user.id, event.usuario.id)
                              ? Expanded(
                                  child: PopupMenuButton<String>(
                                  icon: Icon(
                                    Icons.arrow_drop_down_circle_outlined,
                                    color: Colors.black,
                                    size: 30.0,
                                  ),
                                  padding: EdgeInsets.only(left: 280),
                                  onSelected: handleClick,
                                  itemBuilder: (context) {
                                    return options.map((String choice) {
                                      return PopupMenuItem<String>(
                                        value: choice,
                                        child: Text(choice,
                                            style: TextStyle(fontSize: 14)),
                                      );
                                    }).toList();
                                  },
                                ))
                              : Container(),
                        ],
                        elevation: 0.0,
                        forceElevated: true,
                        leading: new IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: new Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: 30.0,
                          ),
                        ),
                        expandedHeight: _appBarHeight,
                        pinned: _appBarBehavior == AppBarBehavior.pinned,
                        floating: _appBarBehavior == AppBarBehavior.floating ||
                            _appBarBehavior == AppBarBehavior.snapping,
                        snap: _appBarBehavior == AppBarBehavior.snapping,
                        flexibleSpace: new FlexibleSpaceBar(
                          centerTitle: true,
                          title: new Text("Detalhes do Evento",
                              textAlign: TextAlign.center),
                          background: new Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              new Container(
                                width: width.value,
                                height: _appBarHeight,
                                decoration: new BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          event.imagens[0].imagemEncoded)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      new SliverList(
                        delegate: new SliverChildListDelegate(<Widget>[
                          new Container(
                            color: Colors.white,
                            child: new Padding(
                              padding: const EdgeInsets.all(35.0),
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Container(
                                    padding: new EdgeInsets.only(bottom: 20.0),
                                    alignment: Alignment.center,
                                    decoration: new BoxDecoration(
                                        color: Colors.white,
                                        border: new Border(
                                            bottom: new BorderSide(
                                                color: Colors.black12))),
                                    child: new Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        new Padding(
                                          padding: const EdgeInsets.only(
                                              top: 4.0, bottom: 8.0),
                                          child: new Text(
                                            "Informações do evento",
                                            style: new TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        new Row(
                                          children: <Widget>[
                                            new Icon(
                                              Icons.access_time,
                                              color: Colors.cyan,
                                            ),
                                            new Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: new Text(_dateFormat
                                                  .format(DateTime.parse(
                                                      event.data))),
                                            ),
                                          ],
                                        ),
                                        new Row(
                                          children: <Widget>[
                                            new Icon(
                                              Icons.home_sharp,
                                              color: Colors.cyan,
                                            ),
                                            new Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8,
                                                    left: 8,
                                                    bottom: 8,
                                                    top: 8),
                                                child: Text(
                                                    "${event.localizacao.cidade}, ${event.localizacao.bairro}, ${event.localizacao.estado}"),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  new Padding(
                                    padding: const EdgeInsets.only(
                                        top: 16.0, bottom: 8.0),
                                    child: new Text(
                                      "Descrição do evento",
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  new Text("${event.descricao}"),
                                  new Container(
                                    height: 100.0,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
