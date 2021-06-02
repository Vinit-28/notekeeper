import 'package:flutter/material.dart';
import 'package:notekeeper/Backend/DatabaseOperations.dart';
import 'package:notekeeper/Backend/NoteMapping.dart';


// Class to Build the UI for the Add/Edit Note //
class Add_Edit_UI extends StatelessWidget{

  String _title, _notePriority, _noteTitle, _noteSubtitle;
  var _noteId;
  Add_Edit_UI(this._title, [this._notePriority = 'Normal', this._noteTitle = '', this._noteSubtitle = '', this._noteId=0]){}

  @override
  Widget build(BuildContext context) {
    return(
        Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () { Navigator.pop(context); },
            ),
            title: Text(this._title, style: TextStyle(fontSize: 17.0)),
          ),
          body: BuildWidgets(this._noteId,this._title,this._notePriority,this._noteTitle,this._noteSubtitle),
        )
    );
  }
}


// Class to Build Widegts for the Add/Edit Screen //
class BuildWidgets extends StatefulWidget{

  String _mode, _notePriority, _noteTitle, _noteSubtitle;
  var _noteId;
  BuildWidgets(this._noteId,this._mode, [this._notePriority = 'Normal', this._noteTitle = '', this._noteSubtitle = '']){}

  @override
  State<StatefulWidget> createState() {
    return _BuildWidgets(this._noteId,this._mode,this._notePriority,this._noteTitle,this._noteSubtitle);
  }
}


// Class to Build the state of the BuildWidgets //
class _BuildWidgets extends State<BuildWidgets>{

  String _mode, _notePriority, _noteTitle, _noteSubtitle;
  var _noteId;
  var _priorityList = ['High','Normal','Low'];
  var _padding = 10.0;
  var _titleTextEditingController = TextEditingController(),_subtitleTextEditingController = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  var _databaseObject = NotesDataBase();

  _BuildWidgets(this._noteId,this._mode, [this._notePriority = 'Normal', this._noteTitle = '', this._noteSubtitle = '']){
    this._titleTextEditingController.text = this._noteTitle;
    this._subtitleTextEditingController.text = this._noteSubtitle;
  }


  @override
  Widget build(BuildContext context) {
    return(
      Form(
        key: _formKey,
        child: ListView(
          children: getWidgetList(context)
        ),
      )
    );
  }

  // Method to Make Widgets to be displayed on the Screen //
  List<Widget> getWidgetList(BuildContext context){

    if(_mode == 'Edit Note'){
    //  Load Title, Subtitle, NotePriority from the Database //
    }
    List<Widget> lst=[];

    lst.add(
      Row(
        children: <Widget>[

          Padding(
            padding: EdgeInsets.only(top: _padding*4, left: _padding, right: _padding*2),
            child: Text("Select Note Priority ", style: TextStyle(fontSize: 17.0),)
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: _padding*4, left: _padding, right: _padding),
              child: DropdownButton<String>(
                items: _priorityList.map((String item) {return DropdownMenuItem<String>(child: Text(item),value: item); }).toList(),
                onChanged: (String currSelected) { setState(() { _notePriority = currSelected; }); },
                value: _notePriority,
                elevation: 10,
                isExpanded: true,
              ),
            )
          )
        ],
      )
      
    );

    lst.add(
      Padding(
        padding: EdgeInsets.only(left: _padding, right: _padding, top: _padding*2, bottom: _padding*2),
        child: TextFormField(
          controller: _titleTextEditingController,
          decoration: InputDecoration(
            labelText: "Enter Title of Note",
            hintText: "Title Ex :- Talk to Mom",
            labelStyle: TextStyle(fontSize: 15.0,color: Colors.lightBlueAccent),
            hintStyle: TextStyle(fontSize: 15.0),
            errorStyle: TextStyle(fontSize: 15.0, color: Colors.redAccent)
          ),
          validator: (String inputTitle) { if(inputTitle.isEmpty){ return 'Please Enter Title'; } },
        ),
      )
    );

    lst.add(
      Padding(
        padding: EdgeInsets.only(left: _padding, right: _padding, top: _padding*2, bottom: _padding*2),
        child: TextFormField(
          controller: _subtitleTextEditingController,
          decoration: InputDecoration(
            labelText: "Enter Subtitle of Note",
            hintText: "Subtitle Ex :- Tonight 8:00 PM",
            labelStyle: TextStyle(fontSize: 15.0,color: Colors.lightBlueAccent),
            hintStyle: TextStyle(fontSize: 15.0),
            errorStyle: TextStyle(fontSize: 15.0, color: Colors.redAccent)
          ),
          validator: (String inputSubtitle) { if(inputSubtitle.isEmpty){ return 'Please Enter Subtitle'; } },
        ),
      )
    );

    lst.add(
      Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(_padding),
              child: ElevatedButton(
                child: Text("Save", style: TextStyle(fontSize: 17.0),),
                onPressed: (){saveNote();},
              ),
            )
          ),

          Expanded(
              child: Padding(
                padding: EdgeInsets.all(_padding),
                child: ElevatedButton(
                  child: Text("Delete", style: TextStyle(fontSize: 17.0),),
                  onPressed: (){ deleteNote(); },
                ),
              )
          )
        ],
      )
    );
    return lst;
  }

  // Method to delete a Pre-Existing Note //
  void deleteNote() async {

    if( _formKey.currentState.validate() == true || this._mode == 'Edit Note' ){

      var result = await this._databaseObject.deleteNote(this._noteId);
      debugPrint(result.toString());
      (result!=0)? this._showSnackbar(context, "Note Deleted Successfully") : this._showSnackbar(context, "Something Went Wrong");
    }
    else{
      this._showSnackbar(context, "Failed to Delete Note");
    }
    Navigator.pop(context);
  }

  // Method to Save a New Note //
  void saveNote() async {

    if( _formKey.currentState.validate() ){

      if( this._mode == 'Add Note' ){

        var myNote = Notes.toMap(this._titleTextEditingController.text, this._subtitleTextEditingController.text, this._notePriority);
        var result = await this._databaseObject.insertNote(myNote);
        (result!=0)? this._showSnackbar(context, "Note Saved Successfully") : this._showSnackbar(context, "Something Went Wrong");
      }

      else if( this._mode == 'Edit Note' ){

        var myNote = Notes.toMap(this._titleTextEditingController.text, this._subtitleTextEditingController.text, this._notePriority, id: this._noteId);
        var result = await this._databaseObject.updateNote(myNote);
        (result!=0)? this._showSnackbar(context, "Note Updated Successfully") : this._showSnackbar(context, "Something Went Wrong");

      }

      Navigator.pop(context);
    }
  }

  // Method to show SnackBar with Some Message //
  _showSnackbar(BuildContext context, String message){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message,style: TextStyle(color: Colors.white),),duration: Duration(milliseconds: 1000),backgroundColor: Colors.black45));
  }

}












































