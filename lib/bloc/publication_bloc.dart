import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cultiveapp/model/publication_model.dart';
import 'package:cultiveapp/utils/path_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class PublicationBloc extends BlocBase {
  int offset = 0;
  List<Publication> publications = [];
  StreamController<List<Publication>> _listPublicationsController =
      StreamController<List<Publication>>();

  Stream<List<Publication>> get output => _listPublicationsController.stream;

  void getListPublication(VoidCallback endOfList) async {
    debugPrint("Loading Publication From Cultive App server");
    Response response = await Dio().get(
        PathConstants.getPublicationsByParameters(
            tipo: "Geral", limit: "10", offset: "$offset"));
    if (response.statusCode == 200) {
      debugPrint("Everything ok with Publication API response");
      offset += 10;
      var jsonDecoded = response.data;
      List<Publication> newPubs = [];
      newPubs = jsonDecoded.map<Publication>((map) {
        return Publication.fromJson(map);
      }).toList();
      if (newPubs.isEmpty) {
        endOfList();
      }
      if (publications.isEmpty) {
        publications.addAll(newPubs);
      } else {
        publications += newPubs;
      }
      _listPublicationsController.add(publications);
    } else {
      throw Exception("Failed to load the publications!");
    }
  }

  void createPublication(
      {int userId,
      String token,
      Publication publication,
      VoidCallback onSuccess,
      VoidCallback onFail}) async {
    debugPrint("Saving publication...");
    try {
      Response response = await Dio().post(
          PathConstants.createPublication(userId),
          data: publication.toJson(),
          options: RequestOptions(headers: {"Authorization": token}));
      if (response.statusCode == 200) {
        debugPrint("Publication saved with successfully");
        Publication publicationCreated = Publication.fromJson(response.data);
        publications.add(publicationCreated);
        _listPublicationsController.add(publications);
        onSuccess();
      } else {
        debugPrint("Fault during saving publication");
        onFail();
      }
    } catch (e) {
      debugPrint("Exception during saving publication" + e);
      onFail();
    }
  }

  Future<void> editPublication(
      {String token,
      String postBody,
      int postId,
      VoidCallback onSuccess,
      VoidCallback onFail}) async {
    Publication post = Publication(corpo: postBody);
    try {
      Response response = await Dio().put(PathConstants.editPublication(postId),
          options: RequestOptions(headers: {"Authorization": token}),
          data: post.toJson());
      if (response.statusCode == 200) {
        debugPrint("Publicaton edited with successfully");
        onSuccess();
      } else {
        debugPrint("Failure during post edition");
        onFail();
      }
    } catch (e) {
      debugPrint("Exception during post edition");
      onFail();
    }
  }

  Future<void> deletePublication(
      {String token,
      int postId,
      VoidCallback onDeleteSuccess,
      VoidCallback onDeleteFail}) async {
    debugPrint("Delete performing to exclude post with id $postId");
    try {
      Response response = await Dio().delete(
          PathConstants.deletePublication(postId),
          options: RequestOptions(headers: {"Authorization": token}));
      if (response.statusCode == 204) {
        debugPrint("Post was excluded successfully");
        onDeleteSuccess();
      } else {
        debugPrint("Error during post exclusion");
        onDeleteFail();
      }
    } catch (e) {
      debugPrint("Exception during post exclusion");
      onDeleteFail();
    }
  }

  bool isMine(int myUserId, int userId) {
    return myUserId == userId;
  }

  @override
  void dispose() {
    super.dispose();
    _listPublicationsController.close();
  }
}
