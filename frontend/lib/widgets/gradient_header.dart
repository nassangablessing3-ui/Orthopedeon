import 'package:flutter/material.dart';

class GradientHeader extends StatelessWidget {
  final List<Color> colors;
  final Widget child;
  final double height;
  const GradientHeader({super.key, required this.colors, required this.child, this.height = 220});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: height),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: colors),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28)),
      ),
      child: SafeArea(bottom: false, child: child),
    );
  }
}
