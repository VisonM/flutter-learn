import 'package:first_flutter/model/planet.dart';
import 'package:flutter/material.dart';
import 'package:first_flutter/components/planet_item.dart';
class HomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new Expanded(
      child:new Container(
        color: new Color(0xFF736AB7),
        child: new ListView.builder(
          itemBuilder: (context,index)=>new PlanetItem(planets[index]),
          itemCount: planets.length,
          padding: EdgeInsets.symmetric(vertical: 16.0),
        ),
      )

    );
  }
}
