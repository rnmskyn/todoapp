import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i12_into_012/providers/app_state_provider.dart';

class AddTodoDialog extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String itemText = "";
    return SimpleDialog(
      title: const Text('Add new item'),
      children: [
        Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter text here',
              ),
              onChanged: (text) {
                itemText = text;
              },
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () =>
                      Navigator.pop(context), // This closes the dialog
                  child: const Text('Cancel'),
                ),

                TextButton(
                  onPressed: () {
                      ref.read(appStateProvider.notifier).addTodo(itemText);
                      Navigator.pop(context); // This closes the dialog
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
