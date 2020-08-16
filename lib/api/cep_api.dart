
import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:dio/dio.dart';

class CepAPI extends BlocBase{
  final StreamController<String> _streamController = StreamController<String>();
  Sink<String> get input => _streamController.sink;
  Stream<Cep> get output => _streamController.stream
      .where((cep) => cep.length > 7)
      .asyncMap((cep) => _searchCep(cep));

  String url(String cep) => "https://viacep.com.br/ws/$cep/json/";

  Future<Cep> _searchCep(String cep) async{
    Response response = await Dio().get(url(cep));
    return Cep.fromJson(response.data);
  }

  @override
  void dispose() {
    _streamController.close();
  }
}

class Cep {
  String cep;
  String bairro;
  String localidade;
  String uf;

  Cep({this.cep, this.bairro, this.localidade, this.uf});

  Cep.fromJson(Map<String, dynamic> json) {
    cep = json['cep'];
    bairro = json['bairro'];
    localidade = json['localidade'];
    uf = json['uf'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cep'] = this.cep;
    data['bairro'] = this.bairro;
    data['localidade'] = this.localidade;
    data['uf'] = this.uf;
    return data;
  }
}
