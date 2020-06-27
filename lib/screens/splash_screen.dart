import 'package:cultiveapp/utils/color_util.dart';
import 'package:cultiveapp/widgets/logo_cultive.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';

class Splash extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<Splash> {
  final Color _backColor = HexColor("6FCF97");
  @override
  Widget build(BuildContext context) {
    return _introScreen();
  }
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5)).then((_) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen())
      );
    });
  }

  Widget _introScreen() {
    return Scaffold(
        backgroundColor: _backColor,
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              LogoCultive(),
              SizedBox(height: 50),
              Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white)
                  )
              ),
              SizedBox(height: 50),
              Text(
                  "from",
                  style: TextStyle(
                      fontSize: 20.0),
                  textAlign: TextAlign.center
              ),
              Text(
                  "Notorius Development",
                  style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center
              )
            ],
          ),
        )
    );
  }
}

