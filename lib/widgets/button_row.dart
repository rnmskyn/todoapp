import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i12_into_012/providers/app_state_provider.dart';
import 'package:i12_into_012/widgets/add_todo_dialog.dart';
import 'package:i12_into_012/widgets/delete_confirmation.dart';
import 'package:i12_into_012/widgets/no_selected_items.dart';

class ButtonRow extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: () {
            if (ref.read(asksForDeletionConfirmation)) {
              showDialog<SimpleDialog>(
                context: context,
                builder: (BuildContext context) {
                  if (ref.read(selectedTodosProvider).length > 0) {
                    return DeletionConfirmation();
                  }
                  return NoSelectedItemsScreen();
                },
              );
            } else {
              ref.read(appStateProvider.notifier).deleteSelectedTodos();
            }
          },
          icon: const Icon(Icons.delete),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => showDialog<SimpleDialog>(
            context: context,
            builder: (BuildContext context) {
              return AddTodoDialog();
            },
          ),
        ),
      ],
    );
  }
}
