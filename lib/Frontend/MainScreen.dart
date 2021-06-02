import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_cursor/flutter_cursor.dart';
import 'package:notekeeper/Backend/DatabaseOperations.dart';
import 'Add_Edit.dart';
import 'package:notekeeper/Backend/NoteMapping.dart';


// Declaration of Global Variables //
dynamic _appTheme = Brightness.dark;
var databaseObject = NotesDataBase();


// Class to Build the App or Material App //
class BuildApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return(
      MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              brightness: _appTheme,
              primaryColor: Colors.deepPurple,
              accentColor: Colors.indigoAccent
          ),
          title: "Note Keeper",
          home: BuildHomeUI()
      )
    );
  }
}


// Class to Build the Home for App //
class BuildHomeUI extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _BuildHomeUI();
  }
}


// Class to Build the the state of the BuildHomeUI //
class _BuildHomeUI extends State<BuildHomeUI>{

  List<dynamic> _notes = [];
  var _notesCount;


  @override
  Widget build(BuildContext context) {

    loadNotesFromDatabase();

    return(
      Scaffold(
        appBar: AppBar(
          title: Text(
            "Note Keeper",
            style: TextStyle(fontSize: 17.0),
          ),
          actions: [
            getThemeButton()
          ],
        ),
        body: ListView(
          children: getListOfWidgets(context),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async { await Navigator.push(context, MaterialPageRoute(builder: (context) { return Add_Edit_UI("Add Note"); } )); updateHome(); },
          elevation: 10.0,
        ),
      )
    );

  }

  // Method to Work for the Theme of the App //
  TextButton getThemeButton(){
    String buttonText = "Dark Theme";
    if( _appTheme == Brightness.dark ){
      buttonText = 'Light Theme';
    }
    return(
        TextButton(
          style: ButtonStyle(
              foregroundColor:MaterialStateProperty.all(Colors.white)
          ),
          child: Text(buttonText),
          onPressed: () {
            if( _appTheme == Brightness.dark ){
              _appTheme = Brightness.light;
            }
            else{
              _appTheme = Brightness.dark;
            }
            runApp(BuildApp());
          },
        )
    );
  }

  // Method to load data from the database //
  void loadNotesFromDatabase() async {

    var high = [], normal = [], low = [];
    var mapList = await databaseObject.readNotes();
    this._notesCount = mapList.length;
    this._notes=[];
    for(var noteMap in mapList){

      var temp = Notes.fromMap(noteMap);
      if( temp[3] == 'High' )
        high.add(temp);
      else if(temp[3] == 'Normal' )
        normal.add(temp);
      else
        low.add(temp);
    }

    this._notes = high + normal + low;
    setState(() {});
  }


  // Method to get the Widget List for the App //
  List<Widget> getListOfWidgets(BuildContext context){
    List<Widget> myNoteList = [];
    if(_notesCount==null)
      return [];
    for(int index=0; index<_notesCount; index++){
      myNoteList.add(getNote(context, index));
    }
    return myNoteList;
  }


  // Method to wrap data in a Card to be displayed on the screen //
  Widget getNote(BuildContext context, int noteIndex){

    dynamic noteColor = Colors.blueAccent, noteToolTip="It's Important";

    noteColor = ( _notes[ noteIndex ][3] == 'High')? (Colors.redAccent) : ( _notes[ noteIndex ][3] == 'Low')? (Colors.yellowAccent) : (noteColor);
    noteToolTip = ( _notes[ noteIndex ][3] == 'High')? ("It's Very Important") : ( _notes[ noteIndex ][3] == 'Low')? ("Not So Important") : (noteToolTip);

    return(
      Card(
        elevation: 10.0,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: noteColor,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.message_outlined),
              onPressed: (){},
              tooltip: noteToolTip,
            )
          ),

          title: Text(_notes[noteIndex][1]),
          subtitle: Text(_notes[noteIndex][2]),
          trailing: IconButton(
            icon: Icon(Icons.delete_outline_outlined),
            color: Colors.grey,
            onPressed: () async { await deleteNote(_notes[noteIndex][0]); updateHome();},
            tooltip: "Delete Note",
          ),

          onTap: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Add_Edit_UI('Edit Note',_notes[noteIndex][3],_notes[noteIndex][1],_notes[noteIndex][2],_notes[noteIndex][0]);
            } ));
            updateHome();
          },
        ),
      )
    );
  }


  // Method to update the Home of the App //
  void updateHome() async {
    await loadNotesFromDatabase();
  }

  // Method to delete a Note from the HomeUI //
  void deleteNote(int ID) async {

    var result = await databaseObject.deleteNote(ID);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Note Deleted Successfully",style: TextStyle(color: Colors.white),),duration: Duration(milliseconds: 1000),backgroundColor: Colors.black45,));
  }

}






























































