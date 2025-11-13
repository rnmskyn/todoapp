import 'package:i12_into_012/model/todo.dart';

class AppState {
  final List<Todo> todos;
  final bool isDarkMode;
  final bool asksForDeletionConfirmation;
  final Set<String> selectedTodoIds; // For tracking selected items

  AppState({
    this.todos = const [],
    this.isDarkMode = false,
    this.asksForDeletionConfirmation = true,
    this.selectedTodoIds = const {},
  });

  // Create a copy with modified properties
  AppState copyWith({
    List<Todo>? todos,
    bool? isDarkMode,
    bool? asksForDeletionConfirmation,
    Set<String>? selectedTodoIds,
  }) {
    return AppState(
      todos: todos ?? this.todos,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      asksForDeletionConfirmation:
          asksForDeletionConfirmation ?? this.asksForDeletionConfirmation,
      selectedTodoIds: selectedTodoIds ?? this.selectedTodoIds,
    );
  }
  /*
  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'todos': todos.map((todo) => todo.toJson()).toList(),
      'isDarkMode': isDarkMode,
      'asksForDeletionConfirmation': asksForDeletionConfirmation,
      // We don't persist selection state
    };
  }
*/
  // Create AppState from JSON
  factory AppState.fromMap(Map<String, Object?> settingsMap, List<Map<String, Object?>> todoMaps) {
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
      isDarkMode: () {
        final v = settingsMap['isDarkMode'];
        return v != 0;
      }(),
      asksForDeletionConfirmation: () {
        final v = settingsMap['asksForDeletionConfirmation'];
        return v != 0;
      }(),
    );
  }
}
