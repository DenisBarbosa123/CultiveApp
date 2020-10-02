import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cultiveapp/bloc/publication_bloc.dart';
import 'package:cultiveapp/model/publication_model.dart';
import 'package:cultiveapp/tiles/publication_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PublicationTabs extends StatefulWidget {
  @override
  _PublicationTabsState createState() => _PublicationTabsState();
}

class _PublicationTabsState extends State<PublicationTabs> {
  PublicationBloc _publicationBloc = BlocProvider.getBloc<PublicationBloc>();
  bool endOfList;

  @override
  void initState() {
    super.initState();
    endOfList = false;
    _publicationBloc.getListPublication(endOfTheList);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Publication>>(
        stream: _publicationBloc.output,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor)),
            );
          }
          return ListView.builder(
                itemCount: snapshot.data.length + 1,
                itemBuilder: (context, index) {
                  if (index < snapshot.data.length) {
                    return PublicationTile(snapshot.data[index]);
                  } else if (endOfList) {
                    return Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Center(
                            child: Text("Você chegou ao final da lista"),
                          ),
                        ],
                      ),
                    );
                  } else if (index > 1) {
                    _publicationBloc.getListPublication(endOfTheList);
                    return Container(
                        height: 40,
                        width: 40,
                        alignment: Alignment.center,
                        child: Center(
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).primaryColor))));
                  } else {
                    return Container();
                  }
                });
        });
  }

  void endOfTheList() {
    setState(() {
      endOfList = true;
    });
  }
}
