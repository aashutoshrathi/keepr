import 'package:flutter/material.dart';

class NoteDetail extends StatefulWidget {

  String appBarTitle;

  NoteDetail(this.appBarTitle);

  @override
    State<StatefulWidget> createState() {
      return NoteDetailState(this.appBarTitle);
    }
}

class NoteDetailState extends State<NoteDetail> {
  
  static var _priorities = ['High', 'Low'];

  String appBarTitle;

  TextEditingController titleContr = TextEditingController();
  TextEditingController descContr = TextEditingController();

  NoteDetailState(this.appBarTitle);

  @override
    Widget build(BuildContext context) {

      TextStyle textStyle = Theme.of(context).textTheme.title;

      return 
      WillPopScope (
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

        body: Padding(
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
                  value: 'Low',
                  
                  onChanged: (valueSelected) {
                    setState(() {
                      debugPrint('User selected $valueSelected');
                    });
                  }
                ),
              ),

              Padding (
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: titleContr,
                  style: textStyle,
                  onChanged: (value) {
                    debugPrint('Something in Text Field');
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
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text (
                          'Save',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          setState(() {
                            debugPrint("Save button clicked");
                          });
                        },
                      ),
                    ),

                    Container(width: 5.0,),

                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text (
                          'Delete',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          setState(() {
                            debugPrint("Delete button clicked");
                          });
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ));
    }

    void goBack() {
      Navigator.pop(context);
    }

}