import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i12_into_012/providers/app_state_provider.dart';
import 'package:i12_into_012/screens/todo_list_screen.dart';
import 'package:i12_into_012/widgets/action_button.dart';
import 'package:i12_into_012/widgets/appbar.dart';

void main() {
  runApp(
    // Enabled Riverpod for the entire application
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        /* light theme settings */
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      themeMode: ref.watch(isDarkModeProvider)
          ? ThemeMode.dark
          : ThemeMode.light,
      debugShowCheckedModeBanner: false,

      home: const MyHomePage(title: 'TODO APP'),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: DynamicAppBar(title),
      body: Center(
        child: TodoListScreen(),
      ),
      floatingActionButton: ActionButton(),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
