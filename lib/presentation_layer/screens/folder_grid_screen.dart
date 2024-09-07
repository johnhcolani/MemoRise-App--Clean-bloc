import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data_layer/models/folder.dart';
import '../bloc/folder_bloc.dart';
import '../bloc/folder_event.dart';
import '../bloc/folder_state.dart';
import 'folder_details_screen.dart';

class FolderGridScreen extends StatefulWidget {
  const FolderGridScreen({super.key});

  @override
  _FolderGridScreenState createState() => _FolderGridScreenState();
}

class _FolderGridScreenState extends State<FolderGridScreen> {
  Color selectedColor = Color(0x99dc718c);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(
          color: Colors.white.withOpacity(0.5),
        ),
        Positioned.fill(
          child: Opacity(
            opacity: 0.8,
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
            title:  Text(
              'MemoRise',
              style: TextStyle(
                  color: Colors.white,
              fontSize: width >500 ? 38 : 22
              ),
            ),
          ),
          body: BlocBuilder<FolderBloc, FolderState>(
            builder: (context, state) {
              if (state is FolderLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is FolderLoaded) {
                return GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: width >500 ? 3 : 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: state.folders.length,
                  itemBuilder: (context, index) {
                    final folder = state.folders[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                FolderDetailScreen(folder: folder),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.white),
                              color: folder.color.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        folder.name,
                                        style:  TextStyle(
                                          color: Colors.white,
                                          fontSize: width >500 ? 32 :14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    IconButton(
                                      icon:  Icon(Icons.delete,
                                          size: width >500 ? 38 :14,
                                          color: Colors.white),
                                      onPressed: () {
                                        _confirmDeleteFolder(context, folder);
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Expanded(
                                  child: Row(
                                    children: [

                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                  
                                            borderRadius: BorderRadius.circular(16),
                                            border: Border.all(width: 1,color: Colors.white)
                                          ),
                                  
                                          child: ListView.builder(
                                            itemCount: folder.notes.length,
                                            itemBuilder: (context, noteIndex) {
                                              final note = folder.notes[noteIndex];
                                              return Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  note.title,
                                                  style:  TextStyle(
                                                      color: Colors.white,
                                                      fontSize: width >500 ? 28 :14,),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      Icon(Icons.add,color: Colors.white,size: 48,),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else if (state is FolderError) {
                return Center(child: Text(state.message));
              } else {
                return const Center(child: Text('No folders available.'));
              }
            },
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Text(
                  'Click on ✚ to add your Note',
                  style: TextStyle(
                      fontSize:  width >500 ?32 : 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 16,),
                Container(
                  width: 56.0,
                  height: 56.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: Colors.white, // Set your desired border color
                      width: 1.0, // Set the width of the border
                    ),
                  ),
                  child: FloatingActionButton(
                    backgroundColor:
                        selectedColor, // Use the selected color here
                    onPressed: () {
                      _showAddFolderDialog(context);
                    },
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _confirmDeleteFolder(BuildContext context, Folder folder) {
    if (folder.notes.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Cannot Delete Folder'),
            content: const Text(
                'The folder is not empty. Please delete all notes first.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      context.read<FolderBloc>().add(DeleteFolder(folder));
    }
  }

  void _showAddFolderDialog(BuildContext context) {
    String? name;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add New Folder'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Folder Name'),
                    onChanged: (value) {
                      name = value;
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text('Folder Color',style: TextStyle(color: selectedColor),),
                      const Divider(indent: 16,),
                      DropdownButton<Color>(
                        value: selectedColor,
                        items: <Color>[
                          Colors.blue.withOpacity(0.5),
                          Colors.red.withOpacity(0.5),
                          Colors.green.withOpacity(0.5),
                          Colors.orange.withOpacity(0.5),
                        ].map((Color color) {
                          return DropdownMenuItem<Color>(
                            value: color,
                            child: Container(
                              width: 100,
                              height: 24,
                              color: color,
                            ),
                          );
                        }).toList(),
                        onChanged: (Color? newColor) {
                          if (newColor != null) {
                            setState(() {
                              selectedColor = newColor;
                            });
                          }
                        },
                      ),
                    ],
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
                    if (name != null && name!.isNotEmpty) {
                      final newFolder = Folder(
                        id: DateTime.now().toString(),
                        name: name!,
                        color: selectedColor,
                        notes: [],
                      );
                      context.read<FolderBloc>().add(AddFolder(newFolder));
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
}

