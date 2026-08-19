import 'package:database_sqflite/model/note_model.dart';

abstract class NoteState{}

class InitialState extends NoteState{}

class LoadingState extends NoteState{}

class LoadedState extends NoteState{
  List<NoteModel> mData;
  LoadedState({required this.mData});
}

class ErrorState extends NoteState{
  String error;
  ErrorState({required this.error});
}