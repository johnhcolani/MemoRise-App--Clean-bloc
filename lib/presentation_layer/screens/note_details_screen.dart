import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../../data_layer/models/folder.dart';
import '../../data_layer/models/note.dart';
import '../bloc/folder_bloc.dart';
import '../bloc/folder_event.dart';

class NoteDetailScreen extends StatefulWidget {
  final Folder folder;
  final int noteIndex;
  final Note note;

  NoteDetailScreen({required this.folder, required this.noteIndex, required this.note});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  QuillController _controller = QuillController.basic();
  bool _isBold = false;
  bool _isItalic = false;
  double _fontSize = 16.0;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.note.title;
    // descriptionController.text = widget.note.description;
    final doc = Document()..insert(0, widget.note.description);
    _controller=QuillController(document: doc, selection: TextSelection.collapsed(offset: 0));
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
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
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            title: Text(widget.note.title, style: const TextStyle(color: Colors.white)),
            actions: [
              IconButton(
                icon: const Icon(Icons.save, color: Colors.white),
                onPressed: () {
                  final description =_controller.document.toPlainText();
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
                    style: _getTextStyle(), // Apply text style
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

                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: QuillSimpleToolbar(
                      controller: _controller,
                      configurations: const QuillSimpleToolbarConfigurations(),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 2,
                    color: Colors.black12,
                  ),
                  Container(
                    color: Colors.white,
                    height: height * 0.68,
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

      ],
    );
  }

  // Method to dynamically apply bold, italic, and font size
  TextStyle _getTextStyle() {
    return TextStyle(
      fontSize: _fontSize,
      fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
      fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
    );
  }

  // Widget for custom toolbar with Bold, Italic, and Font Size controls
  Widget _buildTextEditorToolbar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(
            Icons.format_bold,
            color: _isBold ? Colors.blue : Colors.white,
          ),
          onPressed: () {
            setState(() {
              _isBold = !_isBold;
            });
          },
        ),
        IconButton(
          icon: Icon(
            Icons.format_italic,
            color: _isItalic ? Colors.blue : Colors.white,
          ),
          onPressed: () {
            setState(() {
              _isItalic = !_isItalic;
            });
          },
        ),
        DropdownButton<double>(
          value: _fontSize,
          items: <double>[14, 16, 18, 20, 24].map((double size) {
            return DropdownMenuItem<double>(
              value: size,
              child: Text(
                size.toString(),
                style: TextStyle(fontSize: size, color: Colors.grey),
              ),
            );
          }).toList(),
          onChanged: (double? newSize) {
            setState(() {
              _fontSize = newSize ?? 16.0;
            });
          },
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
