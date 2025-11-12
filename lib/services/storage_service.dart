import 'dart:convert';
import 'dart:io';
import 'package:i12_into_012/model/app_state.dart';
import 'package:i12_into_012/model/todo.dart';
import 'package:i12_into_012/widgets/todo_item.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class StorageService {
  Database? database;

  Future<void> init() async {
    database = await openAppDatabase();
  }

  Future<String> get _localPath async {
    var databasesPath = await getDatabasesPath();
    return join(databasesPath, 'todo_app_state.db');
  }
  
  Future<Database> openAppDatabase() async {
    Database database = await openDatabase(await _localPath, version: 1,
      onCreate: (Database db, int version) async {
      await db.execute(
        'CREATE TABLE Todo (id TEXT PRIMARY KEY, task TEXT, completed INTEGER)');
      });
    return database;
  }

  Future<void> saveToDoItem(Todo item) async {
    await database?.insert(
      'Todo',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<void> saveAppState(AppState state) async {
    final file = await _localFile;
    final jsonString = jsonEncode(state.toJson());
    await file.writeAsString(jsonString);
  }

  Future<AppState?> loadAppState() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) {
        return null;
      }
      
      final jsonString = await file.readAsString();
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return AppState.fromJson(jsonMap);
    } catch (e) {
      print('Error loading app state: $e');
      return null;
    }
  }

}