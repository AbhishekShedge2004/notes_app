abstract class DBEvents{}

class AddNote extends DBEvents{
  String title;
  String desc;
  String createdAt;
  AddNote({required this.title, required this.desc, required this.createdAt});
}

class UpdateNote extends DBEvents{
  int id;
  String title;
  String desc;
  String updatedAt;
  UpdateNote({required this.id, required this.title, required this.desc, required this.updatedAt});
}

class DeleteNote extends DBEvents{
  int id;
  DeleteNote({required this.id});
}

class GetInitialNotes extends DBEvents{}