import 'package:carousel_pro/carousel_pro.dart';
import 'package:cultiveapp/bloc/sale_bloc.dart';
import 'package:cultiveapp/model/sale_model.dart';
import 'package:cultiveapp/model/user_model.dart';
import 'package:cultiveapp/screens/product_details_screen.dart';
import 'package:cultiveapp/screens/sales_screen.dart';
import 'package:cultiveapp/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SaleTile extends StatefulWidget {
  final Sale _sale;
  final Map<String, dynamic> _userInfo;

  SaleTile(this._sale, this._userInfo);

  @override
  _SaleTileState createState() => _SaleTileState(this._sale);
}

class _SaleTileState extends State<SaleTile> {
  final Sale _sale;

  ProgressDialog pr;

  _SaleTileState(this._sale);

  String firstHalf;
  String secondHalf;
  User _user;
  String token;

  SaleBloc _saleBloc;
  List<String> options = ['Excluir Venda'];

  bool flag = true;

  bool isEditing = false;
  var descriptionTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _saleBloc = SaleBloc();
    _user = widget._userInfo["user"];
    token = widget._userInfo["token"];
  }

  void handleClick(String option) {
    showDialog(
        context: context,
        builder: (context) {
          switch (option) {
            case 'Excluir Venda':
              {
                return showDeleteSaleDialog();
              }
              break;
            default:
              {
                return Container();
              }
              break;
          }
        });
  }

  showDeleteSaleDialog() {
    return AlertDialog(
      title: Text("Excluir Venda"),
      content: Text("Deseja excluir esta venda?"),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancelar")),
        FlatButton(
            onPressed: () async {
              Navigator.pop(context);
              pr.show();
              await ImageUtils.deletePublicationImages(_sale.imagens);
              _saleBloc.deleteSale(
                  token: token,
                  postId: _sale.id,
                  onDeleteFail: onDeleteFail,
                  onDeleteSuccess: onDeleteSuccess);
            },
            child: Text("Sim"))
      ],
    );
  }

  void onDeleteSuccess() {
    pr.hide();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Sucesso"),
            content: Text("Venda deletada com sucesso"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => SalesScreen()),
                        (Route<dynamic> route) => false);
                  },
                  child: Text("OK")),
            ],
          );
        });
  }

  void onDeleteFail() {
    pr.hide();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Erro"),
            content: Text("Erro ao deletar a venda desejada"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("OK")),
            ],
          );
        });
  }

  void configureProgressDialog(BuildContext context) {
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
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
  }

  @override
  Widget build(BuildContext context) {
    configureProgressDialog(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: Card(
          borderOnForeground: true,
          elevation: 5,
          shadowColor: Colors.grey[400],
          child: Container(
            child: Column(
              children: [
                _sale.imagens != null
                    ? AspectRatio(
                        aspectRatio: 0.9,
                        child: Carousel(
                          images: _sale.imagens.map((imagem) {
                            return NetworkImage(imagem.imagemEncoded);
                          }).toList(),
                          dotSize: 4.0,
                          dotSpacing: 15.0,
                          dotBgColor: Colors.transparent,
                          dotColor: Colors.white,
                          dotIncreasedColor: Theme.of(context).primaryColor,
                          autoplay: false,
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 15,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text("${_sale.produto.nome}"),
                          Text("Produto",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w300))
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                              "${_sale.usuario.localizacao.cidade} - ${_sale.usuario.localizacao.estado}"),
                          Text("Localização",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w300))
                        ],
                      ),
                    ]),
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailsScreen(this._sale)));
                  },
                  child: Row(
                    mainAxisAlignment:
                        _saleBloc.isMine(_user.id, _sale.usuario.id)
                            ? MainAxisAlignment.spaceEvenly
                            : MainAxisAlignment.center,
                    children: [
                      Text(
                        "Mais detalhes do produto",
                        style: TextStyle(color: Colors.blue, fontSize: 15),
                      ),
                      _saleBloc.isMine(_user.id, _sale.usuario.id)
                          ? PopupMenuButton<String>(
                              onSelected: handleClick,
                              itemBuilder: (context) {
                                return options.map((String choice) {
                                  return PopupMenuItem<String>(
                                    value: choice,
                                    child: Text(choice,
                                        style: TextStyle(fontSize: 14)),
                                  );
                                }).toList();
                              },
                            )
                          : Container()
                    ],
                  ),
                ),
                SizedBox(height: 10)
              ],
            ),
          )),
    );
  }
}
