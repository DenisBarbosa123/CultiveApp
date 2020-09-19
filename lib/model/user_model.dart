class User {
  int id;
  String nome;
  String email;
  String telefone;
  String senha;
  String celular;
  Localizacao localizacao;
  String fotoPerfil;
  List<Topicos> topicos;

  User(
      {this.id,
      this.nome,
      this.email,
      this.telefone,
      this.senha,
      this.celular,
      this.localizacao,
      this.fotoPerfil,
      this.topicos});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    email = json['email'];
    telefone = json['telefone'];
    senha = json['senha'];
    celular = json['celular'];
    localizacao = json['localizacao'] != null
        ? new Localizacao.fromJson(json['localizacao'])
        : null;
    fotoPerfil = json['fotoPerfil'];
    if (json['topicos'] != null) {
      topicos = new List<Topicos>();
      json['topicos'].forEach((v) {
        topicos.add(new Topicos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['email'] = this.email;
    data['telefone'] = this.telefone;
    data['senha'] = this.senha;
    data['celular'] = this.celular;
    if (this.localizacao != null) {
      data['localizacao'] = this.localizacao.toJson();
    }
    data['fotoPerfil'] = this.fotoPerfil;
    if (this.topicos != null) {
      data['topicos'] = this.topicos.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Localizacao {
  String bairro;
  String cidade;
  String estado;

  Localizacao({this.bairro, this.cidade, this.estado});

  Localizacao.fromJson(Map<String, dynamic> json) {
    bairro = json['bairro'];
    cidade = json['cidade'];
    estado = json['estado'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bairro'] = this.bairro;
    data['cidade'] = this.cidade;
    data['estado'] = this.estado;
    return data;
  }
}

class Topicos {
  String nome;
  String descricao;

  Topicos({this.nome, this.descricao});

  Topicos.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    descricao = json['descricao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['descricao'] = this.descricao;
    return data;
  }

  static List<Topicos> buildTopicList(List<String> stringList) {
    if (stringList.isEmpty) {
      return [];
    }
    List<Topicos> topicList = List();
    stringList.forEach((element) {
      Topicos topico = Topicos(nome: element);
      topicList.add(topico);
    });
    return topicList;
  }
}
