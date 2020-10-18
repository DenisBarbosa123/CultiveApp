import 'package:cultiveapp/model/sale_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailsScreen extends StatelessWidget {
  Sale _sale;

  ProductDetailsScreen(this._sale);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DETALHES DO PRODUTO"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Card(
          margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          elevation: 5,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Produto",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                    Text("${_sale.produto.nome}", style: TextStyle(fontSize: 17)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Valor",style: TextStyle(fontSize: 17)),
                    Text("R\$ ${_sale.produto.valor}", style: TextStyle(fontSize: 17)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Quantidade", style: TextStyle(fontSize: 17)),
                    Text("${_sale.produto.quantidade.toInt()}", style: TextStyle(fontSize: 17)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Categoria", style: TextStyle(fontSize: 17)),
                    Text("${_sale.produto.categoria.nome}", style: TextStyle(fontSize: 17)),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Text("Anunciante",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
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
                    Text("${_sale.usuario.nome}", style: TextStyle(fontSize: 17)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Localização", style: TextStyle(fontSize: 17)),
                    Text("${_sale.usuario.localizacao.cidade} - ${_sale.usuario.localizacao.estado}", style: TextStyle(fontSize: 17)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Contato", style: TextStyle(fontSize: 17)),
                    Text("${_sale.usuario.celular}", style: TextStyle(fontSize: 17)),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Text("Entrar em contato",
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
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
                    Column(children: [
                      GestureDetector(
                          onTap: (){
                            String tel = _sale.usuario.celular.replaceAll("(", "").replaceAll(")", "").replaceAll("-", "");
                            launch("https://api.whatsapp.com/send?phone=55$tel&text=Ola,%20tudo%20bem?");
                          },
                          child: Image.network("https://img.icons8.com/ios/452/whatsapp.png", height: 40,width: 40,)
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text("Whatsapp")
                    ],),

                  ],
                )
              ],
            ),
          )),
    );
  }
}
