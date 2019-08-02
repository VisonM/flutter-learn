import 'package:flutter/material.dart';

class BackDropDemo extends StatefulWidget{
  @override
  _BackDropState createState()=>_BackDropState();
}

class _BackDropState extends State<BackDropDemo> with SingleTickerProviderStateMixin{
  AnimationController _animationControl;
  static const _PANEL_HEADER_HEIGHT = 56.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationControl=new AnimationController(
      duration: const Duration(microseconds: 500),
      value: 1.0,
      vsync: this
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationControl.dispose();
  }
  bool get _isPanelVisible {
    final AnimationStatus status = _animationControl.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    final Animation<RelativeRect> animation = _getPanelAnimation(constraints);
    final ThemeData theme = Theme.of(context);
    return new Container(
      color: theme.primaryColor,
      child: new Stack(
        children: <Widget>[
          new Center(
            child: new Text("base"),
          ),
          new PositionedTransition(
            rect: animation,
            child: Material(
              borderRadius: const BorderRadius.only(
                  topLeft: const Radius.circular(24.0),
                  topRight: const Radius.circular(24.0)),
              elevation: 12.0,
              child: new Column(children: <Widget>[
                new Container(
                  height: _PANEL_HEADER_HEIGHT,
                  child: new Center(child: new Text("panel")),
                ),
                new Expanded(
                    child: new Center(
                        child: new Text("content")
                    )
                )
              ]),
            ),
          )
        ],
      ),
    );
  }

  Animation<RelativeRect> _getPanelAnimation(BoxConstraints constraints) {
    final double height = constraints.biggest.height;
    final double top = height - _PANEL_HEADER_HEIGHT;
    final double bottom = -_PANEL_HEADER_HEIGHT;
    return new RelativeRectTween(
      begin: new RelativeRect.fromLTRB(0.0, top, 0.0, bottom),
      end: new RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
    ).animate(new CurvedAnimation(parent: _animationControl, curve: Curves.linear));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        title: new Text("back_drop"),
        actions: <Widget>[
                new IconButton(
                  onPressed: () {
                    _animationControl.fling(velocity: _isPanelVisible ? -1.0 : 1.0);
                  },
                  icon: new AnimatedIcon(
                    icon: AnimatedIcons.close_menu,
                    progress: _animationControl.view,
                  ),
                ),
        ],
//        leading: new IconButton(
//          onPressed: () {
//            _animationControl.fling(velocity: _isPanelVisible ? -1.0 : 1.0);
//          },
//          icon: new AnimatedIcon(
//            icon: AnimatedIcons.close_menu,
//            progress: _animationControl.view,
//          ),
//        ),
      ),
      body: new LayoutBuilder(
        builder: _buildStack,
      ),
    );
  }
}
