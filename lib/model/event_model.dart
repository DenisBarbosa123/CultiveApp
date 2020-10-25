import 'package:cultiveapp/model/publication_model.dart';
import 'package:cultiveapp/model/user_model.dart';

class Event {
  int id;
  String data;
  String descricao;
  Localizacao localizacao;
  User usuario;
  Status status;
  String imagem;
  String titulo;

  Event(
      {this.id,
      this.data,
      this.descricao,
      this.localizacao,
      this.usuario,
      this.status});

  Event.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titulo = json['titulo'];
    data = json['data'];
    imagem = json['imagem'];
    descricao = json['descricao'];
    localizacao = json['localizacao'] != null
        ? new Localizacao.fromJson(json['localizacao'])
        : null;
    usuario =
        json['usuario'] != null ? new User.fromJson(json['usuario']) : null;
    status =
        json['status'] != null ? new Status.fromJson(json['status']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['data'] = this.data;
    data['descricao'] = this.descricao;
    data['imagem'] = this.imagem;
    data['titulo'] = this.titulo;
    if (this.localizacao != null) {
      data['localizacao'] = this.localizacao.toJson();
    }
    if (this.usuario != null) {
      data['usuario'] = this.usuario.toJson();
    }
    if (this.status != null) {
      data['status'] = this.status.toJson();
    }
    return data;
  }
}
