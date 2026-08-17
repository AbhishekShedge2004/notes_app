import 'package:database_sqflite/database/db_helper.dart';

class NoteModel{
  int? id;
  String title;
  String desc;
  String createdAt;
  NoteModel({
    this.id,
    required this.title,
    required this.desc,
    required this.createdAt
  });

  factory NoteModel.fromMap(Map<String,dynamic> map){
    return NoteModel(
        id: map[DBHelper.COLUMN_NOTE_ID],
        title: map[DBHelper.COLUMN_NOTE_TITLE],
        desc: map[DBHelper.COLUMN_NOTE_DESC],
        createdAt: map[DBHelper.COLUMN_NOTE_CREATE_AT]
    );
  }

  Map<String,dynamic> toMap(){
    return {
      DBHelper.COLUMN_NOTE_TITLE : title,
      DBHelper.COLUMN_NOTE_DESC : desc,
      DBHelper.COLUMN_NOTE_CREATE_AT : createdAt
    };
  }


}