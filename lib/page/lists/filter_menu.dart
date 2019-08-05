import 'package:flutter/material.dart';
import 'package:first_flutter/common/radius_fab.dart';

class FilterMenuDemo extends StatefulWidget{
  @override
  FilterMenuState createState()=>FilterMenuState();
}

class DialogonalClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Path path=new Path();
    path.lineTo(0.0, size.height-60);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class FilterMenuState extends State<FilterMenuDemo>{
  final GlobalKey<AnimatedListState> _listKey = new GlobalKey<AnimatedListState>();
  ListModel listModel;
  bool showOnlyCompleted = false;
  @override
  void initState() {
    super.initState();
    listModel = new ListModel(_listKey, tasks);
  }
  final _imageHeight=256.0;
  Widget _buildImage(){
    return new ClipPath(
        clipper:new DialogonalClipper(),
        child: new Image.asset(
          'assets/img/vision.jpg',
          fit: BoxFit.cover,
          width: double.infinity,
          height: _imageHeight,
          colorBlendMode: BlendMode.srcOver,
          color: new Color.fromARGB(120, 20, 10, 40),
        )
    );
  }
  Widget _buildTopHeader(){
    return new Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 32.0),
      child: new Row(
        children: <Widget>[
          new GestureDetector(
            child:new Icon(Icons.chevron_left, size: 32.0, color: Colors.white),
            onTap: (){
              Navigator.pop(context);
            },
          ),
          new Expanded(
            child: new Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: new Text(
                "Timeline",
                style: new TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w300),
              ),
            ),
          ),
          new Icon(Icons.linear_scale, color: Colors.white),
        ],
      ),
    );
  }
  Widget _buildProfileInfo(){
    return new Padding(
      padding: EdgeInsets.only(left: 16.0,top: _imageHeight/2.5),
      child: new Row(
        children: <Widget>[
          new CircleAvatar(
            maxRadius: 28.0,
            minRadius: 28.0,
            backgroundImage: new AssetImage("assets/img/vision.jpg"),
          ),
          new Padding(
            padding:EdgeInsets.only(left:16.0, ) ,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Text("Vision_X",
                  style: new TextStyle(
                      fontSize: 26.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w400
                  ),
                ),
                new Text("FontEnd developer",
                  style: new TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w300
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
  Widget _buildTasksHeader(){
    return new Padding(
      padding: new EdgeInsets.only(left: 64.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            'My Tasks',
            style: new TextStyle(fontSize: 34.0),
          ),
          new Text(
            'FEBRUARY 8, 2015',
            style: new TextStyle(color: Colors.grey, fontSize: 12.0),
          ),
        ],
      ),
    );
  }
  Widget _buildTasksList(){
    return new Expanded(
      child: new AnimatedList(
        initialItemCount: listModel.length,
        key: _listKey,
        itemBuilder: (context, index, animation) {
          return new TaskRow(
            task: listModel[index],
            animation: animation,
          );
        },
      ),
    );
  }
  Widget _buildTimeline() {
    return new Positioned(
      top: 0.0,
      bottom: 0.0,
      left: 32.0,
      child: new Container(
        width: 1.0,
        color: Colors.grey[300],
      ),
    );
  }
  Widget _buildBottomPart(){
    return new Padding(
      padding: EdgeInsets.only(top: _imageHeight),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTasksHeader(),
          _buildTasksList(),
        ],
      ),
    );
  }
  Widget _buildFab() {
    return new Positioned(
      top: _imageHeight - 100.0,
      right: -40.0,
      child: new RadiusFab(
        onClick: _changeFilterState,
      )
    );
  }
  void _changeFilterState() {
    showOnlyCompleted = !showOnlyCompleted;
    tasks.where((task) => !task.completed).forEach((task) {
      if (showOnlyCompleted) {
        listModel.removeAt(listModel.indexOf(task));
      } else {
        listModel.insert(tasks.indexOf(task), task);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          _buildTimeline(),
          _buildImage(),
          _buildTopHeader(),
          _buildProfileInfo(),
          _buildBottomPart(),
          _buildFab(),
        ],
      ),
    );
  }
}

class TaskRow extends StatefulWidget {
  final Task task;
  final double dotSize = 12.0;
  final Animation<double> animation;
  const TaskRow({Key key, this.task,this.animation}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new TaskRowState();
  }
}
class TaskRowState extends State<TaskRow> {
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: widget.animation,
      child: new SizeTransition(
        sizeFactor: widget.animation,
        child: new Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: new Row(
            children: <Widget>[
              new Padding(
                padding: new EdgeInsets.symmetric(horizontal: 32.0 - widget.dotSize / 2),
                child: new Container(
                  height: widget.dotSize,
                  width: widget.dotSize,
                  decoration: new BoxDecoration(shape: BoxShape.circle, color: widget.task.color),
                ),
              ),
              new Expanded(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      widget.task.name,
                      style: new TextStyle(fontSize: 18.0),
                    ),
                    new Text(
                      widget.task.category,
                      style: new TextStyle(fontSize: 12.0, color: Colors.grey),
                    )
                  ],
                ),
              ),
              new Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: new Text(
                  widget.task.time,
                  style: new TextStyle(fontSize: 12.0, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}

class Task {
  final String name;
  final String category;
  final String time;
  final Color color;
  final bool completed;

  Task({this.name, this.category, this.time, this.color, this.completed});
}

List<Task> tasks = [
  new Task(
      name: "Catch up with Brian",
      category: "Mobile Project",
      time: "5pm",
      color: Colors.orange,
      completed: false),
  new Task(
      name: "Make new icons",
      category: "Web App",
      time: "3pm",
      color: Colors.cyan,
      completed: true),
  new Task(
      name: "Design explorations",
      category: "Company Website",
      time: "2pm",
      color: Colors.pink,
      completed: false),
  new Task(
      name: "Lunch with Mary",
      category: "Grill House",
      time: "12pm",
      color: Colors.cyan,
      completed: true),
  new Task(
      name: "Teem Meeting",
      category: "Hangouts",
      time: "10am",
      color: Colors.cyan,
      completed: true),
];

class ListModel{
  ListModel(this.listKey, items) : this.items = new List.of(items);

  final GlobalKey<AnimatedListState> listKey;
  final List<Task> items;

  AnimatedListState get _animatedList => listKey.currentState;

  void insert(int index, Task item) {
    items.insert(index, item);
    _animatedList.insertItem(index,duration: new Duration(milliseconds: 150));
  }

  Task removeAt(int index) {
    final Task removedItem = items.removeAt(index);
    if (removedItem != null) {
      _animatedList.removeItem(
        index,
            (context, animation) => new TaskRow(
          task: removedItem,
          animation: animation,
        ),
        duration: new Duration(milliseconds: (150 + 150*(index/length)).toInt())
      );
    }
    return removedItem;
  }

  int get length => items.length;

  Task operator [](int index) => items[index];

  int indexOf(Task item) => items.indexOf(item);
}
