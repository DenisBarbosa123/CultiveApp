import 'package:cultiveapp/bloc/user_bloc.dart';
import 'package:cultiveapp/utils/token_util.dart';
import 'package:cultiveapp/widgets/logo_cultive.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'home_screen.dart';

class Splash extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<Splash> {
  TokenUtil _tokenUtil = TokenUtil();
  UserBloc _userBloc;
  @override
  Widget build(BuildContext context) {
    return _introScreen();
  }

  @override
  void initState() {
    super.initState();
    _tokenUtil.getToken().then((value) {
      debugPrint("Token do user : $value");
      if (value != null && JwtDecoder.isExpired(value)) {
        debugPrint("Token expirado, fazendo logout");
        _userBloc = UserBloc();
        _userBloc.logout();
      }
    });
    Future.delayed(Duration(seconds: 5)).then((_) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    });
  }

  Widget _introScreen() {
    return Container(
        decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 0.19),
            image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(
                    Colors.grey.withOpacity(0.4), BlendMode.dstATop),
                image: AssetImage("assets/login-image.jpg"))),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  LogoCultive(),
                  SizedBox(height: 90),
                  Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.green))),
                  SizedBox(height: 90),
                  Text("from",
                      style: TextStyle(fontSize: 15.0, color: Colors.white),
                      textAlign: TextAlign.center),
                  Text("Notorius Development",
                      style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center)
                ],
              ),
            )));
  }
}
