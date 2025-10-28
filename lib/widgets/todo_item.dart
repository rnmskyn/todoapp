import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i12_into_012/model/todo.dart';
import 'package:i12_into_012/providers/app_state_provider.dart';

class TodoItem extends ConsumerWidget {
  const TodoItem({required this.todo});

  final Todo todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIds = ref.watch(selectedTodosProvider);
    final notifier = ref.read(appStateProvider.notifier);

    return ListTile(
      title: Row(
        children: [
          Checkbox(
            value: todo.isCompleted,
            onChanged: (bool? value) =>
                ref.read(appStateProvider.notifier).toggleTodo(todo.id),
          ),
          Text(todo.text),
        ],
      ),
      selected: selectedIds.contains(todo.id),
      onTap: () => notifier.toggleSelection(todo.id),
    );
  }
}
