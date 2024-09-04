import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data_layer/models/folder.dart';
import '../../data_layer/models/note.dart';
import '../bloc/folder_bloc.dart';
import '../bloc/folder_event.dart';
import '../bloc/folder_state.dart';
import 'note_details_screen.dart';

class FolderDetailScreen extends StatelessWidget {
  final Folder folder;

  const FolderDetailScreen({super.key, required this.folder});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: const Color(0x35877741),
        ),
        Positioned.fill(
          child: Opacity(
            opacity: 0.5, // Adjust opacity as needed
            child: Image.asset(
              'assets/images/img_1.png', // Replace with your image asset path
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            foregroundColor: Colors.white,
            backgroundColor: Colors.transparent, // Make app bar background transparent
            title: BlocBuilder<FolderBloc, FolderState>(
              builder: (context, state) {
                if (state is FolderLoaded) {
                  final currentFolder = state.folders.firstWhere(
                        (f) => f.id == folder.id,
                    orElse: () => folder,
                  );
                  return Text(currentFolder.name, style: const TextStyle(color: Colors.white)); // Update title to current folder name
                }
                return Text(folder.name);
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white), // Edit icon to rename folder
                onPressed: () => _showEditFolderNameDialog(context),
              ),
            ],
          ),
          body: BlocBuilder<FolderBloc, FolderState>(
            builder: (context, state) {
              if (state is FolderLoaded) {
                final currentFolder = state.folders.firstWhere(
                      (f) => f.id == folder.id,
                  orElse: () => folder,
                );

                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: currentFolder.notes.length,
                  itemBuilder: (context, index) {
                    final note = currentFolder.notes[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: ListTile(
                        title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          note.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis, // Limit description to one line
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            context.read<FolderBloc>().add(DeleteNoteFromFolder(folder.id, index));
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NoteDetailScreen(
                                folder: folder,
                                noteIndex: index,
                                note: note,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              } else {
                return const Center(child: Text('No notes available.'));
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddNoteDialog(context),
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  void _showAddNoteDialog(BuildContext context) {
    String? title;
    String? description;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add New Note'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Note Title'),
                    onChanged: (value) {
                      title = value;
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Note Description'),
                    onChanged: (value) {
                      description = value;
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (title != null && title!.isNotEmpty && description != null && description!.isNotEmpty) {
                      final newNote = Note(
                        title: title!,
                        description: description!,
                      );
                      context.read<FolderBloc>().add(AddNoteToFolder(folder.id, newNote));
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditFolderNameDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController(text: folder.name); // Pre-fill with current name

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Folder Name'),
              content: TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'New Folder Name'),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty) {
                      final updatedFolder = Folder(
                        id: folder.id,
                        name: nameController.text, // Updated name
                        color: folder.color,
                        notes: folder.notes,
                      );
                      context.read<FolderBloc>().add(UpdateFolder(updatedFolder));
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
