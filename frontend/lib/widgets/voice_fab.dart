import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VoiceFab extends StatelessWidget {
  const VoiceFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => context.go('/voice'),
      backgroundColor: const Color(0xFFBE123C),
      tooltip: 'Voice control',
      child: const Icon(Icons.mic_rounded, color: Colors.white, size: 28),
    );
  }
}
