import "package:database_sqflite/db_helper.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:sqflite/sqflite.dart";

class HomePage extends StatefulWidget {
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    getMyNotes();
  }

  List<Map<String, dynamic>> allNotes = [];
  DBHelper dbHelper = DBHelper.getInstance();
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  DateFormat mFormat = DateFormat.yMd();

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
        title: Text("MY NOTES"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [],
      ),
      body: allNotes.isNotEmpty
          ? ListView.builder(
              itemCount: allNotes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(allNotes[index][DBHelper.COLUMN_NOTE_TITLE]),
                      Text(mFormat.format(DateTime.fromMillisecondsSinceEpoch(int.parse(allNotes[index][DBHelper.COLUMN_NOTE_CREATE_AT]))), style: TextStyle(fontSize: 10),)
                    ],
                  ),
                  subtitle: Text(allNotes[index][DBHelper.COLUMN_NOTE_DESC]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          titleController.text =
                              allNotes[index][DBHelper.COLUMN_NOTE_TITLE];
                          descController.text =
                              allNotes[index][DBHelper.COLUMN_NOTE_DESC];
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return getBottomSheetUi(
                                isUpdate: true,
                                id: allNotes[index][DBHelper.COLUMN_NOTE_ID],
                              );
                            },
                            isDismissible: false,
                            enableDrag: false
                          );
                        },
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () async {
                          bool check = await dbHelper.deleteNote(
                            id: allNotes[index][DBHelper.COLUMN_NOTE_ID],
                          );
                          if (check) {
                            getMyNotes();
                          }
                        },
                        icon: Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                );
              },
            )
          : Center(
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("No Notes yet"),
                    OutlinedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return getBottomSheetUi();
                          },
                          isDismissible: false,
                          enableDrag: false
                        );
                      },
                      child: Text("Add First Note"),
                    ),
                  ],
                ),
              ),
            ),

      floatingActionButton: allNotes.isNotEmpty
          ? FloatingActionButton(
              onPressed: () async {
                titleController.clear();
                descController.clear();

                showModalBottomSheet(
                  context: context,
                  isDismissible: false,
                  enableDrag: false,
                  builder: (context) {
                    return getBottomSheetUi();
                  },
                );
              },
              child: Icon(Icons.add),
            )
          : null,
    );
  }

  Future<void> getMyNotes() async {
    allNotes = await dbHelper.getAllNotes();
    setState(() {});
  }

  Widget getBottomSheetUi({int id = 0, isUpdate = false}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
            isUpdate ? "Update Note" : "Add Note",
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 21),
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(21),
              ),
              prefixIcon: Icon(Icons.title),
              hintText: "Enter Note Title",
              label: Text("Title"),
            ),
          ),
          SizedBox(height: 11),
          TextField(
            controller: descController,
            maxLines: 3,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(21),
              ),
              hintText: "Enter Note Description",
              label: Text("Description"),
              prefixIcon: Icon(Icons.description),
            ),
          ),
          SizedBox(height: 11),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    bool check = false;
                    if (isUpdate) {
                      check = await dbHelper.updateNote(
                        updatedTitle: titleController.text,
                        updatedDesc: descController.text,
                        updatedAt: DateTime.now().millisecondsSinceEpoch.toString(),
                        id: id,
                      );
                    } else {
                      check = await dbHelper.addNote(
                        title: titleController.text,
                        desc: descController.text,
                        createdAt: DateTime.now().millisecondsSinceEpoch.toString()
                      );
                    }
                    if (check) {
                      getMyNotes();
                      Navigator.pop(context);
                    }
                  },
                  child: Text(isUpdate ? "Update" : "Save"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
