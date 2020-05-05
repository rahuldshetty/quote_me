import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flip_card/flip_card.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'spf.dart';
import 'Quote.dart';



void main(){
  runApp(
      MyApp()
  );
}

DarkThemeProvider darkThemeProvider = DarkThemeProvider();

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    return ChangeNotifierProvider(
      create: (_){
        return darkThemeProvider;
      },
      child: Consumer<DarkThemeProvider>(
        builder: (BuildContext context, value, Widget child){
          return MaterialApp(
            title: 'Quote Me',
            theme: ThemeData(
                brightness: darkThemeProvider.theme
            ),
            debugShowCheckedModeBanner: false,
            home: MyHomePage(title: 'Quote Me'),
          );
        },
      ),
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
  if (response.statusCode == 200 ){
    // Successful
    var jsonObj = jsonDecode(response.body);
    return Quote.fromJson(jsonObj);
  }
  return null;
}

bool flipFront = false;

class _MyHomePageState extends State<MyHomePage> {

  Future<Quote> quote1, quote2;


  @override
  void initState(){
    super.initState();
    quote1 = obtainJson();
    quote2 = obtainJson();
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
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.color_lens),
              onPressed:(){
                  setState(() {
                    darkThemeProvider.darkTheme = !darkThemeProvider.darkTheme;
                  });
              },
            )
          ],
        ),
        body:
          Container(
              width: double.maxFinite,
              height: c_height,
              padding: EdgeInsets.all(35.0),
              child: FlipCard(
                  onFlip: (){
                    flipFront = !flipFront;
                    setState(() {
                      if(flipFront){
                        quote1 = obtainJson();
                      }
                      else{
                        quote2 = obtainJson();
                      }

                    });
                  },
                  front: Card(
                      child:
                        FutureBuilder<Quote>(
                            future: quote1,
                            builder: (context, snapshot){
                              if(snapshot.hasData)
                                return Column(
                                  children: [
                                    Flexible(
                                      child: Container(
                                        padding: EdgeInsets.all(40),
                                        child:
                                        AutoSizeText(
                                          snapshot.data.quote,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontFamily: 'IMFellDoublePica', fontSize: 26),
                                          minFontSize: 20,
                                          overflow: TextOverflow.visible,
                                        ),
                                      ) ,

                                    ),
                                    Expanded(
                                      child: AutoSizeText(""),
                                    ),
                                    Flexible(
                                      child: AutoSizeText(
                                          "- ${snapshot.data.author}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontFamily: 'BalooTamma', fontSize: 22),
                                          minFontSize: 20,
                                          overflow: TextOverflow.visible,
                                      ),
                                    )
                                  ],
                                );
                              else if(snapshot.hasError)
                                return AutoSizeText("${snapshot.error}");
                              return null;
                            },
                        )
                  ),
                  back: Card(
                      child:
                      FutureBuilder<Quote>(
                        future: quote2,
                        builder: (context, snapshot2){
                          if(snapshot2.hasData)
                            return Column(
                              children: [
                                Flexible(
                                  child: Container(
                                    padding: EdgeInsets.all(40),
                                    child:
                                    AutoSizeText(
                                      snapshot2.data.quote,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontFamily: 'IMFellDoublePica', fontSize: 26),
                                      minFontSize: 20,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ) ,
                                ),
                                Expanded(
                                  child: AutoSizeText(""),
                                )
                                ,Flexible(
                                  child: AutoSizeText(
                                      "- ${snapshot2.data.author}",
                                      textAlign: TextAlign.center,
                                      minFontSize: 20,
                                      maxLines: 1,
                                      style: TextStyle(fontFamily: 'BalooTamma', fontSize: 22)
                                  ),
                                )
                              ],
                            );
                          else if(snapshot2.hasError)
                            return Text("${snapshot2.error}");
                          return null;
                        },
                      )
                  )
              )
          )
      );
    }

}
