import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:snackomat3000/main.dart';

class FortuneView extends StatefulWidget {
  final Map<String, dynamic> fortuneData;
  const FortuneView({Key? key, required this.fortuneData}) : super(key: key);

  @override
  State<FortuneView> createState() => _FortuneViewState();
}

StreamController<int>? controller;

class _FortuneViewState extends State<FortuneView> {
  @override
  void initState() {
    loadBool();
    controller?.close();
    controller = StreamController<int>();
    super.initState();
  }

  List<Color> colors = [Colors.red];

  Color color(int i) {
    if (i == 0) {
      return const Color(0xffeaac00);
    }
    if (i % 2 == 0) {
      return const Color(0xffFAB800);
    } else {
      return const Color(0xffdba000);
    }
  }

  Future<Widget> getDevIcon(String name) async {
    String path = "assets/$name.jpg";
    try {
      await rootBundle.load(path);
      return Image.asset(path);
    } catch (_) {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> data = widget.fortuneData['data'];
    int selected = 0;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.fortuneData['name']),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: widget.fortuneData['data'].isNotEmpty
            ? FortuneWheel(
                // styleStrategy: const UniformStyleStrategy(),
                rotationCount: 10,
                onFling: () {
                  if (data.contains(choose) && chooseme) {
                    do {
                      selected =
                          Random().nextInt(widget.fortuneData['data'].length);
                    } while (data[selected] != choose);
                  } else {
                    selected =
                        Random().nextInt(widget.fortuneData['data'].length);
                  }

                  controller?.add(selected);
                },
                onAnimationEnd: () async {
                  var img = await getDevIcon(data[selected]);
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(data[selected]),
                          content: img,
                          actions: [
                            ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Ok")),
                          ],
                        );
                      });
                },
                animateFirst: false,
                selected: controller!.stream,
                items: [
                    for (int i = 0; i < data.length; i++)
                      FortuneItem(
                          child: Text(widget.fortuneData['data'][i]),
                          style:
                              FortuneItemStyle(color: color(i), borderWidth: 0))
                  ])
            : const Center(
                child: Text("Keine Strafen in der Liste!"),
              ));
  }
}
