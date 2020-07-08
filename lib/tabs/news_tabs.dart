import 'package:cultiveapp/bloc/news_bloc.dart';
import 'package:cultiveapp/model/news_model.dart';
import 'package:cultiveapp/tiles/news_tile.dart';
import 'package:flutter/material.dart';

class NewsTabs extends StatefulWidget {
  @override
  _NewsTabsState createState() => _NewsTabsState();
}

class _NewsTabsState extends State<NewsTabs> {
  NewsBloc _newsBloc = new NewsBloc();
  @override
  void initState() {
    super.initState();
    _newsBloc.getListNews();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<News>>(
      stream: _newsBloc.output,
      builder: (context, snapshot) {
        if(!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)
            ),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data.length + 1,
          itemBuilder: (context, index){
            if(index < snapshot.data.length){
              return NewsTile(snapshot.data[index]);
            }else if(index > 1){
              _newsBloc.getListNews();
              return Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  child: Center(
                      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))
                  )
              );
            } else {
              return Container();
            }
          },
        );
      }
    );
  }
}
