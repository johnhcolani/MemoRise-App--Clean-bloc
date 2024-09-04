// lib/folder.dart
import 'package:flutter/material.dart';
import 'note.dart';


class Folder {
  final String id;
  final String name;
  final Color color;
  final List<Note> notes;

  Folder({
    required this.id,
    required this.name,
    required this.color,
    this.notes = const [],
  });

  factory Folder.fromJson(Map<String, dynamic> json) {
    return Folder(
      id: json['id'],
      name: json['name'],
      color: Color(json['color']),
      notes: (json['notes'] as List<dynamic>).map((e) => Note.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color.value,
      'notes': notes.map((note) => note.toJson()).toList(),
    };
  }
}
