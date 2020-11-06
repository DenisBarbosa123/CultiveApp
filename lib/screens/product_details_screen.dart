import 'package:cultiveapp/model/sale_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Sale _sale;
  ProductDetailsScreen(this._sale);
  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  Sale _sale;
  String firstHalf;
  String secondHalf;
  bool flag = true;

  @override
  void initState() {
    super.initState();
    _sale = widget._sale;
    checkDetails(_sale.corpo);
  }

  checkDetails(String detail) {
    if (detail == null) {
      return;
    }
    if (detail.length > 50) {
      firstHalf = detail.substring(0, 50);
      secondHalf = detail.substring(50, detail.length);
    } else {
      firstHalf = detail;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DETALHES DO PRODUTO"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView(
        children: [
          Card(
              margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              elevation: 5,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Produto",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: Colors.grey[600],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Nome", style: TextStyle(fontSize: 17)),
                        Text("${_sale.produto.nome}",
                            style: TextStyle(fontSize: 17)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Valor", style: TextStyle(fontSize: 17)),
                        Text("R\$ ${_sale.produto.valor.toStringAsFixed(2)}",
                            style: TextStyle(fontSize: 17)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Quantidade", style: TextStyle(fontSize: 17)),
                        Text("${_sale.produto.quantidade.toInt()}",
                            style: TextStyle(fontSize: 17)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Categoria", style: TextStyle(fontSize: 17)),
                        Text("${_sale.produto.categoria.nome}",
                            style: TextStyle(fontSize: 17)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _sale.corpo != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Descrição", style: TextStyle(fontSize: 17)),
                              secondHalf.isEmpty
                                  ? new Text(
                                      firstHalf,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 14),
                                    )
                                  : new Column(
                                      children: <Widget>[
                                        new Text(
                                          flag
                                              ? (firstHalf + "...")
                                              : (firstHalf + secondHalf),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        new InkWell(
                                          child: new Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              new Text(
                                                flag
                                                    ? "Mostrar mais"
                                                    : "Mostrar Menos",
                                                style: new TextStyle(
                                                    color: Colors.blue),
                                              ),
                                            ],
                                          ),
                                          onTap: () {
                                            setState(() {
                                              flag = !flag;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                            ],
                          )
                        : Container(),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Anunciante",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    Divider(
                      color: Colors.grey[600],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Nome", style: TextStyle(fontSize: 17)),
                        Text("${_sale.usuario.nome}",
                            style: TextStyle(fontSize: 17)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Localização", style: TextStyle(fontSize: 17)),
                        Text(
                            "${_sale.usuario.localizacao.cidade} - ${_sale.usuario.localizacao.estado}",
                            style: TextStyle(fontSize: 17)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Contato", style: TextStyle(fontSize: 17)),
                        Text("${_sale.usuario.celular}",
                            style: TextStyle(fontSize: 17)),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text("Entrar em contato",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    Divider(
                      color: Colors.grey[600],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                launch("tel: ${_sale.usuario.celular}");
                              },
                              icon: Icon(Icons.phone, size: 40),
                            ),
                            Text("Ligar")
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  String tel = _sale.usuario.celular
                                      .replaceAll("(", "")
                                      .replaceAll(")", "")
                                      .replaceAll("-", "");
                                  launch(
                                      "https://api.whatsapp.com/send?phone=55$tel&text=Ola,%20tudo%20bem?");
                                },
                                child: Image.network(
                                  "https://img.icons8.com/ios/452/whatsapp.png",
                                  height: 40,
                                  width: 40,
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            Text("Whatsapp")
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
