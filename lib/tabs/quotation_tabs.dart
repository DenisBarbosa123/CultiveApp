import 'package:flutter/material.dart';

class QuotationTabs extends StatefulWidget {
  @override
  _QuotationTabsState createState() => _QuotationTabsState();
}

class _QuotationTabsState extends State<QuotationTabs> {

  Widget buildCard({String title, String imageName, String productPrice, bool isIncreased}){
     return Container(
        alignment: Alignment.center,
        child: Card(
          color: Colors.white,
          elevation: 5,
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("R\$$productPrice", style: TextStyle(fontSize: 18.0)),
                      Icon(
                          isIncreased == true ?
                          Icons.arrow_upward :
                          Icons.arrow_downward,
                          color:  isIncreased == true ?
                          Colors.green : Colors.red
                      ),
                      Image.asset("$imageName",height: 35, width: 30)
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    verticalDirection: VerticalDirection.up,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10),
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          title,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.normal),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      primary: false,
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverGrid.count(
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            children: <Widget>[
              buildCard(title: "Saca de Milho", imageName: "assets/corn.png", isIncreased: false, productPrice: "50.00"),
              buildCard(title: "Saca da Soja", imageName: "assets/soy.png", isIncreased: true, productPrice: "100.00"),
              buildCard(title: "Saca de Trigo", imageName: "assets/wheat.png", isIncreased: false, productPrice: "30.00"),
              buildCard(title: "Saca de Feijao", imageName: "assets/beans.png", isIncreased: true, productPrice: "40.00"),
              buildCard(title: "Litro do Leite", imageName: "assets/milk.png", isIncreased: false, productPrice: "60.00"),
              buildCard(title: "Arroba do Boi", imageName: "assets/cow.png", isIncreased: true, productPrice: "170.00"),
              buildCard(title: "Saca de Café", imageName: "assets/coffee.png", isIncreased: false, productPrice: "400.00"),
            ],
          ),
        ),
      ],
    );
  }
}
