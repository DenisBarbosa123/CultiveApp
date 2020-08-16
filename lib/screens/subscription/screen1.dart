import 'package:cultiveapp/model/user_model.dart';
import 'package:cultiveapp/screens/subscription/screen2.dart';
import 'package:cultiveapp/utils/CircleUtil.dart';
import 'package:flutter/material.dart';

class Screen1 extends StatelessWidget {

  //Controller
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatedPasswordController =
      TextEditingController();

  //FormKey

  final _formKey = GlobalKey<FormState>();

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
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if(value.isEmpty) return "Campo Obrigatório";
                        return null;
                      },
                      controller: _nameController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.person_outline, color: Colors.black,),
                        labelText: "Nome",
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
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if(value.isEmpty) return "Campo Obrigatório";
                        if(!value.contains("@")) return "Informe um e-mail válido";
                        return null;
                      },
                      controller: _emailController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.email, color: Colors.black,),
                        labelText: "E-mail",
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
                      obscureText: true,
                      validator: (value) {
                        if(value.isEmpty) return "Campo Obrigatório";
                        if(value.length < 5) return "Informe uma senha com mais de 5 caracteres";
                        return null;
                      },
                      controller: _passwordController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock_outline, color: Colors.black,),
                        labelText: "Senha",
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
                      obscureText: true,
                      validator: (value) {
                        if(value.isEmpty) return "Campo Obrigatório";
                        if(value != _passwordController.text) return "Informe uma senha que seja igual ao campo anterior";
                        return null;
                      },
                      controller: _repeatedPasswordController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock, color: Colors.black,),
                        labelText: "Nova senha novamente",
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
                  SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      CircleUtil.buildCircle("1", 1, 1),
                      Container(height: 1.0, width: 40.0,color: Colors.grey[500]),
                      CircleUtil.buildCircle("2", 1, 2),
                      Container(height: 1.0, width: 40.0,color: Colors.grey[500]),
                      CircleUtil.buildCircle("3", 1, 3)
                    ],
                  ),
                  Container(
                      padding: EdgeInsets.only(top: 40, right: 10, left: 10),
                      child: ButtonTheme(
                          minWidth: 200,
                          height: 50,
                          child: FlatButton(
                            onPressed: (){
                              if(_formKey.currentState.validate()){
                                User user = _populateUserData(_nameController.text, _emailController.text, _passwordController.text);
                                Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    builder: (context) => Screen2(user: user)));
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
            ),
          ),
        ],
      ),
    );
  }

  User _populateUserData(String name, String email, String password){
    User user = User();
    user.email = email;
    user.nome = name;
    user.senha = password;
    return user;
  }
}
