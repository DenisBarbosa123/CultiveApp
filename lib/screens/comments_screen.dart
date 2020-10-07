import 'package:cultiveapp/bloc/comment_bloc.dart';
import 'package:cultiveapp/model/publication_model.dart';
import 'package:cultiveapp/model/user_model.dart';
import 'package:cultiveapp/tiles/comment_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class CommentsScreen extends StatefulWidget {
  Publication _publication;
  Map<String, dynamic> _userInfo;

  CommentsScreen(this._publication, this._userInfo, this.openCommentScreen);

  Function openCommentScreen;

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  Publication _publication;
  var _commentController = TextEditingController();
  var _commentBloc = CommentBloc();
  List<Comentario> _comments;
  Map<String, dynamic> _userInfo;
  User user;
  String token;

  @override
  void initState() {
    super.initState();
    _publication = widget._publication;
    _comments = _publication.comentarios;
    _userInfo = widget._userInfo;
    user = _userInfo["user"];
    token = _userInfo["token"];
  }

  void deleteComment(Comentario comentario) {
    _commentBloc.deleteComment(user.id, _publication.id, token, comentario.id);
    _comments.remove(comentario);
    Navigator.of(context).pop();
    widget.openCommentScreen(_comments);
  }

  Future<void> editComment(Comentario comentario) async {
    Comentario editedComment = await _commentBloc.editComment(
        user.id, _publication.id, comentario.corpo, token, comentario.id);
    _comments.removeWhere((element) => element.id == comentario.id);
    _comments.add(editedComment);
    Navigator.of(context).pop();
    widget.openCommentScreen(_comments);
  }

  addNewComment() async {
    if (_commentController.text == "") {
      return;
    }
    debugPrint("add comentarios");

    Comentario createCommentRequest = Comentario();
    createCommentRequest.corpo = _commentController.text;
    createCommentRequest.usuario = user;
    createCommentRequest.data = DateTime.now().toIso8601String();
    Comentario createdComment = await _commentBloc.saveComment(
        user.id, _publication.id, createCommentRequest.corpo, token);
    setState(() {
      if (_comments == null) {
        _comments = [];
      }
      _comments.add(createdComment);
      _commentController.text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Comentários'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            _comments != null
                ? Flexible(
                    child: ListView.builder(
                      itemCount: _comments.length,
                      itemBuilder: (context, index) {
                        return CommentTile(_comments[index], _userInfo,
                            editComment, deleteComment);
                      },
                    ),
                  )
                : Center(child: Text("Está publicação não possui comentários")),
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration.collapsed(
                        fillColor: Colors.black26,
                        hintText: "Add um comentário"),
                    controller: _commentController,
                  )),
                  IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        addNewComment();
                      })
                ],
              ),
            )
          ],
        ));
  }
}
