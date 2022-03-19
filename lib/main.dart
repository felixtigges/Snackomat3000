import 'package:flutter/material.dart';
import 'package:snackomat3000/classes/FortuneWheelClass.dart';
import 'package:snackomat3000/pages/DetailListView.dart';
import 'package:snackomat3000/pages/FortuneView.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
      ),
      home: Startpage(),
    );
  }
}

final players = FortuneData("Spieler", ["Jonas Bauerdick", "Niklas Schmidt"]);
final punishment = FortuneData("Strafen", ["Singen", "Trainer Hiwi"]);

class Startpage extends StatelessWidget {
  Startpage({Key? key}) : super(key: key);

  final list = [players, punishment];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ListView.builder(
            itemCount: list.length,
            itemBuilder: ((context, index) {
              return ListTile(
                title: Text(list[index].name),
                trailing: IconButton(
                  icon: const Icon(Icons.change_circle),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewLists(
                                  data: list[index],
                                )));
                  },
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FortuneView(
                                fortuneData: list[index],
                              )));
                },
              );
            })));
  }
}

