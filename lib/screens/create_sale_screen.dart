import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:cultiveapp/bloc/sale_bloc.dart';
import 'package:cultiveapp/model/publication_model.dart';
import 'package:cultiveapp/model/sale_model.dart';
import 'package:cultiveapp/model/user_model.dart';
import 'package:cultiveapp/screens/sales_screen.dart';
import 'package:cultiveapp/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:search_choices/search_choices.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class CreateSaleScreen extends StatefulWidget {
  final User user;
  final String token;

  CreateSaleScreen(this.user, this.token);
  @override
  _CreateSaleScreenState createState() => _CreateSaleScreenState();
}

class _CreateSaleScreenState extends State<CreateSaleScreen> {
  SaleBloc _bloc = SaleBloc();
  Produto _productSelected = Produto();
  List<Produto> products = [];
  List<DropdownMenuItem<Produto>> productItems = [];
  final _formKey = GlobalKey<FormState>();
  final _lowPrice =
      MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');

  var _categoryController = TextEditingController();

  var _quantityController = TextEditingController();

  //Progress Dialog
  ProgressDialog pr;

  List<Asset> assetsList = [];

  var _descriptionController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    populateProductList();
  }

  populateProductList() async {
    products = await _bloc.getAllProdutos();
    setState(() {
      productItems = products.map((product) {
        return (DropdownMenuItem(child: Text(product.nome), value: product));
      }).toList();
    });
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: false,
        selectedAssets: assetsList,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } catch (e) {
      debugPrint("Exception during multi image picker" + e.toString());
    }

    setState(() {
      assetsList = resultList;
    });
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      textDirection: TextDirection.rtl,
      isDismissible: true,
    );

    pr.style(
      message: 'Por favor, aguarde',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      progressWidgetAlignment: Alignment.center,
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("CRIAR VENDA"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                SearchChoices.single(
                  validator: (value) {
                    if (value == null) return "Campo Obrigatório";
                    return null;
                  },
                  label: Text('Produto', style: TextStyle(color: Colors.black)),
                  items: productItems,
                  value: _productSelected,
                  hint: "Selecione um produto",
                  searchHint: "Ex: Gado, Milho, Café",
                  onChanged: (value) {
                    if (value != null) {
                      _productSelected = value;
                      _categoryController.text =
                          _productSelected.categoria.nome;
                    }
                  },
                  isExpanded: true,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                    validator: (value) {
                      if (value.isEmpty) return "Campo Obrigatório";
                      return null;
                    },
                    controller: _categoryController,
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: "Categoria",
                      hintStyle: TextStyle(color: Colors.black),
                      labelStyle: TextStyle(color: Colors.black),
                    )),
                TextFormField(
                    validator: (value) {
                      if (value.isEmpty) return "Campo Obrigatório";
                      return null;
                    },
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: "Descrição",
                      hintStyle: TextStyle(color: Colors.black),
                      labelStyle: TextStyle(color: Colors.black),
                    )),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                    validator: (value) {
                      if (double.parse(value.replaceAll(",", "")) < 0.1)
                        return "Campo Obrigatório";
                      return null;
                    },
                    controller: _lowPrice,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Valor",
                      hintStyle: TextStyle(color: Colors.black),
                      labelStyle: TextStyle(color: Colors.black),
                    )),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                    validator: (value) {
                      if (value.isEmpty) return "Campo Obrigatório";
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    controller: _quantityController,
                    decoration: InputDecoration(
                      labelText: "Quantidade",
                      hintStyle: TextStyle(color: Colors.black),
                      labelStyle: TextStyle(color: Colors.black),
                    )),
                SizedBox(
                  height: 30,
                ),
                assetsList.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.all(10),
                        child: AspectRatio(
                          aspectRatio: 0.9,
                          child: Carousel(
                            images: assetsList.map((imagem) {
                              return AssetThumb(
                                  asset: imagem, height: 200, width: 200);
                            }).toList(),
                            dotSize: 4.0,
                            dotSpacing: 15.0,
                            dotBgColor: Colors.transparent,
                            dotColor: Colors.white,
                            dotIncreasedColor: Theme.of(context).primaryColor,
                            autoplay: false,
                          ),
                        ))
                    : Container(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.image,
                        color: Colors.black,
                        size: 40,
                      ),
                      onPressed: loadAssets,
                    ),
                    SizedBox(height: 5),
                    Text("Adicionar imagens"),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                    padding: EdgeInsets.only(right: 10, left: 10),
                    child: ButtonTheme(
                        minWidth: 200,
                        height: 50,
                        child: FlatButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              pr.show();
                              Sale sale = await buildSaleObject();
                              print(sale.toJson());
                              _bloc.createSale(
                                  token: widget.token,
                                  userId: widget.user.id,
                                  sale: sale,
                                  onFail: _onFail,
                                  onSuccess: _onSuccess);
                            }
                          },
                          color: Colors.green[900],
                          child: Text(
                            "SALVAR VENDA",
                            style: TextStyle(color: Colors.white),
                          ),
                          disabledColor: Colors.black54,
                          disabledTextColor: Colors.white,
                        ))),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<Sale> buildSaleObject() async {
    List<File> filesImg = await ImageUtils.getFileListFromAssetList(assetsList);
    List<Imagens> imagensSaved = await ImageUtils.uploadListImage(filesImg);
    Sale sale = Sale();

    sale.corpo = _descriptionController.text;

    sale.imagens = imagensSaved;

    Status status = Status();
    status.nome = "Criada";
    sale.status = status;

    Tipo tipo = Tipo();
    tipo.nome = "Venda";
    sale.tipo = tipo;

    Produto produto = Produto();
    Categoria categoria = Categoria();
    categoria.nome = _productSelected.categoria.nome;
    produto.categoria = categoria;
    produto.nome = _productSelected.nome;
    produto.quantidade = double.parse(_quantityController.text);
    produto.valor = double.parse(_lowPrice.text.replaceAll(",", ""));

    sale.produto = produto;

    sale.data = DateTime.now().toLocal().toIso8601String();

    return sale;
  }

  void _onSuccess() {
    Future.delayed(Duration(seconds: 3)).then((_) {
      pr.hide();
      _showMyDialog();
    });
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Venda criada com sucesso!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Tudo ok com criação de sua venda!'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => SalesScreen()),
                    (Route<dynamic> route) => false);
              },
            ),
          ],
        );
      },
    );
  }

  void _onFail() {
    pr.hide();
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao criar sua venda, tente novamente."),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 3),
    ));
  }
}
