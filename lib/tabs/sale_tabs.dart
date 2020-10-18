import 'package:cultiveapp/bloc/sale_bloc.dart';
import 'package:cultiveapp/model/sale_model.dart';
import 'package:cultiveapp/tiles/sale_tile.dart';
import 'package:flutter/material.dart';

class SalesTabs extends StatefulWidget {
  final Map<String, dynamic> userInfo;
  SalesTabs(this.userInfo);
  @override
  _SalesTabsState createState() => _SalesTabsState();
}

class _SalesTabsState extends State<SalesTabs> {
  SaleBloc _saleBloc;
  bool endOfList;

  @override
  void initState() {
    super.initState();
    _saleBloc = SaleBloc();
    endOfList = false;
    _saleBloc.getListSale(endOfTheList);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Sale>>(
        stream: _saleBloc.output,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor)),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data.length + 1,
              itemBuilder: (context, index) {
                if (index < snapshot.data.length) {
                  return SaleTile(snapshot.data[index], widget.userInfo);
                } else if (endOfList) {
                  return Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Center(
                          child: Text("Você chegou ao final da lista"),
                        ),
                      ],
                    ),
                  );
                } else if (index > 1) {
                  _saleBloc.getListSale(endOfTheList);
                  return Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      child: Center(
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor))));
                } else {
                  return Container();
                }
              });
        });
  }

  void endOfTheList() {
    setState(() {
      endOfList = true;
    });
  }
}