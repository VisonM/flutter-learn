import 'package:flutter/material.dart';
class FancyFab extends StatefulWidget{
  final Function() onAddPressed;
  final Function() onListPressed;
  final Function(String) onLayoutPressed;
  final String tooltip;
  final IconData icon;
  FancyFab({this.onAddPressed,this.onLayoutPressed,this.onListPressed,this.tooltip,this.icon});

  @override
  _FancyFabState createState() => _FancyFabState();
}

class _FancyFabState extends State<FancyFab> with SingleTickerProviderStateMixin{
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight=56.0;
  @override
  initState() {
    _animationController=AnimationController(vsync: this,duration: Duration(milliseconds: 500))
      ..addListener((){
      setState(() {});
    });
    _animateIcon=Tween<double>(begin: 0.0,end: 1.0).animate(_animationController);
    _buttonColor=ColorTween(begin: Colors.blue,end: Colors.red)
        .animate(CurvedAnimation(
            parent: _animationController,
            curve: Interval(
                0.00,
                1.00,
                curve: _curve
            )
        )
    );
    _translateButton=Tween<double>(
      begin: _fabHeight,
      end:-14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Container add(){
    return new Container(
      child: FloatingActionButton(
        heroTag: "add",
        onPressed: ()=>widget.onAddPressed(),
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }

  Container assessment(){
    return new Container(
      child: FloatingActionButton(
        heroTag: "assessment",
        onPressed: ()=>widget.onLayoutPressed("hey"),
        tooltip: 'assessment',
        child: Icon(Icons.assessment),
      ),
    );
  }

  Container list(){
    return new Container(
      child: FloatingActionButton(
        heroTag: "view_list",
        onPressed: ()=>widget.onListPressed(),
        tooltip: 'view_list',
        child: Icon(Icons.view_list),
      ),
    );
  }

  Widget toggle() {
    return FloatingActionButton(
      backgroundColor: _buttonColor.value,
      onPressed: animate,
      foregroundColor: Colors.white,
      tooltip: widget.tooltip,
      heroTag: "menu",
      child: AnimatedIcon(
        icon: AnimatedIcons.menu_close,
        progress: _animateIcon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(0.0, _translateButton.value * 3.0, 0.0),
          child: add(),
        ),
        Transform(
          transform: Matrix4.translationValues(0.0, _translateButton.value * 2.0, 0.0),
          child: assessment(),
        ),
        Transform(
          transform: Matrix4.translationValues(0.0, _translateButton.value * 1.0, 0.0),
          child:list() ,
        ),
        toggle()
      ],
    );
  }
}
