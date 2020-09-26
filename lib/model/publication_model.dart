import 'package:cultiveapp/model/user_model.dart';

class Publication {
  int id;
  String titulo;
  String corpo;
  Status status;
  Status tipo;
  List<Imagens> imagens;
  User usuario;
  String data;

  Publication(
      {this.id,
      this.titulo,
      this.corpo,
      this.status,
      this.tipo,
      this.imagens,
      this.usuario,
      this.data});

  Publication.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titulo = json['titulo'];
    corpo = json['corpo'];
    status =
        json['status'] != null ? new Status.fromJson(json['status']) : null;
    tipo = json['tipo'] != null ? new Status.fromJson(json['tipo']) : null;
    if (json['imagens'] != null) {
      imagens = new List<Imagens>();
      json['imagens'].forEach((v) {
        imagens.add(new Imagens.fromJson(v));
      });
    }
    usuario =
        json['usuario'] != null ? new User.fromJson(json['usuario']) : null;
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['titulo'] = this.titulo;
    data['corpo'] = this.corpo;
    if (this.status != null) {
      data['status'] = this.status.toJson();
    }
    if (this.tipo != null) {
      data['tipo'] = this.tipo.toJson();
    }
    if (this.imagens != null) {
      data['imagens'] = this.imagens.map((v) => v.toJson()).toList();
    }
    if (this.usuario != null) {
      data['usuario'] = this.usuario.toJson();
    }
    data['data'] = this.data;
    return data;
  }
}

class Status {
  int id;
  String nome;
  String descricao;

  Status({this.id, this.nome, this.descricao});

  Status.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    descricao = json['descricao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['descricao'] = this.descricao;
    return data;
  }
}

class Imagens {
  int id;
  String imagemEncoded;

  Imagens({this.id, this.imagemEncoded});

  Imagens.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imagemEncoded = json['imagemEncoded'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['imagemEncoded'] = this.imagemEncoded;
    return data;
  }
}
