import 'package:flutter/material.dart';
import 'package:sql_todo/models/db_model.dart';
import 'package:sql_todo/screens/add_todo._screen.dart';
import 'package:sql_todo/screens/eddit_todo_screen.dart';

import '../database/db_handler.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTodoScreen(),
              ));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Flutter SQLite"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: noteList,
              builder: (context, AsyncSnapshot<List<NoteModel>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: ValueKey<int>(snapshot.data![index].id!),
                        direction: DismissDirection.startToEnd,
                        background: Container(
                          child: Icon(Icons.delete),
                        ),
                        onDismissed: (direction) {
                          setState(() {
                            dbHandler!.delete(snapshot.data![index].id!);
                            noteList = dbHandler!.getNoteList();
                            snapshot.data!.remove(snapshot.data![index]);
                          });
                        },
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EdditScreen(
                                    id: snapshot.data![index].id!,
                                    titel:
                                        snapshot.data![index].title.toString(),
                                    des: snapshot.data![index].des.toString(),
                                  ),
                                ));
                          },
                          child: Card(
                            child: ListTile(
                              title: Padding(
                                padding: const EdgeInsets.all(9.0),
                                child: Text(
                                  " Titel : ${snapshot.data![index].title.toString()}",
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 19),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.all(9.0),
                                child: Text(
                                  "Des : ${snapshot.data![index].title.toString()}",
                                  maxLines: 5,
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              // trailing: IconButton(
                              //     onPressed: () {

                              //       _isCheked = !_isCheked;

                              //       setState(() {});
                              //     },
                              //     icon: Icon(_isCheked
                              //         ? Icons.check_box_outline_blank
                              //         : Icons.check_box)),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
