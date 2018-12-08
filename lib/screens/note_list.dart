import 'package:flutter/material.dart';
import 'package:flutter_keeper/screens/note_details.dart';

class NoteList extends StatefulWidget {
  @override
    State<StatefulWidget> createState() {
      return NoteListState();
    }
}

class NoteListState extends State<NoteList> {
  int count = 0;
  @override
    Widget build(BuildContext context) {

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
              leading: Icon(Icons.alarm_on),
              title: Text('Title', style: titleStyle),
              subtitle: Text('Reason'),
              trailing: Icon(Icons.delete_sweep),
              onTap: () {
                navigateToDetail('Edit Note');
              },
            ),
          );
        },
      );
    }

    void navigateToDetail(String title) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return NoteDetail(title);
      }));
    }
}