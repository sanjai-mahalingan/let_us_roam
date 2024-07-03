import 'package:flutter/material.dart';
import 'package:let_us_roam/pages/initialView.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      initialRoute: "initialView",
      routes: {
        "initialView": (context) => const InitialView(),
      },
    );
  }
}
