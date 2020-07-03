import 'package:flutter/material.dart';

class NewsTabs extends StatefulWidget {
  @override
  _NewsTabsState createState() => _NewsTabsState();
}

class _NewsTabsState extends State<NewsTabs> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index){
        return Padding(
          padding: const EdgeInsets.fromLTRB(0.0,0.5,0.0,0.5),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Artigo", style: TextStyle(color: Colors.black38,fontWeight: FontWeight.w500, fontSize: 16.0),),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0,12.0,0.0,12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(child: Text("Titulo do Artigo", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),), flex: 3,),
                        Flexible(
                          flex: 1,
                          child: Container(
                              height: 80.0,
                              width: 80.0,
                              child: Image.asset("assets/gol.jpg", fit: BoxFit.cover,)
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Autor do artigo", style: TextStyle(fontSize: 18.0),),
                          Text("20/10/2019" + " . " + "7 min", style: TextStyle(color: Colors.black45, fontWeight: FontWeight.w500),)
                        ],
                      ),
                      Icon(Icons.bookmark_border),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
