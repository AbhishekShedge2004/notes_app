import 'dart:async';

import 'package:database_sqflite/cubit/note_state.dart';
import 'package:database_sqflite/database/db_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NoteCubit extends Cubit<NoteState>{
  
  DBHelper dbHelper;

  NoteCubit({required this.dbHelper}) : super(InitialState());

  void addNote({required String mTitle, required String mDesc, required String mCreatedAt}) async{
    emit(LoadingState());
    bool check = await dbHelper.addNote(title: mTitle, desc: mDesc, createdAt: mCreatedAt);
    if(check){
      List<Map<String,dynamic>> data = await dbHelper.getAllNotes();
      emit(LoadedState(mData: data));
    }else{
      emit(ErrorState(error: "note not add"));
    }
  }

  void updateNote({required int mId, required String mTitle, required String mDesc, required String mUpdatedAt}) async{
    emit(LoadingState());
    bool check = await dbHelper.updateNote(updatedTitle: mTitle, updatedDesc: mDesc, updatedAt: mUpdatedAt, id: mId);
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