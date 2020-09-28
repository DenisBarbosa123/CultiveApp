import 'dart:async';
import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cultiveapp/model/publication_model.dart';
import 'package:cultiveapp/utils/path_constants.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class PublicationBloc extends BlocBase {
  int offset = 0;
  List<Publication> publications = [];
  StreamController<List<Publication>> _listPublicationsController =
      StreamController<List<Publication>>();
  Sink<List<Publication>> get input => _listPublicationsController.sink;
  Stream<List<Publication>> get output => _listPublicationsController.stream;

  void getListPublication(VoidCallback endOfList, bool isRefresh) async {
    if (isRefresh) offset = 0;
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
      _listPublicationsController.sink.add(publications);
    } else {
      throw Exception("Failed to load the publications!");
    }
  }

  Future<List<File>> getFileListFromAssetList(List<Asset> assetsList) async {
    List<File> files = [];
    for (Asset asset in assetsList) {
      final filePath =
          await FlutterAbsolutePath.getAbsolutePath(asset.identifier);
      files.add(File(filePath));
    }

    return files;
  }

  Future<List<Imagens>> uploadListImage(List<File> imagensToSave) async {
    debugPrint("Uploading image list performing...");
    List<Imagens> savedImagens = [];
    StorageReference storageReference;
    for (File file in imagensToSave) {
      storageReference = FirebaseStorage.instance
          .ref()
          .child('publication_photos/${file.path.split("/").last}');
      StorageUploadTask uploadTask = storageReference.putFile(file);
      await uploadTask.onComplete;
      debugPrint('File Uploaded');
      var fileURL = await storageReference.getDownloadURL();
      Imagens imageSaved = Imagens();
      imageSaved.imagemEncoded = fileURL;
      savedImagens.add(imageSaved);
    }

    return savedImagens;
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
        input.add(publications);
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

  @override
  void dispose() {
    _listPublicationsController.close();
  }
}
