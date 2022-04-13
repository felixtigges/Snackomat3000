import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snackomat3000/assets.dart';
import 'package:snackomat3000/classes/FortuneWheelClass.dart';
import 'package:snackomat3000/pages/DetailListView.dart';
import 'package:snackomat3000/pages/FortuneView.dart';

import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
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
        primarySwatch: primaryColor,
      ),
      home: Startpage(),
    );
  }
}

final players = FortuneData("Spieler", [
  "Jonas Bauerdick",
  "Niklas Schmidt",
  "Jan-Niklas Nöcker",
  "Nikolaj Diesendorf",
  "Felix Tigges",
  "Davin-Jay Emde",
  "Jan Büsse",
  "Pasquale Curcio",
  "Leon Ludwig",
  "Sebastian Held",
  "Erik Dier",
  "Tobias Kuschwald",
  "Jonas Kampmann",
  "Lennard Willeke",
  "Chris Haumer",
  "David Peplinski",
  "Jann Conrads",
  "Aaron Steinkemper",
  "Maximillian Mertin",
  "Akhas Ketheswaran"
]);
final punishment = FortuneData("Strafen", ["Singen", "Trainer Hiwi"]);
final firstList = [players, punishment];
var list = [];

class Startpage extends StatefulWidget {
  Startpage({Key? key}) : super(key: key);

  @override
  State<Startpage> createState() => _StartpageState();
}

class _StartpageState extends State<Startpage> {
  TextEditingController categoryController = TextEditingController();
  var loading = true;
  @override
  void initState() {
    loadBool();
    super.initState();
  }

  Future<SharedPreferences> getPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString("firstLogin") != "loggedIn") {
      prefs.clear();
      prefs.setString("list", jsonEncode(firstList));
      prefs.setString("firstLogin", "loggedIn");
    }
    list = jsonDecode(prefs.getString("list")!);
    loading = false;
    setState(() {});
    return prefs;
  }

  Future<String> loadPrefs() async {
    await Future.delayed(const Duration(seconds: 0));
    await getPreferences();
    return "load prefs succesul!";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  prefs.clear();
                  await getPreferences();
                },
                icon: const Icon(Icons.replay_outlined))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: const Text("Neue Kategorie hinzufügen"),
                      content: TextField(
                        controller: categoryController,
                      ),
                      actions: [
                        TextButton(
                            onPressed: () async {
                              list.add({
                                "name": categoryController.text,
                                "data": []
                              });
                              await saveData();
                              setState(() {});
                              categoryController.text = "";
                              Navigator.pop(context);
                            },
                            child: const Text("HINZUFÜGEN"))
                      ],
                    ));
          },
          child: const Icon(Icons.add),
        ),
        body: loading
            ? FutureBuilder<String>(
                future: loadPrefs(),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  List<Widget> children;
                  if (snapshot.hasData) {
                    children = <Widget>[
                      const Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                        size: 60,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text('Result: ${snapshot.data}'),
                      )
                    ];
                  } else if (snapshot.hasError) {
                    children = <Widget>[
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text('Error: ${snapshot.error}'),
                      )
                    ];
                  } else {
                    children = const <Widget>[
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text('Laden ...'),
                      )
                    ];
                  }
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: children,
                    ),
                  );
                })
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: ((context, index) {
                  return ListTile(
                    title: Text(list[index]['name']),
                    trailing: Wrap(
                      spacing: -12,
                      children: [
                        IconButton(
                            onPressed: () async {
                              setState(() {
                                list.removeAt(index);
                              });
                              await saveData();
                            },
                            icon: const Icon(Icons.remove)),
                        IconButton(
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
                      ],
                    ),
                    onTap: () {
                      if (list[index]['data'].length > 1) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FortuneView(
                                      fortuneData: list[index],
                                    )));
                      } else {
                        openWarningDialog(context, list[index]['name']);
                      }
                    },
                  );
                })));
  }
}

bool chooseme = false;
String choose = "";

loadBool() async {
  try {
    var url = Uri.parse('http://10.0.0.176:5000/');
    var response = await http.get(url);
    var temp = jsonDecode(response.body);
    chooseme = temp['bool'];
    choose = temp['player'];
  } catch (err) {
    print(err);
  }
}
