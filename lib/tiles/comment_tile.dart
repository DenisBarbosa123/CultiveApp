import 'package:cultiveapp/bloc/comment_bloc.dart';
import 'package:cultiveapp/model/publication_model.dart';
import 'package:cultiveapp/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class CommentTile extends StatefulWidget {
  final Comentario _comentario;
  final Map<String, dynamic> _userInfo;
  Function deleteComment;
  Function editComment;

  CommentTile(this._comentario, this._userInfo, this.editComment,
      this.deleteComment);

  @override
  _CommentTileState createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  final DateFormat _dateFormat = DateFormat('dd-MM-yyyy');
  Comentario _comentario;
  Map<String, dynamic> _userInfo;
  String firstHalf;
  String secondHalf;
  bool flag = true;
  CommentBloc _bloc = CommentBloc();
  User user;
  String token;

  bool editModel = false;
  TextEditingController _editingController = TextEditingController();

  List<String> options = ['Editar Comentário', 'Excluir Comentário'];

  void handleClick(String option) {
    showDialog(
        context: context,
        builder: (context) {
          switch (option) {
            case 'Editar Comentário':
              {
                return showEditCommentDialog();
              }
              break;
            case 'Excluir Comentário':
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
      title: Text("Editar Comentário"),
      content: Text("Deseja editar esta comentário?"),
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
                _editingController.text = _comentario.corpo;
                editModel = true;
              });
            },
            child: Text("Sim"))
      ],
    );
  }

  showDeleteCommentDialog() {
    return AlertDialog(
      title: Text("Excluir Comentário"),
      content: Text("Deseja excluir esta comentário?"),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancelar")),
        FlatButton(
            onPressed: () async {
              Navigator.pop(context);
              widget.deleteComment(_comentario);
            },
            child: Text("Sim"))
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _comentario = widget._comentario;
    _userInfo = widget._userInfo;
    checkDetails(_comentario.corpo);
    user = _userInfo["user"];
    token = _userInfo["token"];
  }

  checkDetails(String detail) {
    if (detail.length > 100) {
      firstHalf = detail.substring(0, 100);
      secondHalf = detail.substring(100, detail.length);
    } else {
      firstHalf = detail;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        radius: 20,
                        backgroundImage: _comentario.usuario.fotoPerfil == null
                            ? AssetImage("assets/person.png")
                            : NetworkImage(_comentario.usuario.fotoPerfil),
                        backgroundColor: Colors.white,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "${_comentario.usuario.nome}",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                      _bloc.isMine(user.id, _comentario.usuario.id)
                          ? Expanded(
                          child: PopupMenuButton<String>(
                            padding: EdgeInsets.only(left: 120),
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
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  editModel == false ? secondHalf.isEmpty
                      ? new Text(firstHalf, textAlign: TextAlign.left,)
                      : new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(flag
                          ? (firstHalf + "...")
                          : (firstHalf + secondHalf),
                        textAlign: TextAlign.left,),
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
                  ) : editModeScreen(),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                      "${_dateFormat.format(DateTime.parse(_comentario.data))}",
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
                      ))
                ],
              )),
        ));
  }

  Widget editModeScreen() {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: TextField(
            style: TextStyle(fontSize: 12),
            keyboardType: TextInputType.multiline,
            controller: _editingController,
            decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 0.5)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 0.5)),
              contentPadding: EdgeInsets.all(5),
            ),
            minLines: 1,
            maxLines: 100
          ),),
          Column(
            children: [
              IconButton(
                  icon: Icon(Icons.check, size: 30, color: Colors.black),
                  onPressed: () {
                    setState(() {
                      editModel = false;
                      if(_editingController.text != ''){
                        _comentario.corpo = _editingController.text;
                        checkDetails(_editingController.text);
                        widget.editComment(_comentario);
                      }
                    });
                  }),
              IconButton(
                  icon: Icon(Icons.cancel_outlined, size: 25, color: Colors.black),
                  onPressed: () {
                    setState(() {
                      _editingController.text = '';
                      editModel = false;
                    });
                  }),
            ],
          )
        ],
      ),
    );
  }
}
