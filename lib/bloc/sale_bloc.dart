import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cultiveapp/model/sale_model.dart';
import 'package:cultiveapp/utils/path_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SaleBloc extends BlocBase {
  int offset = 0;
  List<Sale> sales = [];
  List<Sale> searchedSaleList = [];
  StreamController<List<Sale>> _listSalesController =
      StreamController<List<Sale>>.broadcast();

  int searchOffset = 0;

  Stream<List<Sale>> get output => _listSalesController.stream;

  StreamController<List<Sale>> _searchSalesController =
      StreamController<List<Sale>>.broadcast();

  Stream<List<Sale>> get search => _searchSalesController.stream;

  void getListSale(VoidCallback endOfList) async {
    debugPrint("Loading Sales From Cultive App server");
    Response response = await Dio().get(
        PathConstants.getPublicationsByParameters(
            tipo: "Venda", limit: "10", offset: "$offset"));
    if (response.statusCode == 200) {
      debugPrint("Everything ok with Sales API response");
      offset += 10;
      var jsonDecoded = response.data;
      List<Sale> newPubs = [];
      newPubs = jsonDecoded.map<Sale>((map) {
        return Sale.fromJson(map);
      }).toList();
      if (newPubs.isEmpty) {
        endOfList();
      }
      if (sales.isEmpty) {
        sales.addAll(newPubs);
      } else {
        sales += newPubs;
      }
      _listSalesController.add(sales);
    } else {
      throw Exception("Failed to load the sales!");
    }
  }

  void createSale(
      {int userId,
      String token,
      Sale sale,
      VoidCallback onSuccess,
      VoidCallback onFail}) async {
    debugPrint("Saving sale...");
    try {
      Response response = await Dio().post(
          PathConstants.createPublication(userId),
          data: sale.toJson(),
          options: RequestOptions(headers: {"Authorization": token}));
      if (response.statusCode == 200) {
        debugPrint("Sale saved with successfully");
        Sale saleCreated = Sale.fromJson(response.data);
        sales.add(saleCreated);
        _listSalesController.add(sales);
        onSuccess();
      } else {
        debugPrint("Fault during saving sale");
        onFail();
      }
    } catch (e) {
      debugPrint("Exception during saving sale" + e.toString());
      onFail();
    }
  }

  Future<List<Produto>> getAllProdutos() async {
    try {
      print("Loading all products from Cultive Server");
      Response response = await Dio().get(PathConstants.getAllProducts());
      List<Produto> products = [];
      products = response.data.map<Produto>((item) {
        return Produto.fromJson(item);
      }).toList();
      final ids = products.map((e) => e.nome).toSet();
      products.retainWhere((x) => ids.remove(x.nome));
      return products;
    } catch (e) {
      print("Exception during get all products from Cultive Server");
    }
  }

  Future<void> deleteSale(
      {String token,
      int postId,
      VoidCallback onDeleteSuccess,
      VoidCallback onDeleteFail}) async {
    debugPrint("Delete performing to exclude sale with id $postId");
    try {
      Response response = await Dio().delete(
          PathConstants.deletePublication(postId),
          options: RequestOptions(headers: {"Authorization": token}));
      if (response.statusCode == 204) {
        debugPrint("Sale was excluded successfully");
        onDeleteSuccess();
      } else {
        debugPrint("Error during sale exclusion");
        onDeleteFail();
      }
    } catch (e) {
      debugPrint("Exception during sale exclusion");
      onDeleteFail();
    }
  }

  bool isMine(int myUserId, int userId) {
    return myUserId == userId;
  }

  @override
  void dispose() {
    super.dispose();
    _listSalesController.close();
    _searchSalesController.close();
  }

  void getSearchListSales(VoidCallback endOfList, int offset, int filter,
      String query, bool newSearch) async {
    if (offset != null) {
      searchOffset = offset;
    }
    if (newSearch) {
      _searchSalesController.add(null);
      searchedSaleList.clear();
    }
    Response response =
        await Dio().get(_prepareEndPoint(filter, query, searchOffset));
    if (response.statusCode == 200) {
      searchOffset += 10;
      var jsonDecoded = response.data;
      List<Sale> newSales = [];
      newSales = jsonDecoded.map<Sale>((map) {
        return Sale.fromJson(map);
      }).toList();
      if (newSales.isEmpty) {
        endOfList();
      }
      if (searchedSaleList.isEmpty) {
        searchedSaleList.addAll(newSales);
      } else {
        searchedSaleList += newSales;
      }
      _searchSalesController.add(searchedSaleList);
    } else {
      throw Exception("Failed to load the Sales searched!");
    }
  }

  String _prepareEndPoint(int filter, String query, int offset) {
    String endPoint;
    switch (filter.toString()) {
      case '0':
        {
          endPoint = PathConstants.getPostsByParameterAndType(
              'usuario', query, 'Venda', offset.toString());
        }
        break;
      case '1':
        {
          endPoint = PathConstants.getPostsByParameterAndType(
              'corpo', query, 'Venda', offset.toString());
        }
        break;
      default:
        {
          endPoint = PathConstants.getPublicationsByParameters(
              tipo: "Geral", limit: "10", offset: "$offset");
        }
        break;
    }
    return endPoint;
  }
}
