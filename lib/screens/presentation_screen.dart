import 'package:cultiveapp/screens/events_screen.dart';
import 'package:cultiveapp/screens/login_screen.dart';
import 'package:cultiveapp/screens/publication_screen.dart';
import 'package:cultiveapp/screens/sales_screen.dart';
import 'package:cultiveapp/screens/subscription/screen1.dart';
import 'package:cultiveapp/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PresentationScreen extends StatefulWidget {
  @override
  _PresentationScreenState createState() => _PresentationScreenState();
}

class _PresentationScreenState extends State<PresentationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: CustomDrawer(),
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
                                  Colors.grey.withOpacity(0.5),
                                  BlendMode.dstATop),
                              image: AssetImage("assets/splash-image.jpg"))),
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
                        "Semeando ideias \nCultivando oportunidades",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 25.0,
                            color: Colors.black87,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RaisedButton(
                          color: Colors.green[500],
                          child: Text("CADASTRAR",
                              style: TextStyle(fontWeight: FontWeight.w800)),
                          textColor: Colors.black87,
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Screen1()));
                          },
                        ),
                        RaisedButton(
                          color: Colors.green[500],
                          child: Text(
                            "LOGIN",
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                          textColor: Colors.black87,
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                          },
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Promova seu produto ou compre direto do produtor",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Divulgue seu produto \ndentro do Cultive App, \ne tenha também \na possibilidade de \ncomprar produtos\n de outros produtores",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                      Image.asset("assets/vegetal.png",
                          width: 100, height: 100),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  RaisedButton(
                    color: Colors.green[500],
                    child: Text(
                      "VENDAS",
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    textColor: Colors.black87,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SalesScreen()));
                    },
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Compartilhe seu conhecimento ou obtenha informações para tomada de decisão",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset("assets/ecologia-da-informacao.png",
                          width: 100, height: 100),
                      Text(
                        "Compartilhe suas \nexperiências \ncom outros produtores\n e obtenha informações \npara tomada de\ndecisão",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  RaisedButton(
                    color: Colors.green[500],
                    child: Text(
                      "PUBLICAÇÕES",
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    textColor: Colors.black87,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PublicationScreen()));
                    },
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Divulgue ou fique sabendo de eventos relacionados ao agronegócio",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Compartilhe eventos\n para outros usuários\n e fique por\n dentro dos eventos\n compartilhados \ndentro da plataforma",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                      Image.asset("assets/inovacao.png",
                          width: 100, height: 100),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  RaisedButton(
                    color: Colors.green[500],
                    child: Text(
                      "EVENTOS",
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    textColor: Colors.black87,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EventsScreen()));
                    },
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Fique por dentro do clima de sua cidade, cotações de produtos e também sobre notícias relacionadas ao agronegócio",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset("assets/aplicacao-meteorologica.png",
                          width: 80, height: 80),
                      Image.asset("assets/dinheiro.png", width: 80, height: 80),
                      Image.asset("assets/jornal.png", width: 80, height: 80),
                    ],
                  ),
                  SizedBox(height: 30)
                ],
              ),
            )
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
