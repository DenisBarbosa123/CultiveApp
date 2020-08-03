import 'package:flutter/material.dart';
class TextFieldUtil {

  static Padding buildTextField(String labelTextString, Icon icon, TextEditingController controller, Color color){
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            icon: icon,
            labelText: labelTextString,
            hintStyle: TextStyle(color: color),
            labelStyle: TextStyle(color: color),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: color, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: color, width: 1.0),
            ),
          )
      )
    );
  }
}