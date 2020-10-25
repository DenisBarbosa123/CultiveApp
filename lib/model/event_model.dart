import 'package:cultiveapp/model/publication_model.dart';
import 'package:cultiveapp/model/user_model.dart';

class Event {
  int id;
  String data;
  String descricao;
  Localizacao localizacao;
  User usuario;
  Status status;
  List<Imagens> imagens;
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
    descricao = json['descricao'];
    localizacao = json['localizacao'] != null
        ? new Localizacao.fromJson(json['localizacao'])
        : null;
    usuario =
        json['usuario'] != null ? new User.fromJson(json['usuario']) : null;
    status =
        json['status'] != null ? new Status.fromJson(json['status']) : null;
    if (json['imagens'] != null) {
      imagens = new List<Imagens>();
      json['imagens'].forEach((v) {
        imagens.add(new Imagens.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['data'] = this.data;
    data['descricao'] = this.descricao;
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
    if (this.imagens != null) {
      data['imagens'] = this.imagens.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
