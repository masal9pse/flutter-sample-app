// @dart=2.9
import 'package:flutter/material.dart';

import 'DI.dart';


void main() {
  final debug = true;
  final container = DiContainer();

  // Hogeインスタンスの登録
  container.bind<Hoge>(() => Hoge());

  if (debug) {
    // デバッグがONのときはモックを登録
    // bindのジェネリクスにインターフェースになる側のApiを指定しておくのがみそ
    container.bind<Api>(() => ApiMock());
  } else {
    // 通常時
    container.bind<Api>(() => Api());
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({this.title});
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HogeWidget()),
              );
            }, child: Text('APIボタン'))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class HogeWidget extends StatelessWidget {
  // 自動的に型に合わせたインスタンスを生成してくれる
  // Apiがモックかどうかに依存せずに使える
  final Api _api = DiContainer().make();
  final Hoge _hoge = DiContainer().make();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _api.getJsonData(),
      builder: (context, snapShot) {
        if (!snapShot.hasData) return CircularProgressIndicator();
        return Text(_hoge.getHoge() + snapShot.data);
      },
    );
  }
}
