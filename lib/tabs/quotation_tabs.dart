import 'package:cultiveapp/bloc/quotation_bloc.dart';
import 'package:cultiveapp/model/quotation_model.dart';
import 'package:flutter/material.dart';

class QuotationTabs extends StatefulWidget {
  @override
  _QuotationTabsState createState() => _QuotationTabsState();
}

class _QuotationTabsState extends State<QuotationTabs> {
  QuotationBloc _quotationBloc;

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
              StreamBuilder<Quotation>(
                  stream: _quotationBloc.outputCorn,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                              Theme.of(context).primaryColor),
                        ),
                      );
                    }
                    return _buildCard(
                        title: "Saca de Milho",
                        imageName: "assets/corn.png",
                        isIncreased: isIncreased(
                            snapshot.data.firstPrice, snapshot.data.lastPrice),
                        productPrice:
                            snapshot.data.firstPrice.toStringAsFixed(2));
                  }),
              StreamBuilder<Quotation>(
                  stream: _quotationBloc.outputSoy,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                              Theme.of(context).primaryColor),
                        ),
                      );
                    }
                    return _buildCard(
                        title: "Saca da Soja",
                        imageName: "assets/soy.png",
                        isIncreased: isIncreased(
                            snapshot.data.firstPrice, snapshot.data.lastPrice),
                        productPrice:
                            snapshot.data.firstPrice.toStringAsFixed(2));
                  }),
              StreamBuilder<Quotation>(
                  stream: _quotationBloc.outputWheat,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                              Theme.of(context).primaryColor),
                        ),
                      );
                    }
                    return _buildCard(
                        title: "Tonelada de Trigo",
                        imageName: "assets/wheat.png",
                        isIncreased: isIncreased(
                            snapshot.data.firstPrice, snapshot.data.lastPrice),
                        productPrice:
                            snapshot.data.firstPrice.toStringAsFixed(2));
                  }),
              StreamBuilder<Quotation>(
                  stream: _quotationBloc.outputMilk,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                              Theme.of(context).primaryColor),
                        ),
                      );
                    }
                    return _buildCard(
                        title: "Litro do Leite",
                        imageName: "assets/milk.png",
                        isIncreased: isIncreased(
                            snapshot.data.firstPrice, snapshot.data.lastPrice),
                        productPrice:
                            snapshot.data.firstPrice.toStringAsFixed(2));
                  }),
              StreamBuilder<Quotation>(
                  stream: _quotationBloc.outputCoffee,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                              Theme.of(context).primaryColor),
                        ),
                      );
                    }
                    return _buildCard(
                        title: "Saca de Café",
                        imageName: "assets/coffee.png",
                        isIncreased: isIncreased(
                            snapshot.data.firstPrice, snapshot.data.lastPrice),
                        productPrice:
                            snapshot.data.firstPrice.toStringAsFixed(2));
                  }),
              StreamBuilder<Quotation>(
                  stream: _quotationBloc.outputCattle,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                              Theme.of(context).primaryColor),
                        ),
                      );
                    }
                    return _buildCard(
                        title: "Arroba do Boi",
                        imageName: "assets/cow.png",
                        isIncreased: isIncreased(
                            snapshot.data.firstPrice, snapshot.data.lastPrice),
                        productPrice:
                            snapshot.data.firstPrice.toStringAsFixed(2));
                  }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCard(
      {String title, String imageName, String productPrice, bool isIncreased}) {
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
                  Text("R\$$productPrice", style: TextStyle(fontSize: 15.0)),
                  Icon(
                      isIncreased == true
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      color: isIncreased == true ? Colors.green : Colors.red),
                  Image.asset("$imageName", height: 30, width: 30)
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
  void initState() {
    super.initState();
    loadQuotationData();
  }

  void loadQuotationData() {
    _quotationBloc = QuotationBloc();
    _quotationBloc.getDolarPrice().then((value) {
      _quotationBloc.getCornPrice(value);
      _quotationBloc.getMilkPrice(value);
      _quotationBloc.getCattlePrice(value);
      _quotationBloc.getWheatPrice(value);
      _quotationBloc.getSoyPrice(value);
      _quotationBloc.getCoffeePrice(value);
    });
  }

  bool isIncreased(double firstPrice, double lastPrice) {
    return firstPrice > lastPrice ? true : false;
  }
}
