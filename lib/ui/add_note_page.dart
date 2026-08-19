import "package:database_sqflite/bloc/db_bloc.dart";
import "package:database_sqflite/bloc/db_events.dart";
import "package:database_sqflite/cubit/note_cubit.dart";
import "package:database_sqflite/database/db_helper.dart";
import "package:database_sqflite/model/note_model.dart";
import "package:database_sqflite/provider/db_provider.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
class AddNotePage extends StatelessWidget{
  bool isUpdate;
  int id;
  String title;
  String desc;
  DBHelper dbHelper = DBHelper.getInstance();
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  AddNotePage({this.isUpdate = false, this.id = 0, this.title = "", this.desc = ""});

  @override
  Widget build(BuildContext context){

    if(isUpdate){
      titleController.text = title;
      descController.text = desc;
    }

    return Scaffold(
      appBar: AppBar(
        title:   Text(
          isUpdate ? "Update Note" : "Add Note",
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
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
                      if (isUpdate) {
                        context.read<DbBloc>().add(
                            UpdateNote(
                               updateNote: NoteModel(
                                   title: titleController.text,
                                   desc: descController.text,
                                   createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
                                   id: id
                               )
                            )
                        );
                      } else {
                        context.read<DbBloc>().add(
                            AddNote(
                              newNote: NoteModel(
                                  title: titleController.text,
                                  desc: descController.text,
                                  createdAt: DateTime.now().millisecondsSinceEpoch.toString()
                              )
                            )
                        );
                      }
                      Navigator.pop(context);

                    },
                    child: Text(isUpdate ? "Update" : "Save"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

    );
  }

}