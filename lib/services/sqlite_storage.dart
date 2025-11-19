import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i12_into_012/model/app_state.dart';
import 'package:i12_into_012/model/todo.dart';
import 'package:i12_into_012/services/storage_service.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final databaseProvider = FutureProvider<Database>((ref) async {
    var databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'todo_app_state.db');
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
});

class SqliteStorage implements StorageService {
  final Ref _ref; // Ref to access providers

  SqliteStorage(this._ref);

  Future<void> saveToDoItem(Todo item) async {
    final db = await _ref.read(databaseProvider.future);
    await db.insert(
      'Todo',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<void> deleteToDoItem(Todo item) async {
    final db = await _ref.read(databaseProvider.future);
    await db.delete(
    'Todo',
    // Use a `where` clause to delete a specific dog.
    where: 'id = ?',
    whereArgs: [item.id],
    );
  }

  Future<void> saveSettings(AppState appState) async {
    final db = await _ref.read(databaseProvider.future);
    await db.delete('Settings');
    await db.insert(
      'Settings',
      {
        'isDarkMode': appState.isDarkMode ? 1 : 0,
        'asksForDeletionConfirmation': appState.asksForDeletionConfirmation ? 1 : 0,
      },
    );
  }
  
  Future<AppState?> loadAppState() async {
      final db = await _ref.read(databaseProvider.future);
      final List<Map<String, Object?>> todoMaps = await db.query('Todo');
      final List<Map<String, Object?>> settingsList = await db.query('Settings');
      final Map<String, Object?> settingsMap =
        settingsList.isNotEmpty ? settingsList[0] : <String, Object?>{};
      return AppState.fromMap(settingsMap, todoMaps);
  }
}