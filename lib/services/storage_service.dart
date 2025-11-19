import 'package:i12_into_012/model/app_state.dart';
import 'package:i12_into_012/model/todo.dart';


abstract class StorageService {
  Future<void> saveToDoItem(Todo item);

  Future<void> deleteToDoItem(Todo item);

  Future<void> saveSettings(AppState appState);

  Future<AppState?> loadAppState();
}
