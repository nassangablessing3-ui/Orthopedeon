import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../services/api_service.dart';

class VoiceScreen extends StatefulWidget {
  const VoiceScreen({super.key});
  @override State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> with SingleTickerProviderStateMixin {
  final _stt = SpeechToText();
  final _tts = FlutterTts();
  bool _listening = false;
  String _transcript = '';
  String _response = '';
  bool _loading = false;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))
      ..repeat(reverse: true);
    _pulse = Tween(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
    _tts.setLanguage('en-US');
    _tts.setSpeechRate(0.5);
  }

  @override
  void dispose() { _pulseCtrl.dispose(); super.dispose(); }

  Future<void> _toggleListen() async {
    if (_listening) {
      await _stt.stop();
      setState(() => _listening = false);
      if (_transcript.isNotEmpty) await _sendCommand(_transcript);
      return;
    }
    final available = await _stt.initialize();
    if (!available) {
      setState(() => _response = 'Microphone not available.');
      return;
    }
    setState(() { _listening = true; _transcript = ''; _response = ''; });
    _stt.listen(
      onResult: (r) => setState(() => _transcript = r.recognizedWords),
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 4),
      onSoundLevelChange: (_) {},
    );
  }

  Future<void> _sendCommand(String text) async {
    setState(() { _loading = true; _listening = false; });
    try {
      final result = await ApiService.voiceCommand(text: text, context: 'voice_screen');
      final responseText = result['response_text'] ?? 'Done.';
      setState(() { _response = responseText; _loading = false; });
      await _tts.speak(responseText);
    } catch (e) {
      setState(() { _response = 'Could not connect to server.'; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0B3B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/dashboard'),
        ),
        title: const Text('AI Voice Assistant', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            Text(
              _listening ? 'Listening…' : (_loading ? 'Processing…' : 'Tap to speak'),
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: _toggleListen,
              child: AnimatedBuilder(
                animation: _pulse,
                builder: (_, child) => Transform.scale(
                  scale: _listening ? _pulse.value : 1.0,
                  child: child,
                ),
                child: Container(
                  width: 140, height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _listening ? const Color(0xFF7C3AED) : const Color(0xFF2D1463),
                    border: Border.all(color: const Color(0xFF7C3AED).withOpacity(0.5), width: 2),
                    boxShadow: _listening ? [BoxShadow(color: const Color(0xFF7C3AED).withOpacity(0.4), blurRadius: 30, spreadRadius: 10)] : [],
                  ),
                  child: Icon(
                    _listening ? Icons.mic : Icons.mic_none,
                    color: const Color(0xFFC8A8F8),
                    size: 56,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            if (_transcript.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text('You: $_transcript',
                  style: const TextStyle(color: Colors.white70, fontSize: 14)),
              ),
            if (_response.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text('AI: $_response',
                  style: const TextStyle(color: Color(0xFFC8A8F8), fontSize: 14, height: 1.5)),
              ),
            ],
            if (_loading) const Padding(
              padding: EdgeInsets.only(top: 16),
              child: CircularProgressIndicator(color: Color(0xFFC8A8F8), strokeWidth: 2),
            ),
            const Spacer(),
            Row(children: [
              Expanded(child: _quickBtn(Icons.volume_up, 'Read screen', () => _sendCommand('Read the current screen content aloud'))),
              const SizedBox(width: 10),
              Expanded(child: _quickBtn(Icons.send, 'Send message', () => _sendCommand('Help me send a message'))),
              const SizedBox(width: 10),
              Expanded(child: _quickBtn(Icons.alarm, 'Set reminder', () => _sendCommand('Set a reminder'))),
            ]),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _quickBtn(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.12)),
        ),
        child: Column(children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10), textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}
