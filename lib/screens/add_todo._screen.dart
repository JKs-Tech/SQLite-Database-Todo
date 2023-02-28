import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sql_todo/database/db_handler.dart';
import 'package:sql_todo/models/db_model.dart';
import 'package:sql_todo/screens/home_screen.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _desController = TextEditingController();

  DbHandler? dbHandler;
  late Future<List<NoteModel>> noteList;
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

  addtask() {
//inser data
    try {
      dbHandler!
          .insert(
              NoteModel(title: _textController.text, des: _desController.text))
          .then(
            (value) => Fluttertoast.showToast(
              msg: "Task Added",
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
              controller: _desController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  labelText: "Description"),
              maxLines: 5,
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  addtask();
                  noteList = dbHandler!.getNoteList();
                  setState(() {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyHomePage(),
                        ));
                  });
                },
                child: const Text("Add Task"))
          ],
        ),
      ),
    );
  }
}
