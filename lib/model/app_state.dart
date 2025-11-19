import 'package:i12_into_012/model/settings.dart';
import 'package:i12_into_012/model/todo.dart';

class AppState {
  final List<Todo> todos;
  final Settings settings;
  final Set<String> selectedTodoIds; // For tracking selected items

  AppState({
    this.todos = const [],
    this.settings = const Settings(
      isDarkMode: false,
      asksForDeletionConfirmation: true,
    ),
    this.selectedTodoIds = const {},
  });

  // Create a copy with modified properties
  AppState copyWith({
    List<Todo>? todos,
    Settings? settings,
    Set<String>? selectedTodoIds,
  }) {
    return AppState(
      todos: todos ?? this.todos,
      settings: settings ?? this.settings,
      selectedTodoIds: selectedTodoIds ?? this.selectedTodoIds,
    );
  }

  // Create AppState from JSON
  factory AppState.fromMap(
    Map<String, Object?> settingsMap,
    List<Map<String, Object?>> todoMaps,
  ) {
    return AppState(
      todos: [
        for (final todoMap in todoMaps)
          Todo(
            id: todoMap['id'] as String? ?? '',
            text: todoMap['text'] as String? ?? '',
            isCompleted: () {
              final v = todoMap['isCompleted'] ?? todoMap['completed'];
              return v != 0;
            }(),
          ),
      ],
      settings: Settings(
        isDarkMode: (settingsMap['isDarkMode'] as bool?) ?? false,
        asksForDeletionConfirmation:
            (settingsMap['asksForDeletionConfirmation'] as bool?) ?? false,
      ),
    );
  }
}
