import 'package:carousel_pro/carousel_pro.dart';
import 'package:cultiveapp/bloc/publication_bloc.dart';
import 'package:cultiveapp/model/publication_model.dart';
import 'package:cultiveapp/model/user_model.dart';
import 'package:cultiveapp/screens/comments_screen.dart';
import 'package:cultiveapp/screens/publication_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

class PublicationTile extends StatefulWidget {
  final Publication _publication;
  final Map<String, dynamic> _userInfo;

  PublicationTile(this._publication, this._userInfo);

  @override
  _PublicationTileState createState() => _PublicationTileState(_publication);
}

class _PublicationTileState extends State<PublicationTile> {
  final Publication _publication;

  final DateFormat _dateFormat = DateFormat('dd-MM-yyyy');

  ProgressDialog pr;

  _PublicationTileState(this._publication);

  String firstHalf;
  String secondHalf;
  User _user;
  String token;

  PublicationBloc _publicationBloc;
  List<String> options = ['Editar Publicação', 'Excluir Publicação'];

  bool flag = true;

  bool isEditing = false;
  var descriptionTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _publicationBloc = PublicationBloc();
    checkDetails(_publication.corpo);
    _user = widget._userInfo["user"];
    token = widget._userInfo["token"];
  }

  void handleClick(String option) {
    showDialog(
        context: context,
        builder: (context) {
          switch (option) {
            case 'Editar Publicação':
              {
                return showEditPostDialog();
              }
              break;
            case 'Excluir Publicação':
              {
                return showDeletePostDialog();
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

  showEditPostDialog() {
    return AlertDialog(
      title: Text("Editar Publicação"),
      content: Text("Deseja editar esta publicação?"),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancelar")),
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                descriptionTextController.text = _publication.corpo;
                isEditing = true;
              });
            },
            child: Text("Sim"))
      ],
    );
  }

  showDeletePostDialog() {
    return AlertDialog(
      title: Text("Excluir Publicação"),
      content: Text("Deseja excluir esta publicação?"),
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
              await _publicationBloc
                  .deletePublicationImages(_publication.imagens);
              _publicationBloc.deletePublication(
                  token: token,
                  postId: _publication.id,
                  onDeleteFail: onDeleteFail,
                  onDeleteSuccess: onDeleteSuccess);
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
            content: Text("Publicação deletada com sucesso"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => PublicationScreen()));
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
            content: Text("Erro ao deletar a publicação desejada"),
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

  checkDetails(String detail) {
    if (detail.length > 50) {
      firstHalf = detail.substring(0, 50);
      secondHalf = detail.substring(50, detail.length);
    } else {
      firstHalf = detail;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    configureProgressDialog(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: Card(
          borderOnForeground: true,
          elevation: 5,
          shadowColor: Colors.grey[400],
          child: Container(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: _publication.usuario.fotoPerfil == null
                          ? AssetImage("assets/person.png")
                          : NetworkImage(_publication.usuario.fotoPerfil),
                      backgroundColor: Colors.white,
                    ),
                    SizedBox(
                      width: 18,
                    ),
                    Text(
                      "${_publication.usuario.nome}",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    _publicationBloc.isMine(_user.id, _publication.usuario.id)
                        ? Expanded(
                            child: PopupMenuButton<String>(
                            onSelected: handleClick,
                            padding: EdgeInsets.only(left: 50),
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
                ),
                SizedBox(
                  height: 15,
                ),
                isEditing
                    ? editModeScreen()
                    : secondHalf.isEmpty
                        ? new Text(
                            firstHalf,
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 14),
                          )
                        : new Column(
                            children: <Widget>[
                              new Text(
                                flag
                                    ? (firstHalf + "...")
                                    : (firstHalf + secondHalf),
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 14),
                              ),
                              new InkWell(
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    new Text(
                                      flag ? "Mostrar mais" : "Mostrar Menos",
                                      style: new TextStyle(color: Colors.blue),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    flag = !flag;
                                  });
                                },
                              ),
                            ],
                          ),
                SizedBox(
                  height: 15,
                ),
                _publication.imagens != null
                    ? AspectRatio(
                        aspectRatio: 0.9,
                        child: Carousel(
                          images: _publication.imagens.map((imagem) {
                            return NetworkImage(imagem.imagemEncoded);
                          }).toList(),
                          dotSize: 4.0,
                          dotSpacing: 15.0,
                          dotBgColor: Colors.transparent,
                          dotColor: Colors.white,
                          dotIncreasedColor: Theme.of(context).primaryColor,
                          autoplay: false,
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.comment,
                        color: Theme.of(context).primaryColor,
                        size: 35,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CommentsScreen(_publication,
                                widget._userInfo, openCommentScreen)));
                      },
                    ),
                    Text(
                        "${_dateFormat.format(DateTime.parse(_publication.data))}",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.italic,
                          fontSize: 12,
                        ))
                  ],
                )
              ],
            ),
          )),
    );
  }

  void openCommentScreen(List<Comentario> commentList) {
    _publication.comentarios = commentList;
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            CommentsScreen(_publication, widget._userInfo, openCommentScreen)));
  }

  Widget editModeScreen() {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextField(
                style: TextStyle(fontSize: 12),
                keyboardType: TextInputType.multiline,
                controller: descriptionTextController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 0.5)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 0.5)),
                  contentPadding: EdgeInsets.all(5),
                ),
                minLines: 1,
                maxLines: 100),
          ),
          Column(
            children: [
              IconButton(
                  icon: Icon(Icons.check, size: 30, color: Colors.black),
                  onPressed: () {
                    setState(() {
                      isEditing = false;
                      if (descriptionTextController.text != '') {
                        pr.show();
                        _publicationBloc.editPublication(
                            token: token,
                            postBody: descriptionTextController.text,
                            postId: _publication.id,
                            onFail: onFailEditing,
                            onSuccess: onSuccessEditing);
                      }
                    });
                  }),
              IconButton(
                  icon: Icon(Icons.cancel_outlined,
                      size: 25, color: Colors.black),
                  onPressed: () {
                    setState(() {
                      descriptionTextController.text = '';
                      isEditing = false;
                    });
                  }),
            ],
          )
        ],
      ),
    );
  }

  void onSuccessEditing() {
    pr.hide();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => PublicationScreen()));
  }

  void onFailEditing() {
    pr.hide();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Erro"),
            content: Text("Erro ao editar a publicação desejada"),
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
}
