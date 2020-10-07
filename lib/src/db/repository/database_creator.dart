import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


Database db;

class DatabaseCreator {
  static const recipeTable = 'recipe';
  static const id = 'id';
  static const typePos = 'typePos';
  static const name = 'name';
  static const picture = 'picture_path';
  static const ingredients = 'ingredients';
  static const steps = 'steps';
  static const isDeleted = 'isDeleted';

  static void databaseLog(String functionName, String sql,
      [List<Map<String, dynamic>> selectQueryResult, int insertAndUpdateQueryResult, List<dynamic> params]) {
    print(functionName);
    print(sql);
    if (params != null) {
      print(params);
    }
    if (selectQueryResult != null) {
      print(selectQueryResult);
    } else if (insertAndUpdateQueryResult != null) {
      print(insertAndUpdateQueryResult);
    }
  }

  Future<void> createRecipeTable(Database db) async {
    final todoSql = '''CREATE TABLE $recipeTable
    (
      $id INTEGER PRIMARY KEY,
      $typePos INTEGER,
      $name TEXT,
      $picture TEXT,
      $ingredients TEXT,
      $steps TEXT,
      $isDeleted BIT NOT NULL
    )''';

    await db.execute(todoSql);
  }

  Future<String> getDatabasePath(String dbName) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, dbName);

    //make sure the folder exists
    if (await Directory(dirname(path)).exists()) {
      //await deleteDatabase(path);
    } else {
      await Directory(dirname(path)).create(recursive: true);
    }
    return path;
  }

  Future<void> initDatabase() async {
    final path = await getDatabasePath('recipe_db');
    db = await openDatabase(path, version: 1, onCreate: onCreate);
    print(db);
  }

  Future<void> onCreate(Database db, int version) async {
    await createRecipeTable(db);
  }



}