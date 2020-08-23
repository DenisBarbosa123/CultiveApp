import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class Base64Convert {
  /*
  * Provides a base64 String in order to convert Image File to base64 String  *
   */
  static Future<String> convertImagePathToBase64(PickedFile pickedFile) async {
    if (pickedFile == null) {
      return null;
    }
    final imageBytes = await File(pickedFile.path).readAsBytes();
    return base64.encode(imageBytes);
  }
}
