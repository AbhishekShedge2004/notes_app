import 'package:database_sqflite/database/db_helper.dart';
import 'package:database_sqflite/model/note_model.dart';
import 'package:flutter/material.dart';

class DBProvider extends ChangeNotifier{

  DBHelper dbHelper;
  DBProvider({required this.dbHelper});


  //data
  List<NoteModel> _mData = [];

  //insert
  void addNote({required NoteModel newNote}) async{
    bool check = await dbHelper.addNote(
       newNote: NoteModel(
           title: newNote.title,
           desc: newNote.desc,
           createdAt: newNote.createdAt
       )
    );
    if(check){
      _mData = await dbHelper.getAllNotes();
      notifyListeners();
    }
  }

  List<NoteModel> getAllNotes() => _mData;

  //fetch initial notes
  void getInitialNotes() async{
    _mData = await dbHelper.getAllNotes();
    notifyListeners();
  }

  void updateNote({required NoteModel updateNote}) async{
    bool check = await dbHelper.updateNote(
        updateNote: NoteModel(
            title: updateNote.title,
            desc: updateNote.desc,
            createdAt: updateNote.createdAt,
            id: updateNote.id
        )
    );
    if(check){
      _mData = await dbHelper.getAllNotes();
      notifyListeners();
    }
  }

  void deleteNote({required int mId}) async{
    bool check = await dbHelper.deleteNote(id: mId);
    if(check){
      _mData = await dbHelper.getAllNotes();
      notifyListeners();
    }
  }




}