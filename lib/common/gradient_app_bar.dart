import 'package:flutter/material.dart';

class GradientAppBar extends StatelessWidget{
  final String title;
  final double barHeight = 66.0;
  GradientAppBar(this.title);

  @override
  Widget build(BuildContext context) {
    final statusBarHeight=MediaQuery.of(context).padding.top;
    return new Container(
      padding: EdgeInsets.only(top:statusBarHeight),
      height: statusBarHeight + barHeight,
      child: new Center(
        child: new Text(
          title,
          style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 36.0
          )
        ),
      ),
    );
  }
}
