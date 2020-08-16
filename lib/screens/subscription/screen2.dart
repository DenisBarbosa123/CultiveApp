import 'package:cultiveapp/api/cep_api.dart';
import 'package:cultiveapp/model/user_model.dart';
import 'package:cultiveapp/screens/subscription/screen3.dart';
import 'package:cultiveapp/utils/CircleUtil.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

// ignore: must_be_immutable
class Screen2 extends StatelessWidget {

  //Mask
  final _phoneMask = MaskTextInputFormatter(mask: "(##) #####-####", filter: { "#": RegExp(r'[0-9]') });
  final _cepMask = MaskTextInputFormatter(mask: "#####-###", filter: { "#": RegExp(r'[0-9]') });

  //Controllers
  final  _phoneController = TextEditingController();
  final  _cepController = TextEditingController();
  final  _stateController = TextEditingController();
  final  _cityController = TextEditingController();
  final  _neighborhoodController = TextEditingController();

  //FormKey
  final _formKey = GlobalKey<FormState>();

  //Bloc
  final _cepAPI = CepAPI();

  //User
  User user;
  Screen2({@required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("CADASTRO"),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    inputFormatters: [_phoneMask],
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if(value.isEmpty) return "Campo Obrigatório";
                        if(value.length < 11) return "Informe um numero válido";
                        return null;
                      },
                      controller: _phoneController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.phone_android, color: Colors.black,),
                        labelText: "Celular",
                        hintStyle: TextStyle(color: Colors.black),
                        labelStyle: TextStyle(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1.0),
                        ),
                      )
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if(value.isEmpty) return "Campo Obrigatório";
                        if(value.length < 7) return "Informe um CEP Válido";
                        return null;
                      },
                      onChanged: (value) {
                          _cepAPI.input.add(value);
                      },
                      inputFormatters: [_cepMask],
                      controller: _cepController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.home, color: Colors.black,),
                        labelText: "CEP",
                        hintStyle: TextStyle(color: Colors.black),
                        labelStyle: TextStyle(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1.0),
                        ),
                      )
                  ),
                  StreamBuilder<Cep>(
                    stream: _cepAPI.output,
                    builder: (context,snapshot){
                      if(!snapshot.hasData){
                        return Column(
                          children: <Widget>[
                            SizedBox(height: 20,),
                            TextFormField(
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if(value.isEmpty) return "Campo Obrigatório";
                                  return null;
                                },
                                controller: _neighborhoodController,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.home, color: Colors.black,),
                                  labelText: "Bairro",
                                  hintStyle: TextStyle(color: Colors.black),
                                  labelStyle: TextStyle(color: Colors.black),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                                  ),
                                )
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if(value.isEmpty) return "Campo Obrigatório";
                                  return null;
                                },
                                controller: _cityController,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.home, color: Colors.black,),
                                  labelText: "Cidade",
                                  hintStyle: TextStyle(color: Colors.black),
                                  labelStyle: TextStyle(color: Colors.black),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                                  ),
                                )
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if(value.isEmpty) return "Campo Obrigatório";
                                  return null;
                                },
                                controller: _stateController,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.home, color: Colors.black,),
                                  labelText: "Estado",
                                  hintStyle: TextStyle(color: Colors.black),
                                  labelStyle: TextStyle(color: Colors.black),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                                  ),
                                )
                            ),
                          ],
                        );
                      }
                      if(snapshot.hasData) {
                        _populateAddressFields(snapshot.data);
                        return Column(
                          children: <Widget>[
                            SizedBox(height: 20,),
                            TextFormField(
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if(value.isEmpty) return "Campo Obrigatório";
                                  return null;
                                },
                                controller: _neighborhoodController,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.home, color: Colors.black,),
                                  labelText: "Bairro",
                                  hintStyle: TextStyle(color: Colors.black),
                                  labelStyle: TextStyle(color: Colors.black),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                                  ),
                                )
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if(value.isEmpty) return "Campo Obrigatório";
                                  return null;
                                },
                                controller: _cityController,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.home, color: Colors.black,),
                                  labelText: "Cidade",
                                  hintStyle: TextStyle(color: Colors.black),
                                  labelStyle: TextStyle(color: Colors.black),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                                  ),
                                )
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if(value.isEmpty) return "Campo Obrigatório";
                                  return null;
                                },
                                controller: _stateController,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.home, color: Colors.black,),
                                  labelText: "Estado",
                                  hintStyle: TextStyle(color: Colors.black),
                                  labelStyle: TextStyle(color: Colors.black),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                                  ),
                                )
                            ),
                          ],
                        );
                      }
                      return Container();
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CircleUtil.buildCircle("1", 2, 1),
              Container(height: 1.0, width: 40.0,color: Colors.grey[500]),
              CircleUtil.buildCircle("2", 2, 2),
              Container(height: 1.0, width: 40.0,color: Colors.grey[500]),
              CircleUtil.buildCircle("3", 2, 3)
            ],
          ),
          Container(
              padding: EdgeInsets.all(20),
              child: ButtonTheme(
                minWidth: 200,
                  height: 50,
                  child: FlatButton(
                    onPressed: (){
                      if(_formKey.currentState.validate()){
                        _populateUserData(
                            _phoneController.text,
                            _cepController.text,
                            _neighborhoodController.text,
                            _cityController.text,
                            _stateController.text);

                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => Screen3(user : this.user)));
                      }
                    },
                    color: Colors.green[900],
                    child: Text(
                      "PRÓXIMO",
                      style: TextStyle(color: Colors.white),
                    ),
                    disabledColor: Colors.black54,
                    disabledTextColor: Colors.white,
                  )
              )
          )
        ],
      ),
    );
  }
    _populateAddressFields(Cep cep){
      _stateController.text = cep.uf;
      _cityController.text = cep.localidade;
      _neighborhoodController.text = cep.bairro;
    }
    _populateUserData(String phone, String cep, String neighborhood, String city, String state){
     Localizacao localizacao = Localizacao();
     localizacao.bairro = neighborhood;
     localizacao.cidade = city;
     localizacao.estado = state;
     this.user.telefone = phone;
     this.user.localizacao = localizacao;
  }
}
