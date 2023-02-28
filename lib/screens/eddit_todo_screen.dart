import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../database/db_handler.dart';
import '../models/db_model.dart';

class EdditScreen extends StatefulWidget {
  final String titel;
  final String des;
  int id;
  EdditScreen(
      {super.key, required this.titel, required this.des, required this.id});

  @override
  State<EdditScreen> createState() => _EdditScreenState();
}

class _EdditScreenState extends State<EdditScreen> {
  TextEditingController _textController = TextEditingController();
  TextEditingController _desController = TextEditingController();

  DbHandler? dbHandler;
  late Future<List<NoteModel>> noteList;
  bool _isCheked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHandler = DbHandler();
    loadData();
  }

  loadData() {
    noteList = dbHandler!.getNoteList();
  }

  UpdateTask() {
    try {
      dbHandler!
          .Update(NoteModel(
              title: _textController.text,
              des: _desController.text,
              id: widget.id))
          .then(
            (value) => Fluttertoast.showToast(
              msg: "Task Updated",
            ),
          )
          .onError(
            (error, stackTrace) => Fluttertoast.showToast(
              msg: error.toString(),
            ),
          );
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _textController.text = widget.titel;
    _desController.text = widget.des;
    return Scaffold(
      appBar: AppBar(
        title: const Text("What is in your mind"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  labelText: "Title"),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              maxLines: 8,
              controller: _desController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  labelText: "Description"),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  UpdateTask();
                  noteList = dbHandler!.getNoteList();
                  setState(() {
                    Navigator.pop(context);
                  });
                },
                child: const Text("Update Task"))
          ],
        ),
      ),
    );
  }
}
