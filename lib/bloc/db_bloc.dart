import 'package:database_sqflite/bloc/db_events.dart';
import 'package:database_sqflite/bloc/db_state.dart';
import 'package:database_sqflite/database/db_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DbBloc extends Bloc<DBEvents, DBState>{
  DBHelper dbHelper;
  DbBloc({required this.dbHelper}) : super(DBInitialState()){

    on<AddNote>((event, emit) async{
      emit(DBLoadingState());
      bool check = await dbHelper.addNote(
          title: event.title,
          desc: event.desc,
          createdAt: event.createdAt
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
          updatedTitle: event.title,
          updatedDesc: event.desc,
          updatedAt: event.updatedAt,
          id: event.id
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