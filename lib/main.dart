
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

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
      home:const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
List punishments = ["Singen", "waschen", "Trainer Hiwi", "Opfer der Woche", ];

class _MyHomePageState extends State<MyHomePage> {
  StreamController<int> controller = new StreamController<int>();
  final TextEditingController _textFieldController = new TextEditingController();
  Future<void> _displayTextInputDialog(BuildContext context) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('TextField in Dialog'),
          content: TextField(
            onChanged: (value) {
     
            },
            onSubmitted: (value){
              
              punishments.add(value);
              setState(() {
                
              });
            },
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: "Text Field in Dialog"),
          ),
        );
      });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(onPressed: ()  {
          setState(() {
            punishments.length > 2  ? punishments.removeLast()   : null;
          });
        }, icon: Icon(Icons.remove)),
        IconButton(onPressed: () {
          _displayTextInputDialog(context);
        }, icon: const Icon(Icons.add))
      ]),
      body: punishments.isNotEmpty ? FortuneWheel(
  // changing the return animation when the user stops dragging
  /*physics: CircularPanPhysics(
    duration: const Duration(seconds: 1),
    curve: Curves.decelerate,
  ),*/
  rotationCount: 2,
   onFling: () {
    controller.add(Random().nextInt(punishments.length));
  },
  animateFirst: false,
  selected: controller.stream,
  items: [for (var punishment in punishments) FortuneItem(child: Text(punishment))]
) : Center(child: Text("Keine Strafen in der Liste!"),)
    );
  }
}
