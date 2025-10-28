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

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'todos': todos.map((todo) => todo.toJson()).toList(),
      'isDarkMode': isDarkMode,
      'asksForDeletionConfirmation': asksForDeletionConfirmation,
      // We don't persist selection state
    };
  }

  // Create AppState from JSON
  factory AppState.fromJson(Map<String, dynamic> json) {
    return AppState(
      todos: (json['todos'] as List<dynamic>? ?? [])
          .map((todoJson) => Todo.fromJson(todoJson as Map<String, dynamic>))
          .toList(),
      isDarkMode: json['isDarkMode'] as bool? ?? false,
      asksForDeletionConfirmation:
          json['asksForDeletionConfirmation'] as bool? ?? true,
    );
  }
}
