import 'package:database_sqflite/model/note_model.dart';

abstract class DBEvents{}

class AddNote extends DBEvents{
  NoteModel newNote;
  AddNote({required this.newNote});
}

class UpdateNote extends DBEvents{
  NoteModel updateNote;
  UpdateNote({required this.updateNote});
}

class DeleteNote extends DBEvents{
  int id;
  DeleteNote({required this.id});
}

class GetInitialNotes extends DBEvents{}