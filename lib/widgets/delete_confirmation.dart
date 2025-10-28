import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i12_into_012/providers/app_state_provider.dart';


class DeletionConfirmation extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return SimpleDialog(
      title: const Text('Confirm Deletion'),
      children: [
        Column(
          children: [
            const Text('Are you sure you want to delete selected items?'),
          
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
                      ref.read(appStateProvider.notifier).deleteSelectedTodos();
                      Navigator.pop(context); // This closes the dialog
                  },
                  child: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
