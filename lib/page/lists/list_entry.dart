import 'package:flutter/material.dart';
import 'contacts.dart';
import 'bottom_bar.dart';
import 'bottom_navigation.dart';
import 'card.dart';
import 'chip.dart';
import 'fab_tab.dart';
class ListEntry extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("hey,flutter!"),
      ),
      body: new Container(
        child: new Column(
          children: <Widget>[
            RaisedButton(
              onPressed: ()=> Navigator.of(context).push(new PageRouteBuilder(
                    pageBuilder: (_,__,___)=> new ContactsDemo(),
                  )),
              child: new Text("route to contact"),
            ),
            RaisedButton(
              onPressed: ()=> Navigator.of(context).push(new PageRouteBuilder(
                pageBuilder: (_,__,___)=> new BottomBar(),
              )),
              child: new Text("route to bottom_bar"),
            ),
            RaisedButton(
              onPressed: ()=> Navigator.of(context).push(new PageRouteBuilder(
                pageBuilder: (_,__,___)=> new BottomNavigation(),
              )),
              child: new Text("route to bottom_navigation"),
            ),
            RaisedButton(
              onPressed: ()=> Navigator.of(context).push(new PageRouteBuilder(
                pageBuilder: (_,__,___)=> new FabTab(),
              )),
              child: new Text("route to Fab_Tab"),
            ),
            RaisedButton(
              onPressed: ()=> Navigator.of(context).push(new PageRouteBuilder(
                pageBuilder: (_,__,___)=> new CardsDemo(),
              )),
              child: new Text("route to card"),
            ),
            RaisedButton(
              onPressed: ()=> Navigator.of(context).push(new PageRouteBuilder(
                pageBuilder: (_,__,___)=> new ChipDemo(),
              )),
              child: new Text("route to chips"),
            )
          ],
        ),
      ),
    );
  }
}
