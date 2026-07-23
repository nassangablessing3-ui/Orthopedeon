import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../widgets/app_bottom_nav.dart';
import '../services/api_service.dart';

class AiScreen extends StatefulWidget {
  const AiScreen({super.key});
  @override State<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends State<AiScreen> with TickerProviderStateMixin {
  late AnimationController _pulse;
  late Animation<double> _pulseAnim;
  bool _loading = false;
  String _response = 'Your AI Buddy is ready! Ask anything — I\'m here to help you learn, laugh, and thrive. 💙';
  final _chips = ['Tell a joke 😄', 'Help with homework 📚', 'Translate text 🌍', 'Read document 📄', 'Describe image 🖼️', 'Write a story ✍️'];

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat(reverse: true);
    _pulseAnim = Tween(begin: 1.0, end: 1.12).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _pulse.dispose(); super.dispose(); }

  Future<void> _ask(String text) async {
    setState(() { _loading = true; _response = '…'; });
    try {
      final r = await ApiService.voiceCommand(text: text, context: 'ai_screen');
      setState(() { _response = r['response_text'] ?? 'Got it! Let me help.'; _loading = false; });
    } catch (_) {
      const fallbacks = {
        'Tell a joke': 'Why did the scarecrow win an award? Because he was outstanding in his field! 😄',
        'Help with homework': 'I\'d love to help! Which subject — Maths, Science, English, or another?',
        'Translate text': 'I can translate to Luganda, French, Swahili, Arabic, and many more. What would you like?',
        'Read document': 'Send me any document and I\'ll read and summarise it for you! 📄',
        'Describe image': 'I can describe images in full detail to help you understand what\'s in them. 🖼️',
        'Write a story': 'I\'d love to write a story! Give me a theme and I\'ll craft something magical. ✍️',
      };
      final key = fallbacks.keys.firstWhere((k) => text.toLowerCase().contains(k.toLowerCase()), orElse: () => '');
      setState(() { _response = key.isNotEmpty ? fallbacks[key]! : 'I\'m here to help! Tell me more about what you need.'; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.center,
            colors: [Color(0xFF0C4A6E), Color(0xFFF8F7FF)])),
        child: SafeArea(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('AI Buddy 🤖', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700)),
                Text('Your smart, caring companion', style: TextStyle(color: Colors.white.withOpacity(0.65), fontSize: 13)),
              ]),
            ),
            const SizedBox(height: 24),
            AnimatedBuilder(
              animation: _pulseAnim,
              builder: (_, child) => Transform.scale(scale: _loading ? _pulseAnim.value : 1.0, child: child),
              child: GestureDetector(
                onTap: () => _ask('Hello, what can you help me with?'),
                child: Container(
                  width: 120, height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(colors: [Color(0xFF0284C7), Color(0xFF0C4A6E)]),
                    boxShadow: [BoxShadow(color: const Color(0xFF0284C7).withOpacity(0.4), blurRadius: 28, spreadRadius: 4)]),
                  child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 52)),
              ),
            ),
            const SizedBox(height: 8),
            Text(_loading ? 'Thinking…' : 'Tap the orb or choose below',
              style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
            const SizedBox(height: 16),
            // Quick chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(spacing: 8, runSpacing: 8, children: _chips.map((c) => GestureDetector(
                onTap: () => _ask(c),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF0284C7).withOpacity(0.2))),
                  child: Text(c, style: const TextStyle(fontSize: 12, color: Color(0xFF0C4A6E), fontWeight: FontWeight.w500))),
              )).toList()),
            ),
            const SizedBox(height: 16),
            // Response
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade200)),
                  child: _loading
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFF0284C7), strokeWidth: 2))
                    : SingleChildScrollView(child: Text(_response, style: const TextStyle(fontSize: 14, height: 1.6, color: Color(0xFF0C4A6E)))),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ]),
        ),
      ),
    );
  }
}
