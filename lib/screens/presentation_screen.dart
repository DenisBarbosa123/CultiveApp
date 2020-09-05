import 'package:cultiveapp/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PresentationScreen extends StatefulWidget {
  PageController _pageController;
  PresentationScreen(this._pageController);

  @override
  _PresentationScreenState createState() => _PresentationScreenState();
}

class _PresentationScreenState extends State<PresentationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: CustomDrawer(this.widget._pageController),
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "PÁGINA INICIAL",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: ListView(
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: ClipPath(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 280,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 0.19),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              colorFilter: new ColorFilter.mode(
                                  Colors.grey.withOpacity(0.3),
                                  BlendMode.dstATop),
                              image: AssetImage("assets/compra-venda.png"))),
                    ),
                    clipper: CustomClipPath(),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Image.asset("assets/leaf.png", width: 50, height: 30),
                          Text("Cultive App",
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: Text(
                        "Semeando ideias cultivando oportunidades",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 25.0,
                            color: Colors.black87,
                            fontWeight: FontWeight.w800),
                      ),
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                    height: 300,
                    child: Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: Text(
                          "Promova seu produto ou compre direto do produtor",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w800),
                        ))),
                SizedBox(
                    height: 300,
                    child: Padding(
                        padding: EdgeInsets.only(right: 30),
                        child: Text(
                          "Compartilhe seu conhecimento ou obtenha informações para tomada de decisão",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w800),
                        ))),
                SizedBox(
                    height: 300,
                    child: Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: Text(
                          "Divulgue ou fique sabendo de eventos relacionados ao agronegócio",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w800),
                        ))),
                SizedBox(
                    height: 300,
                    child: Padding(
                        padding: EdgeInsets.only(right: 30),
                        child: Text(
                          "Fique por dentro do clima de sua cidade, cotações de produtos e também sobre notícias sobre o agronegócio",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w800),
                        ))),
              ],
            )),
          ],
        ));
  }
}

class CustomClipPath extends CustomClipper<Path> {
  var radius = 10.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 4, size.height - 40, size.width / 2, size.height - 20);
    path.quadraticBezierTo(
        3 / 4 * size.width, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
