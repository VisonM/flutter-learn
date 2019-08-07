import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import './music_rank_detail.dart';
class MusicRankList extends StatefulWidget{
  @override
  MusicRankListState createState()=>MusicRankListState();
}

class MusicRankListState extends State<MusicRankList>{
  List _cloudRankList=[];
  List _globalRankList=[];
  _getALlMusicRank() async{
    var url = 'http://192.168.3.81:3000/toplist/detail';
    var httpClient = new HttpClient();
    List _result=[];
    try{
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(utf8.decoder).join();
        var data = jsonDecode(json);
        _result=data["list"];
        setState(() {
          _cloudRankList = _result.where((item) => !item["tracks"].isEmpty).toList();
          _globalRankList = _result.where((item) => item["tracks"].isEmpty).toList();
        });
      }else {
        print('Error getting data:\nHttp status ${response.statusCode}');
      }
    }catch(exception){
      print("vision_error:$exception");
    }
  }

  _navigatorToDetail(int id){
    Navigator.of(context).push(new PageRouteBuilder(
      pageBuilder: (_,__,___)=> new MusicRank(id),
    ));
  }
  @override
  void initState() {
    super.initState();
    _getALlMusicRank();
  }

  Widget _buildPoster(String url,String str){
    return new Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.3,
          height: MediaQuery.of(context).size.width * 0.3,
          decoration: BoxDecoration(
            image: DecorationImage(
              image:NetworkImage(url),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
        ),
        new Positioned(
          left: 5,
          bottom: 5,
          child: new Text(
            str,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: "Gochi Hand"
            ),
          ),
        )
      ],
    );
  }

  List<Widget> _buildPosterAndTitle(){
    return _globalRankList.map((item){
      return InkResponse(
        child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.3333,
            child: Padding(
              padding: EdgeInsets.only(right: 5,bottom: 10,left: 5),
              child: new Column(
                children: <Widget>[
                  _buildPoster(item["coverImgUrl"], item["updateFrequency"]),
                  new Padding(
                      padding: EdgeInsets.only(left: 5,top: 5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: new Text(
                          item["name"],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                  )
                ],
              ),
            )
        ),
        onTap: (){_navigatorToDetail(item["id"]);},
      );
    }).toList();
  }
  Widget _songText(str){
    return new Flexible(
      child: new Text(
        "$str",
        overflow: TextOverflow.ellipsis,
        style: new TextStyle(
          color: Colors.black54,
          fontSize: 14,
        ),
      ),
    );
  }
  List<Widget> _buildSongList(List songList){
    return songList.map((item){
      var index = songList.indexOf(item)+1;
      return new Padding(
        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
        child: new Row(
          children: <Widget>[
            _songText("$index.${item['first']}-${item['second']}"),
          ],
        ),
      );
    }).toList();
  }

  List<Widget> _buildCloudRankItem(){
    return _cloudRankList.map((item){
      return new InkWell(
        child: new Padding(
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
          child: new Row(
            children: <Widget>[
              _buildPoster(item["coverImgUrl"],item["updateFrequency"]),
              new Expanded(
                child: new Column(
                  children: _buildSongList(item["tracks"]),
                ),
              )
            ],
          ),
        ),
        splashColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
        // Generally, material cards do not have a highlight overlay.
        highlightColor: Colors.transparent,
        onTap: (){_navigatorToDetail(item["id"]);},
      );
    }).toList();
  }
  Widget _title(String title){
    return new Padding(
      padding: EdgeInsets.all(10.0),
      child:Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style:TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          )
        ),
      )
    );
  }
  Widget _buildCloudRankList(){
    return new Column(
      children: <Widget>[
        _title("云音乐排行榜"),
        new Column(
          children: _buildCloudRankItem(),
        )
      ],
    );
  }
  Widget _buildGlobalRankList(){
    return new Column(
      children: <Widget>[
        _title("全球音乐排行榜"),
        new Wrap(
          children: _buildPosterAndTitle(),
        )
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("排行榜"),
      ),
      body: new ListView(
        children: <Widget>[
          _buildCloudRankList(),
          new Divider(
            height: 30,
          ),
          _buildGlobalRankList(),
        ],
      ),
    );
  }
}

