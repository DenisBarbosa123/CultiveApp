
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

const request = "https://api.hgbrasil.com/finance?format=json&key=896a64e5";
class DolarAPI {
   Future<double> getDolarPrice() async {
     debugPrint("Get dolar price");
    Response json = await Dio().get(request);
    double dolar = json.data["results"]["currencies"]["USD"]["buy"];
    return dolar;
  }
}