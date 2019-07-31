import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Layout extends StatelessWidget{
  @override

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar:new AppBar(
        title: new Text("layout"),
      ),
      body: new Container(
        decoration: new BoxDecoration(
          color: Colors.yellowAccent,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(blurRadius: 10),
          ],
        ),
        foregroundDecoration: new BoxDecoration(color:Colors.red.withOpacity(0.5)),
//        transform: Matrix4.rotationZ(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Container(
              color:Colors.yellow,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.star,size: 50,),
                  Icon(Icons.star,size: 50,),
                  Icon(Icons.star,size: 50,)
                ],
              ),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Icon(Icons.star,size: 50,color: Colors.yellow,),
                Icon(Icons.star,size: 50,color: Colors.yellow,),
                Icon(Icons.star,size: 50,color: Colors.yellow,)
              ],
            ),
            new Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: <Widget>[
                Text("Baseline",style: Theme.of(context).textTheme.display1,),
                Text("Baseline",style: Theme.of(context).textTheme.body1,)
              ],
            ),
            new IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {},
                    child: Text('Short'),
                  ),
                  RaisedButton(
                    onPressed: () {},
                    child: Text('A bit Longer'),
                  ),
                  RaisedButton(
                    onPressed: () {},
                    child: Text('The Longest text button'),
                  ),
                ],
              ),
            ),
          ],
        ),
      )

    );
  }
}
