import "package:database_sqflite/bloc/db_bloc.dart";
import "package:database_sqflite/bloc/db_events.dart";
import "package:database_sqflite/bloc/db_state.dart";
import "package:database_sqflite/model/note_model.dart";
import "package:database_sqflite/ui/add_note_page.dart";
import "package:database_sqflite/cubit/note_cubit.dart";
import "package:database_sqflite/cubit/note_state.dart";
import "package:database_sqflite/database/db_helper.dart";
import "package:database_sqflite/provider/db_provider.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";
import "package:sqflite/sqflite.dart";

class HomePage extends StatelessWidget {

  List<NoteModel> allNotes = [];
  DateFormat mFormat = DateFormat.yMd();

  @override
  Widget build(BuildContext context) {

    context.read<DbBloc>().add(GetInitialNotes());

    return Scaffold(
      appBar: AppBar(
        title: Text("MY NOTES"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<DbBloc, DBState>(
        builder: (context, state) {

          if(state is DBLoadingState){
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if(state is DBLoadedState){
            allNotes = state.mData;
            return allNotes.isNotEmpty
                ? ListView.builder(
              itemCount: allNotes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(allNotes[index].title, overflow: TextOverflow.ellipsis, maxLines: 2,)),
                      Text(mFormat.format(DateTime.fromMillisecondsSinceEpoch(int.parse(allNotes[index].createdAt))), style: TextStyle(fontSize: 10), )
                    ],
                  ),
                  subtitle: Text(allNotes[index].desc, maxLines: 3, overflow: TextOverflow.ellipsis,),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          var title = allNotes[index].title;
                          var desc = allNotes[index].desc;
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AddNotePage(isUpdate: true, id: allNotes[index].id!, title: title, desc: desc,),));

                        },
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () async {
                          context.read<DbBloc>().add(DeleteNote(id: allNotes[index].id!));
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
          }

          if(state is DBErrorState){
            return Center(
              child: Text(state.error, style: TextStyle(fontSize: 21),),
            );
          }

          return Container();

      },),
      floatingActionButton: FloatingActionButton(
              onPressed: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddNotePage(),));
              },
              child: Icon(Icons.add),
            ),
    );
  }

}
