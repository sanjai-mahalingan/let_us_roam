import 'package:flutter/material.dart';

class GoToHome extends StatelessWidget {
  const GoToHome({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pushReplacementNamed(context, 'indexView');
      },
      icon: const Icon(Icons.home),
    );
  }
}
