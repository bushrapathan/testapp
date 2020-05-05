import 'dart:async';
import 'dart:io';
import 'package:news/src/resources/repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/item_model.dart';

class NewsDbProvider implements Source, Cache {
  Database db;

  NewsDbProvider() {
    init();
  }

  Future<List<int>> fetchTopIds() {
    return null;
  }

  void init() async {
    //It gives directory where application can place file
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    //path here stores actual path where we are going to store the database
    final path = join(documentsDirectory.path, "items.db");
    //Creating database if not exists and opening it if db exists
    //onCreate get calls only when user opens app for first time
    db = await openDatabase(path, version: 1,
        onCreate: (Database newDb, int version) {
      //Creating table
      newDb.execute("""
          CREATE TABLE Items
          (
            id INTEGER PRIMARY KEY,
            type TEXT,
            by TEXT,
            time INTEGER,
            text TEXT,
            parent INTEGER,
            kids BLOB,
            dead INTEGER,
            url TEXT,
            score INTEGER,
            title TEXT,
            descendants INTEGERS
          )
          """);
    });
  }

  Future<ItemModel> fetchItem(int id) async {
    final maps = await db.query(
      "Items",
      columns: null,
      where: "id =?",
      whereArgs: [id],
    );

    if (maps.length > 0) {
      return ItemModel.fromDb(maps.first);
    }

    return null;
  }

  Future<int> addItem(ItemModel item) {
    return db.insert("Items", item.tomap(),conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future <int> clear(){
    return db.delete("Items");
  }
}

final newsDbProvider = NewsDbProvider();
