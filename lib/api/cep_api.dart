import 'dart:async';
import 'package:dio/dio.dart';

class CepAPI {
  String url(String cep) => "https://viacep.com.br/ws/$cep/json/";

  Future<Cep> searchCep(String cep) async {
    Response response = await Dio().get(url(cep));
    if (response.statusCode == 200) {
      return Cep.fromJson(response.data);
    }
    return null;
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
