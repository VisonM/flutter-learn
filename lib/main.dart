import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:first_flutter/common/fancy_fab.dart';
import 'package:first_flutter/common/gradient_app_bar.dart';
import 'package:first_flutter/page/homepage.dart';
//import 'package:first_flutter/page/layout.dart';
import 'package:first_flutter/page/lists/list_entry.dart';
import 'package:splashscreen/splashscreen.dart';
//import 'package:first_flutter/page/music/music_rank_detail.dart';
import 'package:first_flutter/page/music/music_rank_list.dart';
void main() {
//  Routes.initRouters();
  runApp(
    MyApp()
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Planets',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        fontFamily: "Gochi Hand"
      ),
      home: MyHomePage(title: 'treva'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  SplashScreenDemo createState() => SplashScreenDemo();
}

class SplashScreenDemo extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
        seconds: 3,
        navigateAfterSeconds: new MyHomeDemo(),
        title: new Text('Vision_X',
          style: new TextStyle(
              color: Colors.black87,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 36.0
          ),),
        image: Image.asset(
          'assets/img/splash_two.png',
          fit: BoxFit.cover,
        ),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        onClick: ()=>print("Flutter Egypt"),
        loaderColor: Colors.black12
    );
  }
}
class MyHomeDemo extends StatefulWidget{
  @override
  _MyHomePageState createState()=>_MyHomePageState();
}
class _MyHomePageState extends State<MyHomeDemo> {
  int _counter = 0;
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }
  void _routerToLayout(param) {
    print(param);
    Navigator.of(context).push(new PageRouteBuilder(
      pageBuilder: (_,__,___)=> new MusicRankList(),
    ));
  }
  void _routerToList() {
    Navigator.of(context).push(new PageRouteBuilder(
      pageBuilder: (_,__,___)=> new ListEntry(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    final wordPair = new WordPair.random();
    return Scaffold(
      body: new Column(
        children: <Widget>[
          new GradientAppBar("$wordPair-$_counter"),
//          new Text('$_counter'),
          new HomePage()
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: new FancyFab(onAddPressed:_incrementCounter,onLayoutPressed:_routerToLayout,onListPressed: _routerToList,tooltip: "Menu")

    );
  }
}
