import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cultiveapp/bloc/publication_bloc.dart';
import 'package:cultiveapp/bloc/user_bloc.dart';
import 'package:cultiveapp/utils/color_util.dart';
import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        blocs: [Bloc((i) => UserBloc()), Bloc((i) => PublicationBloc())],
        child: MaterialApp(
          title: 'CultiveApp',
          debugShowCheckedModeBanner: false,
          home: Splash(),
          theme: ThemeData(primaryColor: HexColor("6FCF97")),
        ));
  }
}
