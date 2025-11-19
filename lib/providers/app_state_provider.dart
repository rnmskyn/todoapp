import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:i12_into_012/model/app_state.dart';
import 'package:i12_into_012/model/todo.dart';
import 'package:i12_into_012/services/json_storage.dart';
import 'package:i12_into_012/services/sqlite_storage.dart';
import 'package:i12_into_012/services/storage_service.dart';
import 'package:uuid/uuid.dart';

class AppStateNotifier extends StateNotifier<AppState> {
  final StorageService _storageService;
  
  AppStateNotifier(this._storageService) : super(AppState()) {
    loadState();
  }

  // Load state from storage
  Future<void> loadState() async {
    try {
      log('Loading app state from storage');
      final appState = await _storageService.loadAppState();
      if (appState != null) {
        state = appState;
      }
    } catch (e) {
      // Handle error or use default state
      print('Error loading state: $e');
    }
  }
  Future<void> saveToDoItem(Todo item) async {
  // Save state to storage
    await _storageService.saveToDoItem(state, item);
  }
  
  Future<void> saveSettings() async {
    await _storageService.saveSettings(state);
  }
  Future<void> deleteToDoItem(Todo item) async {
    await _storageService.deleteToDoItem(state, item);
  }

  // Add a new todo
  void addTodo(String text) {
    if (text.trim().isEmpty) return;
    var uuid = Uuid();
    final newTodo = Todo(
      id: uuid.v4(),
      text: text.trim(),
    );
    
    state = state.copyWith(
      todos: [...state.todos, newTodo],
    );
    saveToDoItem(newTodo);
  }

  // Toggle todo completion status
  Future<void> toggleTodo(String id) async {
    final updatedTodos = state.todos.map((todo) {
      if (todo.id == id) {
        return todo.copyWith(isCompleted: !todo.isCompleted);
      }
      return todo;
    }).toList();

    // Update state optimistically
    state = state.copyWith(todos: updatedTodos);

    // Persist the changed todo (if found)
    for (final t in updatedTodos) {
      if (t.id == id) {
        await saveToDoItem(t);
        break;
      }
    }
  }

  // Toggle todo selection
  void toggleSelection(String id) {
    final selectedIds = Set<String>.from(state.selectedTodoIds);
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
    state = state.copyWith(selectedTodoIds: selectedIds);
  }

  // Clear all selections
  void clearSelection() {
    state = state.copyWith(selectedTodoIds: {});
  }

  // Delete selected todos
  Future<void> deleteSelectedTodos() async {
    if (state.selectedTodoIds.isEmpty) return;
    // Capture the selected IDs and the todos to delete before mutating state
    final selectedIds = Set<String>.from(state.selectedTodoIds);
    final todosToDelete = state.todos.where((t) => selectedIds.contains(t.id)).toList();

    // Update state first (optimistic UI)
    final remainingTodos = state.todos.where((todo) => !selectedIds.contains(todo.id)).toList();
    state = state.copyWith(
      todos: remainingTodos,
      selectedTodoIds: {},
    );

    // Delete from persistent storage
    for (final todo in todosToDelete) {
      await deleteToDoItem(todo);
    }
  }

  // Toggle dark mode
  void toggleDarkMode() {
    state = state.copyWith(settings: state.settings.toggleDarkMode());
    saveSettings();
  }

  // Toggle deletion confirmation
  void toggleDeletionConfirmation() {
    state = state.copyWith(settings: state.settings.toggleDeletionConfirmation());
    saveSettings();
  }
}

// Storage service provider
final storageServiceProvider =  Provider<JsonStorage>((ref) { //Provider<SqliteStorage>((ref) {
  // StorageService must be initialized before use. Provide an
  // initialized instance from `main()` using `ProviderScope.overrides`.
  return JsonStorage(ref);
});

/*
final storageServiceProvider =  Provider<SqliteStorage>((ref) {
  // StorageService must be initialized before use. Provide an
  // initialized instance from `main()` using `ProviderScope.overrides`.
  return SqliteStorage(ref);
});
*/


// App state notifier provider
final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return AppStateNotifier(storageService);
});

// Derived providers for convenience
final todosProvider = Provider<List<Todo>>((ref) {
  return ref.watch(appStateProvider).todos;
});

final isDarkModeProvider = Provider<bool>((ref) {
  return ref.watch(appStateProvider).settings.isDarkMode;
});

final selectedTodosProvider = Provider<Set<String>>((ref) {
  return ref.watch(appStateProvider).selectedTodoIds;
});

final hasSelectedTodosProvider = Provider<bool>((ref) {
  return ref.watch(selectedTodosProvider).isNotEmpty;
});

final asksForDeletionConfirmation = Provider<bool>((ref) {
  return ref.watch(appStateProvider).settings.asksForDeletionConfirmation;
});
