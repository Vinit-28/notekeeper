import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';


// Class to Handle Database Operations //
class NotesDataBase{

  String _dbName,_tableName, _path;

  Database _dbObject;

  // Method(Getter) to get the Database Object //
  Future<Database> get dataBaseObject async{
    if(this._dbObject == null){
      this._dbName = 'MyNotes.db';
      this._tableName = 'NotesTable';
      this._dbObject = await _initializeDatabase();
    }
    return this._dbObject;
  }


  // Method to Initialize/Open the Database //
  Future<Database> _initializeDatabase() async {
    Directory directory =  await getApplicationDocumentsDirectory();
    this._path = (directory.path + this._dbName).toString();

    var dbobject = await openDatabase(this._path,version: 1, onCreate: _createLogicalStructure);
    return dbobject;
  }

  // Method to Create Database //
  void _createLogicalStructure(Database db, int version) async {
    await db.execute("CREATE TABLE $_tableName(ID INTEGER PRIMARY KEY AUTOINCREMENT, TITLE TEXT, SUBTITLE TEXT, PRIORITY TEXT)");
  }

  // Method to insert data into the database //
  Future<int> insertNote(Map<String, dynamic> note) async {

    this._dbObject = await this.dataBaseObject;
    var result = await this._dbObject.insert(_tableName, note);
    return result;
  }

  // Method to read data from the database //
  Future<List<Map<String, dynamic>>> readNotes() async {

    this._dbObject = await this.dataBaseObject;
    var result = await this._dbObject.query(_tableName);
    return result;
  }

  // Method to update data in the database //
  Future<int> updateNote(Map<String, dynamic> note) async {

    Database db = await this.dataBaseObject;
    var result = await this._dbObject.rawQuery("UPDATE $_tableName SET TITLE = \"${note['TITLE']}\", SUBTITLE = \"${note['SUBTITLE']}\", PRIORITY = \"${note['PRIORITY']}\" WHERE ID = ${note['ID']}");
    return 1;
  }

  // Method to delete tha data from the database //
  Future<int> deleteNote(int Id) async {

    Database db = await this.dataBaseObject;
    var result = await this._dbObject.delete(_tableName,where: "ID = ?",whereArgs: [Id]);
    return result;
  }

}







































