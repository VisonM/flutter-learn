import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:first_flutter/services/request.dart';
class Play extends StatefulWidget{
  final int id;
  Play(this.id);
  @override
  PlayState createState()=>PlayState();
}

class PlayState extends State<Play> with TickerProviderStateMixin{
  static final GlobalKey<ScaffoldState> _scaffoldKey=GlobalKey<ScaffoldState>();
  AnimationController _rotationController;
  CurvedAnimation _rotationAnimation;
  AudioPlayer audioPlayer;
  bool isPlaying = false;
  Map _musicData=new Map();
  var requestApi=new RequestApi();

  void _getMusicDetail() async{
    String url="http://192.168.3.81:3000/song/detail?ids=${widget.id}";
    var data=await requestApi.getData(url);

    setState(() {
      _musicData=data["songs"][0];
      print(data["songs"][0]);
    });
  }
  void _getAudioUrl() async{
    String url="http://192.168.3.81:3000/song/url?id=${widget.id}";
    var data=await requestApi.getData(url);
    var audioUrlStr=data["data"][0]["url"];
    int result=await audioPlayer.play(audioUrlStr);
    if(result == 1){
      setState(() {
        isPlaying=true;
        _rotationController.forward();
      });
    }
  }
  @override
  void initState() {
    super.initState();
    audioPlayer = new AudioPlayer();
    _getMusicDetail();
    _getAudioUrl();
    _rotationController=new AnimationController(vsync: this,duration: Duration(seconds: 15));
    _rotationAnimation = new CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    );
    _rotationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _rotationController.repeat();
      } else if (status == AnimationStatus.dismissed) {
        _rotationController.forward();
      }
    });
    audioPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        isPlaying=false;
        _rotationController.stop();
        audioPlayer.pause();
      });
    });
    audioPlayer.onPlayerError.listen((msg) {
      _rotationController.reset();
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(msg),backgroundColor: Colors.red,));
      setState(() {
//        playerState = PlayerState.stopped;
//        duration = Duration(seconds: 0);
//        position = Duration(seconds: 0);
      });
    });
//    _rotationController.forward();
  }
  @override
  void deactivate() {
    audioPlayer.stop();
    super.deactivate();
  }

  @override
  void dispose() {
    audioPlayer.release();
    _rotationController.dispose();
    super.dispose();
  }

  void _togglePlay(){
    if(isPlaying){
      setState(() {
        isPlaying=false;
        _rotationController.stop();
        audioPlayer.pause();
      });
    }else{
      setState(() {
        isPlaying=true;
        _rotationController.repeat();
        audioPlayer.resume();
      });
    }
  }

  Widget _buildBackground(){
    return new Positioned(
      child: new ClipRect(
        child: new BackdropFilter(
          filter: new ImageFilter.blur(sigmaX: 80, sigmaY: 80),
          child: new Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                _buildTopHeader(),
                _buildCirclePoster(),
                new SizedBox(
                  height: 50.0,
                  child: new Center(
                    child: new Container(
                      margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
                      height: 5.0,
                    ),
                  ),
                ),
                _buildGrid(),
                _buildSlider(),
                _buildController()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopHeader(){
    return new Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 32.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new GestureDetector(
            child:new Icon(Icons.chevron_left, size: 32.0, color: Colors.white),
            onTap: (){
              Navigator.pop(context);
            },
          ),
          new Expanded(
            child: new Align(
              alignment: Alignment.center,
              child: new Column(
                children: <Widget>[
                  new Text(
                    "${_musicData['name']}",
                    style: new TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                    ),
                  ),
                  new Text(
                    "${_musicData['ar'][0]['name']}",
                    style: new TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                    ),
                  ),
                ],
              )
            ),
          ),
          new GestureDetector(
            child: new Icon(Icons.more_horiz, color: Colors.white),
            onTap: (){
              print("hey rotate");
              _rotationController.forward();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCirclePoster(){
    return RotationTransition(
      turns: _rotationAnimation,
      child: new Container(
        width: 250.0,
        height: 250.0,
        child: new Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage("${_musicData['al']['picUrl']}"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 5.0, color: Colors.black.withOpacity(0.1)),
        ),
      ),
    );
  }
  Widget _buildGrid(){
    return new Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.favorite,color: Colors.red,),
          ),
          IconButton(
            icon: Icon(Icons.cloud_download,color: Colors.white,),
          ),
          IconButton(
            icon: Icon(Icons.hearing,color: Colors.white,),
          ),
          IconButton(
            icon: Icon(Icons.comment,color: Colors.white,),
          ),
          IconButton(
            icon: Icon(Icons.more_vert,color: Colors.white,),
          )
        ],
      ),
    );
  }

  Widget _buildSlider(){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0,horizontal: 20),
      child: new Row(
        children: <Widget>[
          new Text(
            "00:00",
            style: TextStyle(
              color: Colors.white10,
              fontSize: 10,
            ),
          ),
          new Expanded(
            child: new Slider(
              value: 0.5, // 当前滑块定位到的值
              onChanged: (val) { // 滑动监听
                setState(() { // 通过setState设
                });
              },
              onChangeStart: (val) { // 开始滑动时的监听
                print('changeStart: val = $val');
              },
              onChangeEnd: (val) { // 滑动结束时的监听
                print('changeEnd: val = $val');
              },
              min: 0, // 最小值
              max: 1, // 最大值
              activeColor: Colors.white, //滑动过的颜色
              inactiveColor: Colors.white10, //未达到的颜色
            ),
          ),
          new Text(
            "04:27",
            style: TextStyle(
              color: Colors.white10,
              fontSize: 10,
            ),
          )
        ],
      ),
    );
  }
  Widget _buildController(){
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.loop,color: Colors.white,size: 30,),
        ),
        IconButton(
          icon: Icon(Icons.skip_previous,color: Colors.white,size: 35,),
        ),
        new Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 1,color: Colors.white),
          ),
          child: IconButton(
            onPressed: (){
              _togglePlay();
            },
            icon: Icon(isPlaying?Icons.pause:Icons.play_arrow,color: Colors.white,size: 40,),
          ),
        ),
        IconButton(
          icon: Icon(Icons.skip_next,color: Colors.white,size: 35,),
        ),
        IconButton(
          icon: Icon(Icons.playlist_play,color: Colors.white,size: 35,),
        ),
      ],
    );
  }
  Widget _loading() {
    return new Container(
      height: 300,
      child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new CircularProgressIndicator(strokeWidth: 1.0,),
              new Text("正在加载",style:new TextStyle(color: Colors.blueAccent)),
            ],
          )
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      body: _musicData.isEmpty?
        _loading():
        new Stack(
          children: <Widget>[
            new ConstrainedBox(
              constraints: const BoxConstraints.expand(),
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/img/vision.jpg',
                image:  "${_musicData['al']['picUrl']}",
                fit: BoxFit.cover,
              )
            ),
            _buildBackground(),

          ],
        ),
    );
  }
}
