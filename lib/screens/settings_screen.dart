import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i12_into_012/providers/app_state_provider.dart';



class SettingsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: ref.watch(isDarkModeProvider),
            onChanged: (value) => ref.read(appStateProvider.notifier).toggleDarkMode(),
          ),

          SwitchListTile(
            title: const Text('Ask for Deletion Confirmation'),
            value: ref.watch(asksForDeletionConfirmation),
            onChanged: (value) => ref.read(appStateProvider.notifier).toggleDeletionConfirmation(),
          ),
        ],
      ),
    );
  }
}
