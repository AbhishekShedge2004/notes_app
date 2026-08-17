import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper{

  //singleton class
  //1. creating a private constructor
  DBHelper._();

  static final DBHelper _instance = DBHelper._();

  //2. globally distribute
  static DBHelper getInstance() => _instance;

  Database? mDB;

  static final String TABLE_NOTE_NAME = "note";
  static final String COLUMN_NOTE_ID = "note_id";
  static final String COLUMN_NOTE_TITLE = "note_title";
  static final String COLUMN_NOTE_DESC = "note_desc";
  static final String COLUMN_NOTE_CREATE_AT = "note_create_at";

  Future<Database> getDB() async{
    if(mDB != null){
      return mDB!;
    }else{
      mDB = await  openDB();
      return mDB!;
    }
  }

  Future<Database> openDB() async{

    var appDir = await getApplicationDocumentsDirectory();
    var dbPath = join(appDir.path, "notes.db");

    return openDatabase(dbPath, version: 1, onCreate: (db, version) {
      db.execute("create table $TABLE_NOTE_NAME ( $COLUMN_NOTE_ID integer primary key autoincrement, $COLUMN_NOTE_TITLE text, $COLUMN_NOTE_DESC text, $COLUMN_NOTE_CREATE_AT text)");
    },);

  }

  Future<bool> addNote({required String title, required String desc, required String createdAt}) async{
    Database db = await getDB();
    int rowsEffected = await db.insert(TABLE_NOTE_NAME, {
      COLUMN_NOTE_TITLE : title,
      COLUMN_NOTE_DESC : desc,
      COLUMN_NOTE_CREATE_AT : createdAt
    });
    return rowsEffected>0;
  }


  Future<List<Map<String, dynamic>>> getAllNotes() async{
    Database db = await getDB();

    List<Map<String, dynamic>> mData = await db.query(TABLE_NOTE_NAME, );

    return mData;
  }

  Future<bool> updateNote({required String updatedTitle, required String updatedDesc,required String updatedAt, required int id}) async{
    Database db = await getDB();
    int rowsEffected = await db.update(TABLE_NOTE_NAME, {
      COLUMN_NOTE_TITLE : updatedTitle,
      COLUMN_NOTE_DESC : updatedDesc,
      COLUMN_NOTE_CREATE_AT : updatedAt
    }, where: "$COLUMN_NOTE_ID = $id");
    return rowsEffected > 0 ;
  }

  Future<bool> deleteNote({required int id}) async{
    Database db = await getDB();
    int rowsEffected = await db.delete(TABLE_NOTE_NAME, where: "$COLUMN_NOTE_ID = ?", whereArgs: [id]);
    return rowsEffected > 0;
  }





}

