// lib/folder_event.dart
import '../../../data_layer/models/folder.dart';
import '../../../data_layer/models/note.dart';


abstract class FolderEvent {}

class LoadFolders extends FolderEvent {}

class AddFolder extends FolderEvent {
  final Folder folder;

  AddFolder(this.folder);
}

class DeleteFolder extends FolderEvent {
  final Folder folder;

  DeleteFolder(this.folder);
}

class AddNoteToFolder extends FolderEvent {
  final String folderId;
  final Note note;

  AddNoteToFolder(this.folderId, this.note);
}

class UpdateNoteInFolder extends FolderEvent {
  final String folderId;
  final int noteIndex;
  final Note updatedNote;

  UpdateNoteInFolder(this.folderId, this.noteIndex, this.updatedNote);
}

class DeleteNoteFromFolder extends FolderEvent {
  final String folderId;
  final int noteIndex;

  DeleteNoteFromFolder(this.folderId, this.noteIndex);
}

class UpdateFolder extends FolderEvent {
  final Folder updatedFolder;

  UpdateFolder(this.updatedFolder);
}
class SaveNoteAsTextFile extends FolderEvent {
  final Note note;
  final String fileName;

  SaveNoteAsTextFile(this.note, this.fileName);
}

class SaveNoteAsPdf extends FolderEvent {
  final Note note;
  final String fileName;

  SaveNoteAsPdf(this.note, this.fileName);
}

class SaveNoteAsWord extends FolderEvent {
  final Note note;
  final String fileName;

  SaveNoteAsWord(this.note, this.fileName);
}

class PrintNote extends FolderEvent {
  final Note note;

  PrintNote(this.note);
}