import 'package:flutter/material.dart';
import 'package:snackomat3000/classes/FortuneWheelClass.dart';
import 'package:snackomat3000/pages/FortuneView.dart';

class ViewLists extends StatefulWidget {
  final FortuneData data;
  const ViewLists({Key? key, required this.data}) : super(key: key);

  @override
  State<ViewLists> createState() => _ViewListsState();
}

TextEditingController textEditingController = TextEditingController();
Future<String?> openAddDialog(context, FortuneData data) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(data.name + " hinzufügen"),
            content: TextField(
              controller: textEditingController,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    data.data.add(textEditingController.text);
                    Navigator.of(context).pop();
                  },
                  child: const Text("HINZUFÜGEN"))
            ],
          ));


class _ViewListsState extends State<ViewLists> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            textEditingController.text = "";
            await openAddDialog(context, widget.data);
            setState(() {
              
            });
          },
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
            itemCount: widget.data.data.length,
            itemBuilder: ((context, index) {
              return ListTile(
                title: Text(widget.data.data[index]),
                trailing: IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      widget.data.data.removeAt(index);
                    });
                  },
                ),
              );
            })));
  }
}
