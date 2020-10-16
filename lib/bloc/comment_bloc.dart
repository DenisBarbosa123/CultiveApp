import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cultiveapp/model/publication_model.dart';
import 'package:cultiveapp/utils/path_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CommentBloc extends BlocBase {
  Future<Comentario> saveComment(
      int userId, int postId, String commentBody, String token) async {
    Comentario comentario = Comentario();
    comentario.corpo = commentBody;
    try {
      Response response = await Dio().post(
          PathConstants.createComment(userId, postId),
          options: RequestOptions(headers: {'Authorization': token}),
          data: comentario.toJson());
      if (response.statusCode == 200) {
        debugPrint("Comment creation successfully");
        return Comentario.fromJson(response.data);
      } else {
        debugPrint("Comment creation fail");
      }
    } catch (e) {
      debugPrint("Exception during comment creation");
    }
  }

  Future<Comentario> editComment(int userId, int postId, String commentBody,
      String token, int commentId) async {
    Comentario comentario = Comentario();
    comentario.corpo = commentBody;
    try {
      Response response = await Dio().put(
          PathConstants.editComment(userId, postId, commentId),
          options: RequestOptions(headers: {'Authorization': token}),
          data: comentario.toJson());
      if (response.statusCode == 200) {
        debugPrint("Comment edited successfully");
        return Comentario.fromJson(response.data);
      } else {
        debugPrint("Comment edited fail");
      }
    } catch (e) {
      debugPrint("Exception during comment edition");
    }
  }

  Future<void> deleteComment(
      int userId, int postId, String token, int commentId) async {
    try {
      String path = PathConstants.deleteComment(userId, postId, commentId);
      Response response = await Dio().delete(path,
          options: RequestOptions(headers: {'Authorization': token}));
      if (response.statusCode == 204) {
        debugPrint("Comment exclusion successfully");
      } else {
        debugPrint("Comment exclusion fail");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  bool isMine(int myUserId, int userId) {
    return myUserId == userId;
  }
}
