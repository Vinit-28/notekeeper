
// Class to Handle with NoteMaps and Notes //
class Notes{

  // Static Method to convert a note to a Map Object //
  static Map<String, dynamic> toMap(title, subtitle, priority,{id=null}){

    var noteMap = Map<String, dynamic>();
    if(id != null)
      noteMap['ID'] = id ;

    noteMap['TITLE'] = title;
    noteMap['SUBTITLE'] = subtitle;
    noteMap['PRIORITY'] = priority;
    return noteMap;
  }

  // Static Method to convert a Map Object to a note(List)//
  static List<dynamic> fromMap(Map<String, dynamic> noteMap){

    List<dynamic> lst = [];
    lst.add(noteMap['ID']);
    lst.add(noteMap['TITLE']);
    lst.add(noteMap['SUBTITLE']);
    lst.add(noteMap['PRIORITY']);

    return lst;
  }

}