import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i12_into_012/providers/app_state_provider.dart';
import 'package:i12_into_012/widgets/add_todo_dialog.dart';
import 'package:i12_into_012/widgets/delete_confirmation.dart';

class AddButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () {
        showDialog<SimpleDialog>(
          context: context,
          builder: (BuildContext context) {
            return AddTodoDialog();
          },
        );
      },
      backgroundColor: Colors.blue, // Optional: button color
      foregroundColor: Colors.white, // Optional: icon color
      child: const Icon(Icons.add), // The icon inside the button
    );
  }
}

class DeleteButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () {
        if (ref.read(asksForDeletionConfirmation)) {
          showDialog<SimpleDialog>(
            context: context,
            builder: (BuildContext context) {
              return DeletionConfirmation();
            },
          );
        } else {
          ref.read(appStateProvider.notifier).deleteSelectedTodos();
        }
      },
      backgroundColor: Colors.red, // Optional: button color
      foregroundColor: Colors.white, // Optional: icon color
      child: const Icon(Icons.delete), // The icon inside the button
    );
  }
}

class ActionButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(appStateProvider).selectedTodoIds.isNotEmpty) {
      return DeleteButton();
    }
    return AddButton();
  }
}
