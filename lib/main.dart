
import 'package:flutter/material.dart';
import 'package:flutter_keeper/screens/note_details.dart';
import 'package:flutter_keeper/screens/note_list.dart';

void main() {
  runApp(
    MyApp()
  );
}

class MyApp extends StatelessWidget {
  @override
    Widget build(BuildContext context) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Keeper',
        theme: ThemeData(
          primaryColor: Colors.black
        ),
        home: NoteDetail()
      );
    }
}