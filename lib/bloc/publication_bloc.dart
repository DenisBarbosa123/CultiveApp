import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cultiveapp/model/publication_model.dart';
import 'package:cultiveapp/utils/path_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

enum SearchStatus { waiting, loading, done }

class PublicationBloc extends BlocBase {
  int offset = 0;
  int searchOffset = 0;
  List<Publication> publications = [];
  List<Publication> searchedPublications = [];
  StreamController<List<Publication>> _listPublicationsController =
      StreamController<List<Publication>>();

  Stream<List<Publication>> get output => _listPublicationsController.stream;

  StreamController<List<Publication>> _searchController =
      StreamController<List<Publication>>.broadcast();

  Stream<List<Publication>> get search => _searchController.stream;

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

  void getSearchListPublication(VoidCallback endOfList, int offset, int filter,
      String query, bool newSearch) async {
    if (offset != null) {
      searchOffset = offset;
    }
    if (newSearch) {
      _searchController.add(null);
      searchedPublications.clear();
    }
    Response response =
        await Dio().get(prepareEndPoint(filter, query, searchOffset));
    if (response.statusCode == 200) {
      searchOffset += 10;
      var jsonDecoded = response.data;
      List<Publication> newPubs = [];
      newPubs = jsonDecoded.map<Publication>((map) {
        return Publication.fromJson(map);
      }).toList();
      if (newPubs.isEmpty) {
        endOfList();
      }
      if (searchedPublications.isEmpty) {
        searchedPublications.addAll(newPubs);
      } else {
        searchedPublications += newPubs;
      }
      _searchController.add(searchedPublications);
    } else {
      throw Exception("Failed to load the publications searched!");
    }
  }

  @override
  void dispose() {
    super.dispose();
    _listPublicationsController.close();
    _searchController.close();
  }

  String prepareEndPoint(int filter, String query, int offset) {
    String endPoint;
    switch (filter.toString()) {
      case '0':
        {
          endPoint = PathConstants.getPostsByParameterAndType(
              'usuario', query, 'Geral', offset.toString());
        }
        break;
      case '1':
        {
          endPoint = PathConstants.getPostsByParameterAndType(
              'corpo', query, 'Geral', offset.toString());
        }
        break;
      case '2':
        {
          endPoint =
              PathConstants.getPostsByTopic('topico', query, offset.toString());
        }
        break;
      default:
        {
          endPoint = PathConstants.getPublicationsByParameters(
              tipo: "Geral", limit: "10", offset: "$offset");
        }
        break;
    }
    return endPoint;
  }
}
