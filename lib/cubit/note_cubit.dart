import 'dart:async';

import 'package:database_sqflite/cubit/note_state.dart';
import 'package:database_sqflite/database/db_helper.dart';
import 'package:database_sqflite/model/note_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NoteCubit extends Cubit<NoteState>{
  
  DBHelper dbHelper;

  NoteCubit({required this.dbHelper}) : super(InitialState());

  void addNote({required NoteModel newNote}) async{
    emit(LoadingState());
    bool check = await dbHelper.addNote(
      newNote: NoteModel(
          title: newNote.title,
          desc: newNote.desc,
          createdAt: newNote.createdAt
      )
    );
    if(check){
      List<NoteModel> data = await dbHelper.getAllNotes();
      emit(LoadedState(mData: data));
    }else{
      emit(ErrorState(error: "note not add"));
    }
  }

  void updateNote({required NoteModel updateNote}) async{
    emit(LoadingState());
    bool check = await dbHelper.updateNote(
      updateNote: NoteModel(
          title: updateNote.title,
          desc: updateNote.desc,
          createdAt: updateNote.createdAt,
          id: updateNote.id
      )
    );
    if(check){
      var data = await dbHelper.getAllNotes();
      emit(LoadedState(mData: data));
    }else{
      emit(ErrorState(error: "Note not Update"));
    }
  }

  void getInitialNotes() async{
    emit(LoadingState());
    await Future.delayed(Duration(seconds: 1)); //learning purpose only
    var data = await dbHelper.getAllNotes();
    emit(LoadedState(mData: data));
  }

  void deleteNote({required int mId}) async{
    emit(LoadingState());
    bool check = await dbHelper.deleteNote(id: mId);
    if(check){
      var data = await dbHelper.getAllNotes();
      emit(LoadedState(mData: data));
    }else{
      emit(ErrorState(error: "note not delete"));
    }
  }


}