import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i12_into_012/model/app_state.dart';
import 'package:i12_into_012/model/settings.dart';
import 'package:i12_into_012/model/todo.dart';
import 'package:i12_into_012/services/storage_service.dart';
import 'package:path_provider/path_provider.dart';



class JsonStorage implements StorageService {
  final Ref _ref; // Ref to access providers

  JsonStorage(this._ref);

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<void> saveToDoItem(AppState appState, Todo item) async {
    await saveSettings(appState);
  }

  Future<void> deleteToDoItem(AppState appState, Todo item) async {
    await saveSettings(appState);
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/todo_app_state.json');
  }

  Future<void> saveSettings(AppState state) async {
    final file = await _localFile;
    final jsonString = jsonEncode(toJson(state.todos, state.settings));
    print(jsonString);

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
      List<dynamic> todosDynamic = jsonMap['todos'] as List<dynamic>;

    // Convert it to List<Map<String, dynamic?>>
    List<Map<String, dynamic?>> todosMapList = todosDynamic
      .map((item) => item as Map<String, dynamic?>)
      .toList();
      final settingsMap = {
        'isDarkMode': jsonMap['isDarkMode'],
        'asksForDeletionConfirmation': jsonMap['asksForDeletionConfirmation'],
      };
      return AppState.fromMap(settingsMap, todosMapList);
    } catch (e) {
      print('Error loading app state: $e');
      return null;
    }
  }

  Map<String, dynamic> toJson(List<Todo> todos, Settings settings) {
    return {
      'todos': todos.map((todo) => todo.toMap()).toList(),
      'isDarkMode': settings.isDarkMode,
      'asksForDeletionConfirmation': settings.asksForDeletionConfirmation,
    };
  }
}