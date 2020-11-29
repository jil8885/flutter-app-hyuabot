import 'package:path/path.dart';

import 'package:rxdart/rxdart.dart';
import 'package:sqflite/sqflite.dart';


class FetchPhoneController{
  final _allPhoneInfoSubject = BehaviorSubject<List<PhoneNum>>();
  FetchPhoneController(){
    fetch();
  }

  void fetch([String query]) async{
    // query ??= "select * from telephone";
    // var path = await getDatabasesPath();
    // database = await openDatabase(join(path, "telephone.db"));
    // List<Map> queryResult = await database.rawQuery(query);
    // await database.close();
    // _allPhoneInfoSubject.add(queryResult.map((e) => PhoneNum.fromJson(e)).toList());
  }

  Stream<List<PhoneNum>> get allPhoneInfo => _allPhoneInfoSubject.stream;
}
class PhoneNum{
  final String name;
  final String number;
  PhoneNum(this.name, this.number);

  factory PhoneNum.fromJson(Map<String, dynamic> json){
    return PhoneNum(json["name"], json['phone']);
  }
}