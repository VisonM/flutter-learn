import 'package:flutter/material.dart';
import 'package:first_flutter/common/gradient_app_bar.dart';
import 'dart:io';
import 'dart:convert';

class MusicRank extends StatefulWidget{
  @override
  MusicRankState createState()=>MusicRankState();
}


class MusicRankState extends State<MusicRank> {

  List _rankData=[];
  _getHotMusicRank() async{
    var url = 'http://192.168.3.81:3000/top/list?idx=1';
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

  List<Widget> _singersAndAlbum(List singerList, album){
    return singerList.map((singerItem){
      var index = singerList.indexOf(singerItem);
      return index != singerList.length-1?
        new Text(
          "${singerItem["name"]}/",
          style: new TextStyle(
            color: Colors.grey,
          ),
        )
        :
        new Flexible(
          child: new Text(
            "${singerItem["name"]} — ${album["name"]}",
            overflow: TextOverflow.ellipsis,
            style: new TextStyle(
              color: Colors.grey,
            ),
          ),
        );

    }).toList();
  }

  Widget _rankNumber(index){
    var rankNum=index<10 ? "0$index" : "$index";
    return new Padding(
      padding: EdgeInsets.all(5),
      child: new Text(
        rankNum,
        style: TextStyle(
            color: index<=3?Colors.red:Colors.grey,
            fontSize: 16,
            fontWeight: index<=3?FontWeight.bold:FontWeight.normal,
            fontFamily: "Poppins"
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
                    children: _singersAndAlbum(item["ar"],item["al"]),
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
    return new Scaffold(
      appBar: new AppBar(
        title: Text("云音乐热歌榜"),
      ),
      body: new ListView(
        children:  _rankData.isEmpty ?  _loading() :_renderRankItem()
//          children:   _loading()
      )
    );
  }
}

