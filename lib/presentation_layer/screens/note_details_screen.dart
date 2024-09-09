import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../../data_layer/models/folder.dart';
import '../../data_layer/models/note.dart';
import '../bloc/folder_bloc/folder_bloc.dart';
import '../bloc/folder_bloc/folder_event.dart';

class NoteDetailScreen extends StatefulWidget {
  final Folder folder;
  final int noteIndex;
  final Note note;

  const NoteDetailScreen({super.key, required this.folder, required this.noteIndex, required this.note});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  TextEditingController titleController = TextEditingController();
  QuillController _controller = QuillController.basic();
  double _toolbarHeightPercentage = 0.1; // Start with a percentage for toolbar height

  @override
  void initState() {
    super.initState();
    titleController.text = widget.note.title;

    // Set QuillController with the description from the note
    final doc = Document()..insert(0, widget.note.description);
    _controller = QuillController(
      document: doc,
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;  // Use MediaQuery to get screen height
    final double toolbarHeight = screenHeight * _toolbarHeightPercentage;  // Calculate toolbar height as percentage

    return Stack(
      children: [
        Container(
          color: const Color(0x35877741),
        ),
        Positioned.fill(
          child: Opacity(
            opacity: 0.5,
            child: Image.asset(
              'assets/images/img_1.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              title: Text(widget.note.title, style: const TextStyle(color: Colors.white)),
              actions: [
                IconButton(
                  icon: const Icon(Icons.save, color: Colors.white),
                  onPressed: () {
                    final description = _controller.document.toPlainText();
                    final updatedNote = Note(
                      title: titleController.text,
                      description: description,
                    );
                    context.read<FolderBloc>().add(UpdateNoteInFolder(widget.folder.id, widget.noteIndex, updatedNote));
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Note Title',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Note Description',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 16),

                    // GestureDetector to toggle toolbar height
                    GestureDetector(
                      onTap: () {
                        // Toggle between smaller and larger toolbar heights by changing the percentage
                        setState(() {
                          _toolbarHeightPercentage = _toolbarHeightPercentage == 0.1 ? 0.5 : 0.1;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300), // Smooth animation for height change
                        height: toolbarHeight, // Use calculated toolbar height
                        width: double.infinity,
                        color: Colors.white,
                        child: QuillSimpleToolbar(
                          controller: _controller,
                          configurations: const QuillSimpleToolbarConfigurations(),
                        ),
                      ),
                    ),

                    // Divider
                    Container(
                      width: double.infinity,
                      height: 2,
                      color: Colors.black12,
                    ),

                    // Quill Editor
                    Container(
                      color: Colors.white,
                      height: screenHeight * 0.68, // Set remaining height for the editor dynamically
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: QuillEditor.basic(
                          controller: _controller,
                          configurations: const QuillEditorConfigurations(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
