// lib/note_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data_layer/models/folder.dart';
import '../../data_layer/models/note.dart';
import '../bloc/folder_bloc.dart';
import '../bloc/folder_event.dart';

class NoteDetailScreen extends StatelessWidget {
  final Folder folder;
  final int noteIndex;
  final Note note;

  NoteDetailScreen({required this.folder, required this.noteIndex, required this.note});

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController(text: note.title);
    TextEditingController descriptionController = TextEditingController(text: note.description);

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
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            title: Text(note.title,style: const TextStyle(color: Colors.white),), // Use note.title directly for the AppBar title
            actions: [
              IconButton(
                icon: const Icon(Icons.save,color: Colors.white,),
                onPressed: () {
                  final updatedNote = Note(
                    title: titleController.text,
                    description: descriptionController.text,
                  );
                  context.read<FolderBloc>().add(UpdateNoteInFolder(folder.id, noteIndex, updatedNote));
                  Navigator.pop(context); // Navigate back after saving
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Note Title',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white, // Set white background
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded corners
                      borderSide: BorderSide(color: Colors.grey), // Border color
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey), // Border color for enabled state
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.blue, width: 2.0), // Border color for focused state
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Note Description',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 8),
                Expanded(
                  child: TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white, // Set white background
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10), // Rounded corners
                        borderSide: BorderSide(color: Colors.grey), // Border color
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey), // Border color for enabled state
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue, width: 2.0), // Border color for focused state
                      ),
                    ),
                    maxLines: null, // Allow it to be multiline
                    expands: true, // Allow the TextField to expand
                    keyboardType: TextInputType.multiline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
