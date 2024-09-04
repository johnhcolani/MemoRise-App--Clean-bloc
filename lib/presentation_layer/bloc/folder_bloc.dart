// lib/folder_bloc.dart
import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../../data_layer/models/folder.dart';
import '../../data_layer/models/note.dart';
import 'folder_event.dart';
import 'folder_state.dart';


class FolderBloc extends HydratedBloc<FolderEvent, FolderState> {
  FolderBloc() : super(FolderLoaded([])) {
    // Event handler for loading folders
    on<LoadFolders>((event, emit) {
      emit(FolderLoaded((state as FolderLoaded).folders));
    });

    // Event handler for adding a folder
    on<AddFolder>((event, emit) {
      if (state is FolderLoaded) {
        final updatedFolders = List<Folder>.from((state as FolderLoaded).folders)
          ..add(event.folder);
        emit(FolderLoaded(updatedFolders)); // Emit updated state
      }
    });

    // Event handler for deleting a folder
    on<DeleteFolder>((event, emit) {
      if (state is FolderLoaded) {
        final updatedFolders = List<Folder>.from((state as FolderLoaded).folders)
          ..removeWhere((folder) => folder.id == event.folder.id);
        emit(FolderLoaded(updatedFolders)); // Emit updated state
      }
    });

    // Event handler for adding a note to a folder
    on<AddNoteToFolder>((event, emit) {
      if (state is FolderLoaded) {
        final folders = (state as FolderLoaded).folders;
        final folderIndex = folders.indexWhere((folder) => folder.id == event.folderId);

        if (folderIndex != -1) {
          final updatedNotes = List<Note>.from(folders[folderIndex].notes)
            ..add(event.note);
          final updatedFolder = Folder(
            id: folders[folderIndex].id,
            name: folders[folderIndex].name,
            color: folders[folderIndex].color,
            notes: updatedNotes,
          );

          final updatedFolders = List<Folder>.from(folders)
            ..[folderIndex] = updatedFolder;
          emit(FolderLoaded(updatedFolders)); // Emit updated state
        }
      }
    });

    // Event handler for updating a note in a folder
    on<UpdateNoteInFolder>((event, emit) {
      if (state is FolderLoaded) {
        final folders = (state as FolderLoaded).folders;
        final folderIndex = folders.indexWhere((folder) => folder.id == event.folderId);

        if (folderIndex != -1) {
          final updatedNotes = List<Note>.from(folders[folderIndex].notes);
          updatedNotes[event.noteIndex] = event.updatedNote;

          final updatedFolder = Folder(
            id: folders[folderIndex].id,
            name: folders[folderIndex].name,
            color: folders[folderIndex].color,
            notes: updatedNotes,
          );

          final updatedFolders = List<Folder>.from(folders)
            ..[folderIndex] = updatedFolder;
          emit(FolderLoaded(updatedFolders)); // Emit updated state
        }
      }
    });

    // Event handler for deleting a note from a folder
    on<DeleteNoteFromFolder>((event, emit) {
      if (state is FolderLoaded) {
        final folders = (state as FolderLoaded).folders;
        final folderIndex = folders.indexWhere((folder) => folder.id == event.folderId);

        if (folderIndex != -1) {
          final updatedNotes = List<Note>.from(folders[folderIndex].notes)
            ..removeAt(event.noteIndex);

          final updatedFolder = Folder(
            id: folders[folderIndex].id,
            name: folders[folderIndex].name,
            color: folders[folderIndex].color,
            notes: updatedNotes,
          );

          final updatedFolders = List<Folder>.from(folders)
            ..[folderIndex] = updatedFolder;
          emit(FolderLoaded(updatedFolders)); // Emit updated state
        }
      }
    });

    // Event handler for updating a folder's name
    on<UpdateFolder>((event, emit) {
      if (state is FolderLoaded) {
        final updatedFolders = List<Folder>.from((state as FolderLoaded).folders);
        final folderIndex = updatedFolders.indexWhere((folder) => folder.id == event.updatedFolder.id);

        if (folderIndex != -1) {
          updatedFolders[folderIndex] = event.updatedFolder;
          emit(FolderLoaded(updatedFolders)); // Emit updated state
        }
      }
    });
  }

  @override
  FolderState? fromJson(Map<String, dynamic> json) {
    try {
      final folders = (json['folders'] as List).map((e) => Folder.fromJson(e)).toList();
      return FolderLoaded(folders);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(FolderState state) {
    if (state is FolderLoaded) {
      return {'folders': state.folders.map((folder) => folder.toJson()).toList()};
    }
    return null;
  }
}
