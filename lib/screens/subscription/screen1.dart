import 'package:cultiveapp/screens/subscription/screen2.dart';
import 'package:cultiveapp/utils/CircleUtil.dart';
import 'package:cultiveapp/utils/textField_util.dart';
import 'package:flutter/material.dart';

class Screen1 extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatedPasswordController =
      TextEditingController();

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
          SizedBox(height: 10),
          TextFieldUtil.buildTextField(
              "Nome de Usuário",
              Icon(Icons.person, color: Colors.black),
              _nameController,
              Colors.black),
          SizedBox(height: 20),
          TextFieldUtil.buildTextField(
              "E-mail",
              Icon(Icons.email, color: Colors.black),
              _emailController,
              Colors.black),
          SizedBox(height: 20),
          TextFieldUtil.buildTextField(
              "Senha",
              Icon(Icons.lock_outline, color: Colors.black),
              _passwordController,
              Colors.black),
          SizedBox(height: 20),
          TextFieldUtil.buildTextField(
              "Repita senha",
              Icon(Icons.lock, color: Colors.black),
              _repeatedPasswordController,
              Colors.black),
          SizedBox(height: 40),
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
                height: 50,
                child: FlatButton(
                  onPressed: (){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => Screen2()));
                  },
                  color: Colors.green[900],
                  child: Text(
                    "PROXIMO",
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
}
