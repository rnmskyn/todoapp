import 'dart:convert';
import 'dart:io';
import 'package:i12_into_012/model/app_state.dart';
import 'package:i12_into_012/model/todo.dart';
import 'package:i12_into_012/widgets/todo_item.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class StorageService {
  late Database database;

  Future<void> init() async {
    database = await openAppDatabase();
    print('StorageService: opened database at ${await _localPath}');
  }

  Future<String> get _localPath async {
    var databasesPath = await getDatabasesPath();
    return join(databasesPath, 'todo_app_state.db');
  }
  
  Future<Database> openAppDatabase() async {
    final path = await _localPath;
    try {
      Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // Some sqlite wrappers don't support multiple statements in a
          // single execute call. Create tables separately.
          await db.execute(
            'CREATE TABLE Todo (id TEXT PRIMARY KEY, text TEXT, isCompleted INTEGER)'
          );
          await db.execute(
            'CREATE TABLE Settings (isDarkMode INTEGER PRIMARY KEY, asksForDeletionConfirmation INTEGER)'
          );
        }
      );
      return database;
    } catch (e) {
      print('Failed to open database at $path: $e');
      rethrow;
    }
  }

  Future<void> saveToDoItem(Todo item) async {
    await database.insert(
      'Todo',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }
  Future<void> deleteToDoItem(Todo item) async {
  await database.delete(
    'Todo',
    // Use a `where` clause to delete a specific dog.
    where: 'id = ?',
    whereArgs: [item.id],
    );
  }

  Future<void> saveSettings(AppState appState) async {
    await database.delete('Settings');
    await database.insert(
      'Settings',
      {
        'isDarkMode': appState.isDarkMode ? 1 : 0,
        'asksForDeletionConfirmation': appState.asksForDeletionConfirmation ? 1 : 0,
      },
    );
  }
  
  Future<AppState?> loadAppState() async {
      final List<Map<String, Object?>> todoMaps = await database.query('Todo');
      final List<Map<String, Object?>> settingsList = await database.query('Settings');
      final Map<String, Object?> settingsMap =
        settingsList.isNotEmpty ? settingsList[0] : <String, Object?>{};
      return AppState.fromMap(settingsMap, todoMaps);
  }

}