import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InitialView extends ConsumerStatefulWidget {
  const InitialView({super.key});

  @override
  ConsumerState<InitialView> createState() => _InitialView();
}

class _InitialView extends ConsumerState<InitialView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Initial View'),
      ),
    );
  }
}
