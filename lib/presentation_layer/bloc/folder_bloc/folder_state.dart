// lib/folder_state.dart
import '../../../data_layer/models/folder.dart';


abstract class FolderState {}

class FolderInitial extends FolderState {}

class FolderLoading extends FolderState {}

class FolderLoaded extends FolderState {
  final List<Folder> folders;

  FolderLoaded(this.folders);
}
class FolderNoteSaved extends FolderState {
  final String message;
  FolderNoteSaved(this.message);
}

class FolderNotePrinted extends FolderState {
  final String message;
  FolderNotePrinted(this.message);
}
class FolderError extends FolderState {
  final String message;

  FolderError(this.message);
}
