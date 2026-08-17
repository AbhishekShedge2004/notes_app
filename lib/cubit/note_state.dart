abstract class NoteState{}

class InitialState extends NoteState{}

class LoadingState extends NoteState{}

class LoadedState extends NoteState{
  List<Map<String,dynamic>> mData;
  LoadedState({required this.mData});
}

class ErrorState extends NoteState{
  String error;
  ErrorState({required this.error});
}