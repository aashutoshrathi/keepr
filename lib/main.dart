
import 'package:flutter/material.dart';
import 'package:keepr/screens/note_list.dart';

void main() {
  runApp(
    NotesApp()
  );
}

class NotesApp extends StatelessWidget {
  @override
    Widget build(BuildContext context) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Keeper',
        theme: ThemeData(
          primaryColor: Colors.black
        ),
        home: NoteList()
      );
    }
}