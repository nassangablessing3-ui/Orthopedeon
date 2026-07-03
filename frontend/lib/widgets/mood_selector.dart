import 'package:flutter/material.dart';
import '../services/api_service.dart';

class MoodSelector extends StatefulWidget {
  const MoodSelector({super.key});
  @override State<MoodSelector> createState() => _MoodSelectorState();
}

class _MoodSelectorState extends State<MoodSelector> {
  int? _selected;
  final _moods = [
    {'score': 1, 'emoji': '😔', 'label': 'Low'},
    {'score': 2, 'emoji': '😐', 'label': 'Okay'},
    {'score': 3, 'emoji': '🙂', 'label': 'Good'},
    {'score': 4, 'emoji': '😄', 'label': 'Great'},
    {'score': 5, 'emoji': '🌟', 'label': 'Amazing'},
  ];

  Future<void> _log(int score, String emoji) async {
    setState(() => _selected = score);
    try {
      await ApiService.logMood(score: score, emoji: emoji);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mood logged! Keep going 💜'), backgroundColor: Color(0xFF7C3AED)));
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _moods.map((m) {
          final sel = _selected == m['score'];
          return GestureDetector(
            onTap: () => _log(m['score'] as int, m['emoji'] as String),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 48, height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: sel ? const Color(0xFFF5EFFE) : Colors.grey[100],
                border: sel ? Border.all(color: const Color(0xFF7C3AED), width: 2) : null,
              ),
              child: Center(child: Text(m['emoji'] as String, style: const TextStyle(fontSize: 22))),
            ),
          );
        }).toList(),
      ),
    );
  }
}
