import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Loader extends StatelessWidget {
  const Loader({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LoadingAnimationWidget.inkDrop(color: Colors.blue, size: size),
    );
  }
}
