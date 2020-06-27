import 'package:cultiveapp/utils/color_util.dart';
import 'package:flutter/material.dart';

class QuotationTabs extends StatefulWidget {
  @override
  _QuotationTabsState createState() => _QuotationTabsState();
}

class _QuotationTabsState extends State<QuotationTabs> {
  final Color _backColor = HexColor("6FCF97");
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      color: _backColor,
      child: Column(
        children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 10),
                child: Text(
                  "Cotação de produtos agrícolas",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 20.0)
                ),
              ),
              Divider(
                color: Colors.white
              )
        ],
      )
    );
  }
}
