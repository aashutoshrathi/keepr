import 'package:flutter/material.dart';
import 'package:keepr/models/note.dart';
import 'package:keepr/screens/note_details.dart';
import 'package:keepr/utils/db_helper.dart';

class NoteList extends StatefulWidget {
  @override
    State<StatefulWidget> createState() {
      return NoteListState();
    }
}

class NoteListState extends State<NoteList> {
  DatabaseHelper dbHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;

  @override
    Widget build(BuildContext context) {
      if (noteList == null) {
        noteList = List<Note>();
      }

      return Scaffold(
        appBar: AppBar(
          title: Text('Keeper'),
        ),
        body: getNoteListView(),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            navigateToDetail('Add Note');
          },
          tooltip: 'Add Note',
          child: Icon(Icons.add),
          backgroundColor: Colors.black,
        ),
      );
    }

    ListView getNoteListView() {

      TextStyle titleStyle = Theme.of(context).textTheme.subhead;

      return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: Colors.black,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: getPriorityRang(this.noteList[position].priority),
                child: Icon(Icons.alarm_on),
              ),
              title: Text(this.noteList[position].title, style: titleStyle),
              subtitle: Text(this.noteList[position].description),
              trailing: GestureDetector (
                child: Icon(Icons.delete_sweep, color: Colors.red),
                onTap: () {
                  _delete(context, noteList[position]);
                },
              ),
              onTap: () {
                debugPrint("Edit Check");
              },
            ),
          );
        },
      );
    }

    void _delete(BuildContext context, Note note) async {
      int res = await dbHelper.deleteNote(note);
      if (res != 0) {
        _showSnackBar(context, 'Note Deleted!');
      }
    }

    void _showSnackBar(BuildContext context, String msg) {
      final snackBar = SnackBar(content: Text(msg));
      Scaffold.of(context).showSnackBar(snackBar);
    }

    Color getPriorityRang(int priority) {
      if (priority == 1) {
        return Colors.red;
      }
      return Colors.yellow;
    }

    void navigateToDetail(String title) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return NoteDetail(title);
      }));
    }
}