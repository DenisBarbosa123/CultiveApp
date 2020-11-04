import 'package:flutter/material.dart';

class SearchSalesScreen extends StatefulWidget {
  @override
  _SearchSalesScreenState createState() => _SearchSalesScreenState();
}

class _SearchSalesScreenState extends State<SearchSalesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('BUSCA DE VENDAS'),
          centerTitle: true,
        ),
        body: Container(color: Colors.blue));
  }
}
