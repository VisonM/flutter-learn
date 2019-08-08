import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/services.dart';

class MusicRank extends StatefulWidget{
  final int id;
  MusicRank(this.id);
  @override
  MusicRankState createState()=>MusicRankState();
}


class MusicRankState extends State<MusicRank> {
  List _rankData=[];
  String title="排行榜";
  String coverImgUrl="";
  final double _appBarHeight = 256.0;
  _getHotMusicRank() async{
    print(widget.id);
    var url = 'http://192.168.3.81:3000/playlist/detail?id=${widget.id}';
    var httpClient = new HttpClient();
    Map _result=new Map();
    try{
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(utf8.decoder).join();
        var data = jsonDecode(json);
        _result = data['playlist'];
      }else {
       print('Error getting data:\nHttp status ${response.statusCode}');
      }
    }catch(exception){
      print("vision_error:$exception");
    }
    if (!mounted) return;
    setState(() {
      _rankData = _result["tracks"];
      title=_result["name"];
      coverImgUrl= _result["coverImgUrl"];
    });
  }
  @override
  void initState() {
    super.initState();
    _getHotMusicRank();
  }
  List<Widget> _renderRankItem(){
    return _rankData.map((item){
      return new Padding(
        padding:const EdgeInsets.all(10.0),
        child: _musicItem(item),
      );
    }).toList();
  }

   _singersAndAlbumText(List singerList, album){
     String str="";
     singerList.forEach((singerItem) {
       var index = singerList.indexOf(singerItem);
       index != singerList.length - 1 ?
       str += "${singerItem["name"]}/" :
       str += "${singerItem["name"]} — ${album["name"]}";
     });
    return str;
  }
  MaterialColor _matchColor(num){
    switch(num){
      case 1:
        return Colors.red;
      case 2:
        return Colors.pink;
      case 3:
        return Colors.blue;
      default:
        return Colors.blueGrey;
    }
  }

  Widget _rankNumber(index){
    var rankNum=index<10 ? "0$index" : "$index";
    return new Padding(
      padding: EdgeInsets.all(5),
      child: new Text(
        rankNum,
        style: TextStyle(
            color: _matchColor(index),
            fontSize: 16,
            fontFamily: index<=3?"Gochi Hand":Theme.of(context).textTheme.title.fontFamily,
            fontWeight: index<=3?FontWeight.bold:FontWeight.normal,
        ),
      ),
    );
  }

  Widget _musicItem(item) {
    var index=_rankData.indexOf(item)+1;
    return new Padding(
      padding: EdgeInsets.all(5.0),
      child:  new Row(
        children: <Widget>[
          _rankNumber(index),
          new Expanded(
            child: new Padding(
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new Flexible(
                        child: new Text(
                          item["name"],
                          overflow: TextOverflow.ellipsis,
                          style: new TextStyle(
                            fontSize: 20,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      item['alia'].isEmpty?
                        new Container():
                        new Flexible(
                          child: new Text(
                            "(${item['alia'][0]})",
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        )

                    ],
                  ),
                  new Row(
                    children: <Widget>[
                      new Flexible(
                      child: new Text(
                        "${_singersAndAlbumText(item["ar"],item["al"])}",
                          overflow: TextOverflow.ellipsis,
                          style: new TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          item['mv'] !=0 ?
            new Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: new Icon(Icons.videocam,color: Colors.black26,),
            )
            :
            new Container(),
          new Icon(Icons.linear_scale,color: Colors.black26,)
        ],
      ),
    );
  }
  List<Widget> _loading() {
    return <Widget>[
      new Container(
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
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blueGrey,
        fontFamily: Theme.of(context).textTheme.title.fontFamily,
        platform: Theme.of(context).platform,
      ),
      child: new Scaffold(
          body: new CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: _appBarHeight,
                flexibleSpace:FlexibleSpaceBar(
                  title: Text('$title'),
                  background: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Image.network(
                        coverImgUrl,
                        fit: BoxFit.cover,
                        height: _appBarHeight,
                      ),
                      // This gradient ensures that the toolbar icons are distinct
                      // against the background image.
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0.0, -1.0),
                            end: Alignment(0.0, -0.4),
                            colors: <Color>[Color(0x60000000), Color(0x00000000)],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                pinned: true,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.linear_scale,color: Colors.white,),
                    tooltip: 'more',
                  ),
                ],
              ),
              SliverList(
                delegate: SliverChildListDelegate(<Widget>[
                  AnnotatedRegion<SystemUiOverlayStyle>(
                    value: SystemUiOverlayStyle.dark,
                    child: new Container(),
                  ),
                  new Column(
                    children: _renderRankItem(),
                  )
                ]),
              )
            ],
//        children:  _rankData.isEmpty ?  _loading() :_renderRankItem()
          )
      ),
    );
  }
}

