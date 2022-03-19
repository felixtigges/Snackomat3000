import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:snackomat3000/classes/FortuneWheelClass.dart';

class FortuneView extends StatefulWidget {
  final FortuneData fortuneData;
  const FortuneView({ Key? key, required this.fortuneData }) : super(key: key);

  @override
  State<FortuneView> createState() => _FortuneViewState();
  
}

  StreamController<int>? controller;
  
class _FortuneViewState extends State<FortuneView> {
  @override
  void initState() {
    controller?.close();
    controller = StreamController<int>();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fortuneData.name),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: (){
          Navigator.pop(context);
        },),
      ),
      body: widget.fortuneData.data.isNotEmpty
            ? FortuneWheel(
               
                rotationCount: 2,
                onFling: () {
                  controller?.add(Random().nextInt(widget.fortuneData.data.length));
                },
                animateFirst: false,
                selected: controller!.stream,
                items: [
                    for (var punishment in widget.fortuneData.data)
                      FortuneItem(child: Text(punishment))
                  ])
            : const Center(
                child: Text("Keine Strafen in der Liste!"),
              ));
  }
}