import 'package:database_sqflite/bloc/db_events.dart';
import 'package:database_sqflite/bloc/db_state.dart';
import 'package:database_sqflite/database/db_helper.dart';
import 'package:database_sqflite/model/note_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DbBloc extends Bloc<DBEvents, DBState>{
  DBHelper dbHelper;
  DbBloc({required this.dbHelper}) : super(DBInitialState()){

    on<AddNote>((event, emit) async{
      emit(DBLoadingState());
      bool check = await dbHelper.addNote(
         newNote: NoteModel(
             title: event.newNote.title,
             desc: event.newNote.desc,
             createdAt: event.newNote.createdAt
         )
      );
      if(check){
        var data = await dbHelper.getAllNotes();
        emit(DBLoadedState(mData: data));
      }else{
        emit(DBErrorState(error: "Note not add"));
      }
      },
    );

    on<UpdateNote>((event, emit) async{
      emit(DBLoadingState());
      bool check = await dbHelper.updateNote(
          updateNote: NoteModel(
              title: event.updateNote.title,
              desc: event.updateNote.desc,
              createdAt: event.updateNote.createdAt,
              id: event.updateNote.id
          )
      );
      if(check){
        var data = await dbHelper.getAllNotes();
        emit(DBLoadedState(mData: data));
      }else{
        emit(DBErrorState(error: "Note not update"));
      }
    },);

    on<DeleteNote>((event, emit) async{
      emit(DBLoadingState());
      bool check = await dbHelper.deleteNote(id: event.id);
      if(check){
        var data = await dbHelper.getAllNotes();
        emit(DBLoadedState(mData: data));
      }else{
        emit(DBErrorState(error: "Note not delete"));
      }
    },);

    on<GetInitialNotes>((event, emit) async{
      emit(DBLoadingState());
      var data = await dbHelper.getAllNotes();
      emit(DBLoadedState(mData: data));
    },);


  }
}