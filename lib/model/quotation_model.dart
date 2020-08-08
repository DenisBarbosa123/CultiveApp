import 'package:flutter/cupertino.dart';

class Quotation {
  Map<String, dynamic> dataSet;
  List<dynamic> data;
  List<dynamic> firstPosition;
  List<dynamic> secondPosition;
  double firstPrice;
  double lastPrice;
  String updatedDate;

  Quotation(
      this.lastPrice,
      this.updatedDate,
      this.firstPrice,
      this.dataSet);

  Quotation.fromJson(Map<String, dynamic> json){
    debugPrint("Building a Quotation object");
    dataSet = json["dataset_data"];
    updatedDate = dataSet["end_date"];
    data = dataSet["data"];
    firstPosition = data[0];
    secondPosition = data[1];
    firstPrice = firstPosition[1];
    lastPrice = secondPosition[1];
  }
}