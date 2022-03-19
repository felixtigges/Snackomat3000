import 'package:flutter/material.dart';
import 'package:snackomat3000/classes/FortuneWheelClass.dart';

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

_openWarningDialog(context, String dataName) => showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Warnung"),
        content: Text("Es müssen mindestens zwei $dataName vorhanden sein."),
        actions: [
          ElevatedButton(
              onPressed: () => Navigator.pop(context), child: const Text("Ok")),
        ],
      );
    });

class _ViewListsState extends State<ViewLists> {
  _removeData(int index) {
    if (widget.data.data.length == 2) {
      _openWarningDialog(context, widget.data.name);
    } else {
      widget.data.data.removeAt(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            textEditingController.text = "";
            await openAddDialog(context, widget.data);
            setState(() {});
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
                      _removeData(index);
                    });
                  },
                ),
              );
            })));
  }
}
