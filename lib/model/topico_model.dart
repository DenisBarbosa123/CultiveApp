// To parse this JSON data, do
//
//     final topicoModel = topicoModelFromJson(jsonString);

import 'dart:convert';

List<TopicoModel> topicoModelFromJson(List<dynamic> str) =>
    List<TopicoModel>.from(str.map((x) => TopicoModel.fromJson(x)));

String topicoModelToJson(List<TopicoModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TopicoModel {
  TopicoModel({
    this.id,
    this.nome,
    this.descricao,
  });

  int id;
  String nome;
  String descricao;

  factory TopicoModel.fromJson(Map<String, dynamic> json) => TopicoModel(
        id: json["id"],
        nome: json["nome"],
        descricao: json["descricao"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nome": nome,
        "descricao": descricao,
      };
}

//https://medium.com/flutter-community/parsing-complex-json-in-flutter-747c46655f51
