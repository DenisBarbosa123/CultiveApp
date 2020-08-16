import 'dart:io';
import 'dart:convert';
class Base64Convert {

  /*
  * Provides a base64 String in order to convert Image File to base64 String  *
   */
   static String convertImagePathToBase64(File imageFilePath){
     File imageFile = new File(imageFilePath.toString());
     List<int> imageBytes = imageFile.readAsBytesSync();
     return base64.encode(imageBytes);
  }
}