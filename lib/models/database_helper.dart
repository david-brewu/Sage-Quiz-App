 import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseHelper {
      String tableName;

      // DatabaseHelper(this.tableName);

    static DatabaseHelper _databaseHelper;
    static Database _database;

    String id = "id";
    String date = "date";



    DatabaseHelper._createInstance();

    factory DatabaseHelper(){
      if(_databaseHelper == null){
        _databaseHelper = DatabaseHelper._createInstance();
      }
      return _databaseHelper;
    }


    _createDb(Database db, int version)async{
      await db.execute('CREATE TABLE $tableName(id INTEGER PRIMARY KEY AUTO INCREMENT, $date DATE)');
    }


    Future<Database> initializeDatabase() async {
        Directory directory = await getApplicationDocumentsDirectory();
        String path = directory.path + "tpp.db";

        var dbinstance = openDatabase(path, version: 1, onCreate: _createDb);
        return dbinstance;

    }

    Future<Database> get database async{
      if(_database == null){
        _database = await initializeDatabase();
      }
      return _database;
    }

   fecthAll(order, orderBy) async{
      Database db =  await this.database;
      await db.query(tableName, orderBy: "$orderBy");
   }


 }