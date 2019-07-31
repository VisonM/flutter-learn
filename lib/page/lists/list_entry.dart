import 'package:flutter/material.dart';
import 'contacts.dart';
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
              onPressed: ()=>Navigator.pushNamed(context, "/contacts"),
            )
          ],
        ),
      ),
    );
  }
}
