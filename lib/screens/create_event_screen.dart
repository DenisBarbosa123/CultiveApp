import 'package:cultiveapp/model/user_model.dart';
import 'package:flutter/material.dart';
class CreateEventScreen extends StatefulWidget {
  final String token;
  final User user;
  CreateEventScreen(this.user, this.token);
  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
