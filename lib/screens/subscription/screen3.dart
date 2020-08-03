import 'package:cultiveapp/screens/subscription/successSubscription.dart';
import 'package:cultiveapp/utils/CircleUtil.dart';
import 'package:cultiveapp/utils/textField_util.dart';
import 'package:flutter/material.dart';

class Screen3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text("CADASTRO"),
          centerTitle: true,
        ),
        body: ListView(children: <Widget>[
          Container(
            padding: EdgeInsets.all(5),
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(15),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    radius: 80,
                    child: Icon(Icons.person_outline,
                        size: 70, color: Colors.black),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.all(5),
                    child: ButtonTheme(
                        height: 50,
                        child: FlatButton(
                          onPressed: () {},
                          color: Colors.green[900],
                          child: Text(
                            "ESCOLHER FOTO",
                            style: TextStyle(color: Colors.white),
                          ),
                          disabledColor: Colors.black54,
                          disabledTextColor: Colors.white,
                        )))
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Flexible(
                child: TextFormField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.search, color: Colors.black),
                  labelText: "Interesses",
                  hintStyle: TextStyle(color: Colors.black),
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                )),
              ),
              Padding(
                  padding: EdgeInsets.all(5),
                  child: ButtonTheme(
                      height: 50,
                      child: FlatButton(
                        onPressed: () {},
                        color: Colors.green[900],
                        child: Text(
                          "ADD",
                          style: TextStyle(color: Colors.white),
                        ),
                        disabledColor: Colors.black54,
                        disabledTextColor: Colors.white,
                      )))
            ],
          ),
          SizedBox(height: 10),
          Card(
            color: Colors.grey[100],
            child: Row(
              children: <Widget>[
                InputChip(
                  label: Text("Teste"),
                  onDeleted: (){},
                ),
                InputChip(
                  label: Text("Teste"),
                  onDeleted: (){},
                ),
                InputChip(
                  label: Text("Teste"),
                  onDeleted: (){},
                ),
                InputChip(
                  label: Text("Teste"),
                  onDeleted: (){},
                )
              ],
            )
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CircleUtil.buildCircle("1", 3, 1),
              Container(height: 1.0, width: 40.0, color: Colors.grey[500]),
              CircleUtil.buildCircle("2", 3, 2),
              Container(height: 1.0, width: 40.0, color: Colors.grey[500]),
              CircleUtil.buildCircle("3", 3, 3)
            ],
          ),
          Container(
              padding: EdgeInsets.only(top: 40, right: 10, left: 10),
              child: ButtonTheme(
                  height: 50,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => SuccessSubscription()));
                    },
                    color: Colors.green[900],
                    child: Text(
                      "CONCLUIR CADASTRO",
                      style: TextStyle(color: Colors.white),
                    ),
                    disabledColor: Colors.black54,
                    disabledTextColor: Colors.white,
                  )))
        ]));
  }
}
