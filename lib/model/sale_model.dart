import 'package:cultiveapp/model/publication_model.dart';
import 'package:cultiveapp/model/user_model.dart';

class Sale {
  int id;
  Status status;
  Tipo tipo;
  Produto produto;
  List<Imagens> imagens;
  User usuario;
  String data;

  Sale(
      {this.id,
      this.status,
      this.tipo,
      this.produto,
      this.imagens,
      this.usuario,
      this.data});

  Sale.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status =
        json['status'] != null ? new Status.fromJson(json['status']) : null;
    tipo = json['tipo'] != null ? new Tipo.fromJson(json['tipo']) : null;
    produto =
        json['produto'] != null ? new Produto.fromJson(json['produto']) : null;
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
    if (this.status != null) {
      data['status'] = this.status.toJson();
    }
    if (this.tipo != null) {
      data['tipo'] = this.tipo.toJson();
    }
    if (this.produto != null) {
      data['produto'] = this.produto.toJson();
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

class Produto {
  int id;
  String nome;
  double valor;
  Categoria categoria;
  double quantidade;

  Produto({this.id, this.nome, this.valor, this.categoria, this.quantidade});

  Produto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    valor = json['valor'];
    categoria = json['categoria'] != null
        ? new Categoria.fromJson(json['categoria'])
        : null;
    quantidade = json['quantidade'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['valor'] = this.valor;
    if (this.categoria != null) {
      data['categoria'] = this.categoria.toJson();
    }
    data['quantidade'] = this.quantidade;
    return data;
  }
}

class Categoria {
  int id;
  String nome;

  Categoria({this.id, this.nome});

  Categoria.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    return data;
  }
}