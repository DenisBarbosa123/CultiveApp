import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cultiveapp/api/dolar_api.dart';
import 'package:cultiveapp/model/quotation_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

const String API_KEY = "TfvPST_D3yKtyq6mxkAj";

class QuotationBloc extends BlocBase {
  DolarAPI _dolarAPI = DolarAPI();

  //CORN
  final StreamController<Quotation> _cornStreamController =
      StreamController<Quotation>();
  Sink<Quotation> get inputCorn => _cornStreamController.sink;
  Stream<Quotation> get outputCorn => _cornStreamController.stream;

  //SOY
  final StreamController<Quotation> _soyStreamController =
      StreamController<Quotation>();
  Sink<Quotation> get inputSoy => _soyStreamController.sink;
  Stream<Quotation> get outputSoy => _soyStreamController.stream;

  //WHEAT
  final StreamController<Quotation> _wheatStreamController =
      StreamController<Quotation>();
  Sink<Quotation> get inputWheat => _wheatStreamController.sink;
  Stream<Quotation> get outputWheat => _wheatStreamController.stream;

  //MILK
  final StreamController<Quotation> _milkStreamController =
      StreamController<Quotation>();
  Sink<Quotation> get inputMilk => _milkStreamController.sink;
  Stream<Quotation> get outputMilk => _milkStreamController.stream;

  //CATTLE
  final StreamController<Quotation> _cattleStreamController =
      StreamController<Quotation>();
  Sink<Quotation> get inputCattle => _cattleStreamController.sink;
  Stream<Quotation> get outputCattle => _cattleStreamController.stream;

  //COFFEE_A
  final StreamController<Quotation> _coffeeStreamController =
      StreamController<Quotation>();
  Sink<Quotation> get inputCoffee => _coffeeStreamController.sink;
  Stream<Quotation> get outputCoffee => _coffeeStreamController.stream;

  void getCornPrice(double dolarValue) async {
    Quotation quotation = await _getQuotation("CORN", dolarValue);
    _cornStreamController.add(quotation);
  }

  void getSoyPrice(double dolarValue) async {
    Quotation quotation = await _getQuotation("SOYBEAN", dolarValue);
    _soyStreamController.add(quotation);
  }

  void getWheatPrice(double dolarValue) async {
    Quotation quotation = await _getQuotation("WHEAT_R", dolarValue);
    _wheatStreamController.add(quotation);
  }

  void getMilkPrice(double dolarValue) async {
    Quotation quotation = await _getQuotation("MILK", dolarValue);
    _milkStreamController.add(quotation);
  }

  void getCattlePrice(double dolarValue) async {
    Quotation quotation = await _getQuotation("CATTLE", dolarValue);
    _cattleStreamController.add(quotation);
  }

  void getCoffeePrice(double dolarValue) async {
    Quotation quotation = await _getQuotation("COFFEE_A", dolarValue);
    _coffeeStreamController.add(quotation);
  }

  Future<Quotation> _getQuotation(String productName, double dolarValue) async {
    debugPrint("Get Quotation");

    Response response = await Dio().get(_getUrl(productName));

    Quotation quotation = Quotation.fromJson(response.data);
    quotation.firstPrice = quotation.firstPrice * dolarValue;
    quotation.lastPrice = quotation.lastPrice * dolarValue;

    return quotation;
  }

  _getUrl(String productName) =>
      "https://www.quandl.com/api/v3/datasets/CEPEA/$productName/data.json?api_key=$API_KEY&limit=2";
  @override
  void dispose() {
    super.dispose();
    _cornStreamController.close();
    _soyStreamController.close();
    _wheatStreamController.close();
    _milkStreamController.close();
    _cattleStreamController.close();
    _coffeeStreamController.close();
  }

  Future<double> getDolarPrice() async {
    debugPrint("Get Dolar Quotation");
    return await _dolarAPI.getDolarPrice();
  }
}
