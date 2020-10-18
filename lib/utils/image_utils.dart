import 'dart:io';

import 'package:cultiveapp/model/publication_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ImageUtils{

  static Future<List<File>> getFileListFromAssetList(List<Asset> assetsList) async {
    List<File> files = [];
    for (Asset asset in assetsList) {
      final filePath =
      await FlutterAbsolutePath.getAbsolutePath(asset.identifier);
      files.add(File(filePath));
    }

    return files;
  }

  static Future<List<Imagens>> uploadListImage(List<File> imagensToSave) async {
    print("Uploading image list performing...");
    List<Imagens> savedImagens = [];
    StorageReference storageReference;
    for (File file in imagensToSave) {
      storageReference = FirebaseStorage.instance
          .ref()
          .child('publication_photos/${file.path.split("/").last}');
      StorageUploadTask uploadTask = storageReference.putFile(file);
      await uploadTask.onComplete;
      print('File Uploaded');
      var fileURL = await storageReference.getDownloadURL();
      Imagens imageSaved = Imagens();
      imageSaved.imagemEncoded = fileURL;
      savedImagens.add(imageSaved);
    }

    return savedImagens;
  }

  static Future<void> deletePublicationImages(List<Imagens> imageList) async {
    if (imageList == null) {
      return;
    }
    try {
      for (Imagens image in imageList) {
        StorageReference storageReference = await FirebaseStorage.instance
            .ref()
            .getStorage()
            .getReferenceFromUrl(image.imagemEncoded);
        storageReference.delete().then((value) => print("deleted post image"));
      }
    } catch (e) {
      print("Exception during delete post images");
    }
  }

}