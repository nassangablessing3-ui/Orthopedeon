import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../core/theme.dart';
import '../services/voice_service.dart';

class VoiceScreen extends StatefulWidget {
  const VoiceScreen({super.key});
  @override State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> with TickerProviderStateMixin {
  late AnimationController _pulse;
  late Animation<double> _pulseAnim;
  final _voice = VoiceService();
  String _status = 'Tap the orb — or say a command';
  String _words  = '';
  String _response = '';
  bool _listening = false;

  final _commands = [
    {'icon': Icons.phone_rounded,         'color': Color(0xFF059669), 'label': 'Call Mum',           'cmd': 'call mum'},
    {'icon': Icons.message_rounded,        'color': Color(0xFF0284C7), 'label': 'Message Doctor',     'cmd': 'message doctor'},
    {'icon': Icons.apps_rounded,           'color': Color(0xFF7C3AED), 'label': 'Open WhatsApp',      'cmd': 'open whatsapp'},
    {'icon': Icons.music_note_rounded,     'color': Color(0xFFD97706), 'label': 'Play Music',         'cmd': 'play music'},
    {'icon': Icons.camera_alt_rounded,     'color': Color(0xFFDB2777), 'label': 'Take Photo',         'cmd': 'take photo'},
    {'icon': Icons.map_rounded,            'color': Color(0xFFBE123C), 'label': 'Open Maps',          'cmd': 'open maps'},
    {'icon': Icons.home_rounded,           'color': Color(0xFF4A1B8A), 'label': 'Go to Home',         'cmd': 'go to home'},
    {'icon': Icons.games_rounded,          'color': Color(0xFFD97706), 'label': 'Go to Fun',          'cmd': 'go to fun'},
    {'icon': Icons.emergency_rounded,      'color': Color(0xFFDC2626), 'label': 'Emergency',          'cmd': 'emergency help me'},
    {'icon': Icons.translate_rounded,      'color': Color(0xFF0891B2), 'label': 'Translate',          'cmd': 'translate text'},
  ];

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat(reverse: true);
    _pulseAnim = Tween(begin: 1.0, end: 1.18).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));

    _voice.onStatus   = (s) => setState(() => _status = s);
    _voice.onWords    = (w) => setState(() => _words  = w);
    _voice.onNavigate = (screen) {
      if (mounted) context.go('/$screen');
    };
  }

  @override
  void dispose() { _pulse.dispose(); super.dispose(); }

  Future<void> _toggle() async {
    if (_listening) {
      await _voice.stopListening();
      setState(() => _listening = false);
    } else {
      setState(() { _listening = true; _words = ''; _response = ''; });
      await _voice.startListening();
      // After processing, update UI
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) setState(() => _listening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Color(0xFF4C0519), Color(0xFF0D0630)])),
        child: SafeArea(
          child: Column(children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(children: [
                GestureDetector(
                  onTap: () => context.go('/home'),
                  child: Container(
                    width: 38, height: 38,
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20)),
                ),
                const SizedBox(width: 12),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Voice Control', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                  Text('Full device & app control', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                ]),
              ]),
            ),
            const SizedBox(height: 24),
            // Orb
            AnimatedBuilder(
              animation: _pulseAnim,
              builder: (_, child) => Transform.scale(
                scale: _listening ? _pulseAnim.value : 1.0, child: child),
              child: GestureDetector(
                onTap: _toggle,
                child: Container(
                  width: 140, height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(colors: _listening
                      ? [const Color(0xFFBE123C), const Color(0xFF4C0519)]
                      : [const Color(0xFF7C3AED), const Color(0xFF1A0B3B)]),
                    boxShadow: [BoxShadow(
                      color: (_listening ? const Color(0xFFBE123C) : const Color(0xFF7C3AED)).withOpacity(0.5),
                      blurRadius: 32, spreadRadius: 4)],
                  ),
                  child: Icon(_listening ? Icons.mic_rounded : Icons.mic_none_rounded, color: Colors.white, size: 56),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(_status, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13)),
            if (_words.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
                  child: Text('You: $_words', style: const TextStyle(color: Colors.white, fontSize: 13)),
                ),
              ),
            const SizedBox(height: 8),
            // Command grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Quick commands', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11, letterSpacing: 0.5)),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 2.8),
                  itemCount: _commands.length,
                  itemBuilder: (_, i) {
                    final c = _commands[i];
                    return GestureDetector(
                      onTap: () {
                        setState(() { _words = c['cmd'] as String; _status = 'Processing…'; });
                        _voice.startListening();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.07),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white.withOpacity(0.1))),
                        child: Row(children: [
                          Container(width: 32, height: 32, decoration: BoxDecoration(
                            color: (c['color'] as Color).withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                            child: Icon(c['icon'] as IconData, color: c['color'] as Color, size: 18)),
                          const SizedBox(width: 8),
                          Expanded(child: Text(c['label'] as String, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500))),
                        ]),
                      ),
                    );
                  },
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
