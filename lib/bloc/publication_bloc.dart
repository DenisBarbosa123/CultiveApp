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
  Sink<List<Publication>> get input => _listPublicationsController.sink;
  Stream<List<Publication>> get output => _listPublicationsController.stream;

  void getListPublication(VoidCallback endOfList) async {
    debugPrint("Loading Publication From Cultive App server");
    debugPrint("offsetValue : $offset");
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
      _listPublicationsController.sink.add(publications);
    } else {
      throw Exception("Failed to load the publications!");
    }
  }

  @override
  void dispose() {
    _listPublicationsController.close();
  }
}
