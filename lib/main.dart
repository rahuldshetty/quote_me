import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Quote.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quote Me',
      theme: ThemeData(
        brightness: Brightness.dark
      ),
      home: MyHomePage(title: 'Quote Me'),
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
  _MyHomePageState createState() => _MyHomePageState();
}

Future<Quote> obtainJson() async{
  String url = 'http://quotes.stormconsultancy.co.uk/random.json';
  final response = await http.get(url);
  if (response.statusCode == 200){
    // Successful
    var jsonObj = jsonDecode(response.body);
    return Quote.fromJson(jsonObj);
  }
  return null;
}

class _MyHomePageState extends State<MyHomePage> {

  Future<Quote> quote;

  @override
  void initState(){
    super.initState();
    quote = obtainJson();
  }

  @override
    Widget build(BuildContext context) {
      // This method is rerun every time setState is called, for instance as done
      // by the _incrementCounter method above.
      //
      // The Flutter framework has been optimized to make rerunning build methods
      // fast, so that you can just rebuild anything that needs updating rather
      // than having to individually change instances of widgets.

      double c_height = MediaQuery.of(context).size.height*0.95;

      return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Container(
          child: FutureBuilder<Quote>(
            future: quote,
            builder: (context, snapshot){
              if(snapshot.hasData)
                return Container(
                  width: double.maxFinite,
                  height: c_height,
                  child:
                    Card(
                      elevation: 5,
                      child: Column(
                        children: [
                          Flexible(
                            child: Text(
                                snapshot.data.quote,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontFamily: 'IMFellDoublePica', fontSize: 32),
                            ),
                          ),
                          Expanded(
                            child: Text(""),
                          )
                          ,Flexible(
                            child: Text(
                                "- ${snapshot.data.author}",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontFamily: 'BalooTamma', fontSize: 22)
                            ),
                          ),
                          RaisedButton(
                            onPressed: (){
                              setState(() {
                                quote = obtainJson();
                              });

                            },
                            child: const Text('Refresh'),
                            textColor: Colors.white,
                            elevation: 5,
                          )
                        ],
                      ),
                    )
                );
              else if(snapshot.hasError){
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          )
        )
      );
    }

  List<Widget> _generateCards(){
    List<Quote> quotes = new List();
    int count = 5;


  }

}
