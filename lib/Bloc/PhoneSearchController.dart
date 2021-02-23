import 'package:flutter_app_hyuabot_v2/Model/Phone.dart';
import 'package:path/path.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sqflite/sqflite.dart';

class InSchoolPhoneSearchController{
  Database _database;
  final BehaviorSubject<List<PhoneNum>> _subject = BehaviorSubject<List<PhoneNum>>();

  InSchoolPhoneSearchController(){
    loadDatabase();
  }

  loadDatabase() {
    String _path;
    getDatabasesPath().then((value){_path = value;}).whenComplete((){
      openDatabase(
          join(_path, "information.db")
      ).then((value){_database = value;}).whenComplete((){
        search('');
      });
    });
  }

  search(String keyword) async {
    String _query;
    if(keyword.isEmpty){
      _query = "select name, phone from inschool where phone is not null";
    } else {
      _query = "select name, phone from inschool where phone is not null and name like '%$keyword%'";
    }
    List<Map> queryResult = await _database.rawQuery(_query);
    _subject.add(queryResult.map((e) => PhoneNum.fromJson(e)).toList());
  }

  dispose(){
    _subject.close();
  }

  Stream<List<PhoneNum>> get searchResult => _subject.stream;

}

class OutSchoolPhoneSearchController{
  Database _database;
  BehaviorSubject<List<PhoneNum>> _subject = BehaviorSubject<List<PhoneNum>>();

  OutSchoolPhoneSearchController(){
    loadDatabase();
  }

  loadDatabase() {
    String _path;
    getDatabasesPath().then((value){_path = value;}).whenComplete((){
      openDatabase(
          join(_path, "information.db")
      ).then((value){_database = value;}).whenComplete((){
        search('');
      });
    });
  }

  search(String keyword) async {
    String _query;
    if(keyword.isEmpty){
      _query = "select name, phone from outschool where phone is not null";
    } else {
      _query = "select name, phone from outschool where phone is not null and name like '%$keyword%'";
    }
    List<Map> queryResult = await _database.rawQuery(_query);
    _subject.add(queryResult.map((e) => PhoneNum.fromJson(e)).toList());
  }

  Stream<List<PhoneNum>> get searchResult => _subject.stream;
}
