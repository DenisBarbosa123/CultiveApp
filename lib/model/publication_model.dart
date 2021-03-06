import 'package:cultiveapp/model/user_model.dart';

class Publication {
  int id;
  String titulo;
  String corpo;
  Status status;
  Tipo tipo;
  List<Imagens> imagens;
  User usuario;
  String data;
  List<Topicos> topicos;
  List<Comentario> comentarios;

  Publication(
      {this.id,
      this.titulo,
      this.corpo,
      this.status,
      this.tipo,
      this.imagens,
      this.usuario,
      this.data,
      this.topicos});

  Publication.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titulo = json['titulo'];
    corpo = json['corpo'];
    status =
        json['status'] != null ? new Status.fromJson(json['status']) : null;
    tipo = json['tipo'] != null ? new Tipo.fromJson(json['tipo']) : null;
    if (json['imagens'] != null) {
      imagens = new List<Imagens>();
      json['imagens'].forEach((v) {
        imagens.add(new Imagens.fromJson(v));
      });
    }

    if (json['topicos'] != null) {
      topicos = new List<Topicos>();
      json['topicos'].forEach((v) {
        topicos.add(new Topicos.fromJson(v));
      });
    }

    if (json['comentarios'] != null) {
      comentarios = new List<Comentario>();
      json['comentarios'].forEach((v) {
        comentarios.add(new Comentario.fromJson(v));
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
    if (this.topicos != null) {
      data['topicos'] = this.topicos.map((v) => v.toJson()).toList();
    }
    if (this.usuario != null) {
      data['usuario'] = this.usuario.toJson();
    }
    if(this.comentarios != null) {
      data['comentarios'] = this.comentarios.map((v) => v.toJson()).toList();
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

class Tipo {
  int id;
  String nome;
  String descricao;

  Tipo({this.id, this.nome, this.descricao});

  Tipo.fromJson(Map<String, dynamic> json) {
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

class Comentario {
  int id;
  String data;
  User usuario;
  String corpo;

  Comentario({this.id, this.data, this.usuario, this.corpo});

  Comentario.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    data = json['data'];
    usuario =
    json['usuario'] != null ? new User.fromJson(json['usuario']) : null;
    corpo = json['corpo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['data'] = this.data;
    if (this.usuario != null) {
      data['usuario'] = this.usuario.toJson();
    }
    data['corpo'] = this.corpo;
    return data;
  }
}
