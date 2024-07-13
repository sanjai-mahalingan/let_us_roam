import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:let_us_roam/widgets/go_to_home.dart';

class CreateTripView extends ConsumerStatefulWidget {
  const CreateTripView({super.key});

  @override
  ConsumerState<CreateTripView> createState() => _CreateTripView();
}

class _CreateTripView extends ConsumerState<CreateTripView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Trip'),
        centerTitle: true,
        actions: const [GoToHome()],
      ),
      body: const Center(
        child: Text('Create a new trip'),
      ),
    );
  }
}
