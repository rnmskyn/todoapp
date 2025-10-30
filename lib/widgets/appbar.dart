import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i12_into_012/providers/app_state_provider.dart';
import 'package:i12_into_012/screens/settings_screen.dart';

class SettingsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.settings),
      onPressed: () {
        // Navigate to settings screen or open settings dialog
        Navigator.push(
          context,
          MaterialPageRoute<ConsumerWidget>(
            builder: (context) => SettingsScreen(),
          ),
        );
      },
    );
  }
}

class CancelButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () => ref.read(appStateProvider.notifier).clearSelection(),
      child: const Text('Cancel'),
    );
  }
}

class DynamicAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;

  DynamicAppBar(this.title);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasSelections = ref.watch(selectedTodosProvider).isNotEmpty;

    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,

      title: hasSelections
          ? const Text('')
          : Center(child: Text(title, textAlign: TextAlign.center)),
      actions: [if (hasSelections) CancelButton() else SettingsButton()],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
