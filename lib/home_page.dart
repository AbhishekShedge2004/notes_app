import "package:database_sqflite/add_note_page.dart";
import "package:database_sqflite/db_helper.dart";
import "package:database_sqflite/db_provider.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";
import "package:sqflite/sqflite.dart";

class HomePage extends StatelessWidget {

  List<Map<String, dynamic>> allNotes = [];
  DateFormat mFormat = DateFormat.yMd();

  @override
  Widget build(BuildContext context) {

    context.read<DBProvider>().getInitialNotes();

    return Scaffold(
      appBar: AppBar(
        title: Text("MY NOTES"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Consumer<DBProvider>(builder: (_, provider, __){
        allNotes = provider.getAllNotes();
        return allNotes.isNotEmpty
            ? ListView.builder(
          itemCount: allNotes.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(allNotes[index][DBHelper.COLUMN_NOTE_TITLE], overflow: TextOverflow.ellipsis, maxLines: 2,)),
                  Text(mFormat.format(DateTime.fromMillisecondsSinceEpoch(int.parse(allNotes[index][DBHelper.COLUMN_NOTE_CREATE_AT]))), style: TextStyle(fontSize: 10), )
                ],
              ),
              subtitle: Text(allNotes[index][DBHelper.COLUMN_NOTE_DESC], maxLines: 3, overflow: TextOverflow.ellipsis,),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      var title = allNotes[index][DBHelper.COLUMN_NOTE_TITLE];
                      var desc = allNotes[index][DBHelper.COLUMN_NOTE_DESC];
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddNotePage(isUpdate: true, id: allNotes[index][DBHelper.COLUMN_NOTE_ID], title: title, desc: desc,),));

                    },
                    icon: Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () async {
                      context.read<DBProvider>().deleteNote(mId: allNotes[index][DBHelper.COLUMN_NOTE_ID]);

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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddNotePage(),));

                  },
                  child: Text("Add First Note"),
                ),
              ],
            ),
          ),
        );
      }),
      floatingActionButton: context.watch<DBProvider>().getAllNotes().isNotEmpty
          ? FloatingActionButton(
              onPressed: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddNotePage(),));
              },
              child: Icon(Icons.add),
            )
          : null,
    );
  }

}
