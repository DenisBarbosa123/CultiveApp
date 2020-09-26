import 'package:carousel_pro/carousel_pro.dart';
import 'package:cultiveapp/model/publication_model.dart';
import 'package:flutter/material.dart';

class PublicationTile extends StatefulWidget {
  final Publication _publication;
  PublicationTile(this._publication);
  @override
  _PublicationTileState createState() => _PublicationTileState(_publication);
}

class _PublicationTileState extends State<PublicationTile> {
  final Publication _publication;
  _PublicationTileState(this._publication);
  String firstHalf;
  String secondHalf;

  bool flag = true;

  @override
  void initState() {
    super.initState();
    checkDetails(_publication.corpo);
  }

  checkDetails(String detail) {
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: Card(
          borderOnForeground: true,
          elevation: 5,
          shadowColor: Colors.grey[400],
          child: Container(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: _publication.usuario.fotoPerfil == null
                          ? AssetImage("assets/person.png")
                          : NetworkImage(_publication.usuario.fotoPerfil),
                      backgroundColor: Colors.white,
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Text(
                      "${_publication.usuario.nome}",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                secondHalf.isEmpty
                    ? new Text(firstHalf)
                    : new Column(
                        children: <Widget>[
                          new Text(flag
                              ? (firstHalf + "...")
                              : (firstHalf + secondHalf)),
                          new InkWell(
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                new Text(
                                  flag ? "Mostrar mais" : "Mostrar Menos",
                                  style: new TextStyle(color: Colors.blue),
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
                SizedBox(
                  height: 15,
                ),
                AspectRatio(
                  aspectRatio: 0.9,
                  child: _publication.imagens == null
                      ? Container()
                      : Carousel(
                          images: _publication.imagens.map((imagem) {
                            return NetworkImage(imagem.imagemEncoded);
                          }).toList(),
                          dotSize: 4.0,
                          dotSpacing: 15.0,
                          dotBgColor: Colors.transparent,
                          dotColor: Colors.white,
                          dotIncreasedColor: Theme.of(context).primaryColor,
                          autoplay: false,
                        ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.comment,
                        color: Theme.of(context).primaryColor,
                        size: 35,
                      ),
                      onPressed: () {},
                    ),
                    Text("${_publication.data}",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.italic,
                          fontSize: 12,
                        ))
                  ],
                )
              ],
            ),
          )),
    );
  }
}
