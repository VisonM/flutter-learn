import 'package:flutter/material.dart';
import 'contacts.dart';
import 'bottom_bar.dart';
import 'bottom_navigation.dart';
import 'card.dart';
import 'chip.dart';
import 'fab_tab.dart';
import 'scrollable_tab.dart';
import 'back_drop.dart';
import 'ios_refresh.dart';
import 'filter_menu.dart';
class ListEntry extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    void _navigatorRouter(page){
      Navigator.of(context).push(new MaterialPageRoute(
        builder: (context)=> page,
      ));
    }
    return new Scaffold(
      appBar: new AppBar(
        title: Text("hey,flutter!"),
      ),
      body: new Container(
        child:new IntrinsicWidth(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              RaisedButton(
                onPressed: ()=> _navigatorRouter(new ContactsDemo()),
                child: new Text("route to contact"),
              ),
              RaisedButton(
                onPressed:()=> _navigatorRouter(new BottomBar()),
                child: new Text("route to bottom_bar"),
              ),
              RaisedButton(
                onPressed: ()=>_navigatorRouter(new BottomNavigation()),
                child: new Text("route to bottom_navigation"),
              ),
              RaisedButton(
                onPressed: ()=> _navigatorRouter(new FabTab()),
                child: new Text("route to Fab_Tab"),
              ),
              RaisedButton(
                onPressed: ()=> _navigatorRouter(new CardsDemo()),
                child: new Text("route to card"),
              ),
              RaisedButton(
                onPressed: ()=> _navigatorRouter(new ChipDemo()),
                child: new Text("route to chips"),
              ),
              RaisedButton(
                onPressed: ()=>_navigatorRouter(new ScrollableTabDemo()),
                child: new Text("route to scrollable_tab"),
              ),
              RaisedButton(
                onPressed: ()=> _navigatorRouter(new BackDropDemo()),
                child: new Text("route to back_drop"),
              ),
              RaisedButton(
                onPressed: ()=> _navigatorRouter(new CupertinoRefreshControlDemo()),
                child: new Text("route to ios_refresh"),
              ),
              RaisedButton(
                onPressed: ()=> _navigatorRouter(new FilterMenuDemo()),
                child: new Text("route to filter_menu"),
              )

            ],
          ),
        )

      ),
    );
  }
}
