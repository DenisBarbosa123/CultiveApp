import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final PageController pageController;
  final int page;

  DrawerTile(this.icon, this.text, this.pageController, this.page);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 20.0),
        child: Material(
          color: pageController.page.round() == page
              ? Colors.grey[200]
              : Colors.transparent,
          child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
                pageController.jumpToPage(page);
              },
              child: Container(
                height: 60.0,
                child: Row(
                  children: <Widget>[
                    Icon(
                      icon,
                      size: 32.0,
                      color: pageController.page.round() == page
                          ? Theme.of(context).primaryColor
                          : Colors.black,
                    ),
                    SizedBox(
                      width: 32,
                    ),
                    Text(
                      text,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: pageController.page.round() == page
                              ? Colors.green[900]
                              : Colors.black),
                    )
                  ],
                ),
              )),
        ));
  }
}
