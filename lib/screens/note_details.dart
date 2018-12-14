import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keepr/models/note.dart';
import 'package:keepr/utils/db_helper.dart';

class NoteDetail extends StatefulWidget {

  final String appBarTitle;
  final Note note;

  NoteDetail(this.note, this.appBarTitle);

  @override
    State<StatefulWidget> createState() {
      return NoteDetailState(this.note, this.appBarTitle);
    }
}

class NoteDetailState extends State<NoteDetail> {
  var _formKey = GlobalKey<FormState>();
  DatabaseHelper dbHelper = DatabaseHelper();
  static var _priorities = ['High', 'Low'];

  String appBarTitle;
  Note note;

  TextEditingController titleContr = TextEditingController();
  TextEditingController descContr = TextEditingController();

  NoteDetailState(this.note, this.appBarTitle);

  @override
    Widget build(BuildContext context) {

      TextStyle textStyle = Theme.of(context).textTheme.title;

      titleContr.text = note.title;
      descContr.text = note.description;

      return WillPopScope (
        // this thing WillPopScope Checks what to do if user press back button from navigation bar.
        onWillPop: () {
          goBack();
        },

        child: Scaffold (
        appBar: AppBar(
          title: Text(appBarTitle),
          // Ab jo me likhuga wo automatic hota hai, but me to hu hi neta.
          leading: IconButton(icon: Icon(
            Icons.arrow_back),
            onPressed: () {
              goBack();
            },
          ),
        ),

        body: Form(
          key: _formKey,
          child: Padding(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: ListView(
            children: <Widget>[
              ListTile (
                title: DropdownButton(
                  items: _priorities.map((String dropDownString) {
                    return DropdownMenuItem<String> (
                      value: dropDownString,
                      child: Text(dropDownString),
                    );
                  }).toList(),

                  style: textStyle,
                  value: priorityAsString(note.priority),
                  
                  onChanged: (valueSelected) {
                    setState(() {
                      debugPrint('User selected $valueSelected');
                      updatePriorityAsInt(valueSelected);
                    });
                  }
                ),
              ),

              Padding (
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextFormField(
                  controller: titleContr,
                  style: textStyle,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter a title';
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: textStyle,
                    hintText: 'Add a title for the Task',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)
                    )
                  ),
                )
              ),

              Padding (
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: descContr,
                  style: textStyle,
                  onChanged: (value) {
                    debugPrint('Something in Description Field');
                    note.description = descContr.text;
                  },
                  decoration: InputDecoration(
                    labelText: 'Description',
                    hintText: 'Describe your task',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)
                    )
                  ),
                )
              ),
              
              Padding (
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Row (
                  children: <Widget>[
                    Container(width: 15.0),
                    Expanded(
                      child: OutlineButton(
                        color: Colors.lightGreenAccent,
                        textColor: Colors.green,
                        borderSide: BorderSide(color: Colors.green),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0)
                        ),
                        child: Text (
                          'Save',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          setState(() {
                            if (_formKey.currentState.validate()) {
                              note.title = titleContr.text;
                              note.description = descContr.text;
                              _save();
                            }
                          });
                        },
                      ),
                    ),

                    Container(width: 15.0,),

                    Expanded(
                      child: OutlineButton(
                        color: Colors.redAccent[100],
                        textColor: Colors.red,
                        borderSide: BorderSide(color: Colors.red),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0)
                        ),
                        child: Text (
                          'Delete',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          setState(() {
                            debugPrint("Delete button clicked");
                            _delete();
                          });
                        },
                      ),
                    ),
                    Container(width: 15.0,),
                  ],
                ),
              )
            ],
          ),
        )),
      ));
    }

    void goBack() {
      Navigator.pop(context, true);
    }

    void updatePriorityAsInt(String value) {
      if (value == 'High') {
        note.priority = 1;
      }
      else {
        note.priority = 2;
      }
    }

    String priorityAsString(int value) {
      // Till we don't have multiple
      return _priorities[value-1];
    }

    // Save Function
    void _save() async {
      // Thanks to intl lib
      goBack();
      note.date = DateFormat.yMMMd().format(DateTime.now());
      int res;
      if (note.id != null) { // Update
        res = await dbHelper.updateNote(note);
      } else {
        res = await dbHelper.addNote(note);
      }

      if (res != 0) {
        _showAlert('Status', 'Saved Successfully!');
      } else {
        _showAlert('Status', 'Failed to save :(');
      }
    }

    void _delete() async {
      goBack();

      int res;
      if (note.id == null) { // Update
        _showAlert('Status', 'What you tryin to do?');
      }

      res = await dbHelper.deleteNote(note);

      if (res != 0) {
        _showAlert('Status', 'Delete Successfully!');
      } else {
        _showAlert('Status', 'Failed to delete :(');
      }
    }

    void _showAlert(String title, String desc) {
      AlertDialog alert = AlertDialog(
        title: Text(title),
        content: Text(desc),
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(20)
        ),
        // actions: <Widget>[
        //   FlatButton(
        //     child: const Text('Okie'),
        //     onPressed: () {
        //       goBack();
        //     }
        //   )
        // ],
      );
      showDialog(
        context: context,
        builder: (_) => alert
      );
    }

}