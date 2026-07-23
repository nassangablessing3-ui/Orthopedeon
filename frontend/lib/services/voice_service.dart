import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:url_launcher/url_launcher.dart';

/// VoiceService — handles all voice activation and OS-level commands.
/// Recognised commands:
///   "call [name]"         → launches tel: URI
///   "open [app]"          → launches app URI / deep link
///   "message [name]"      → opens SMS composer
///   "go to [screen]"      → in-app navigation callback
///   "play music"          → launches music app
///   "take photo"          → launches camera
///   "send emergency"      → dials emergency number
class VoiceService {
  static final VoiceService _i = VoiceService._();
  factory VoiceService() => _i;
  VoiceService._();

  final SpeechToText _stt = SpeechToText();
  final FlutterTts   _tts = FlutterTts();

  bool _listening = false;
  bool get isListening => _listening;

  // Callback the UI sets to handle navigation commands
  void Function(String screen)? onNavigate;
  void Function(String status)?  onStatus;
  void Function(String words)?   onWords;

  // ── Contacts map — populate from user profile in real app ─────────────────
  static const _contacts = {
    'mum':    '+256700000001',
    'dad':    '+256700000002',
    'doctor': '+256700000003',
    'sarah':  '+256700000004',
    'john':   '+256700000005',
    'home':   '+256700000006',
  };

  // ── App URI map ────────────────────────────────────────────────────────────
  static const _apps = {
    'whatsapp':  'whatsapp://send',
    'youtube':   'vnd.youtube://',
    'maps':      'geo:0,0',
    'camera':    'intent://camera',
    'gallery':   'content://media/external/images',
    'music':     'intent://music',
    'settings':  'package:com.android.settings',
    'facebook':  'fb://',
    'twitter':   'twitter://',
    'instagram': 'instagram://',
  };

  Future<void> init() async {
    await _stt.initialize(onError: (e) => onStatus?.call('Error: ${e.errorMsg}'));
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.48);
    await _tts.setVolume(1.0);
  }

  Future<void> speak(String text) async {
    await _tts.stop();
    await _tts.speak(text);
  }

  Future<void> startListening() async {
    if (_listening) return;
    final ok = await _stt.initialize();
    if (!ok) { onStatus?.call('Microphone unavailable'); return; }
    _listening = true;
    onStatus?.call('Listening…');
    _stt.listen(
      onResult: (r) {
        if (r.finalResult) {
          _listening = false;
          onStatus?.call('Processing…');
          _process(r.recognizedWords.toLowerCase().trim());
        } else {
          onWords?.call(r.recognizedWords);
        }
      },
      listenFor: const Duration(seconds: 20),
      pauseFor:  const Duration(seconds: 4),
    );
  }

  Future<void> stopListening() async {
    await _stt.stop();
    _listening = false;
    onStatus?.call('Tap to speak');
  }

  // ── Command processor ──────────────────────────────────────────────────────
  Future<void> _process(String words) async {
    onWords?.call(words);

    // CALL commands
    if (words.startsWith('call ')) {
      final who = words.replaceFirst('call ', '').trim();
      final num = _contacts[who] ?? _contacts.entries
          .firstWhere((e) => who.contains(e.key),
              orElse: () => const MapEntry('', ''))
          .value;
      if (num.isNotEmpty) {
        await speak('Calling $who now.');
        await _launch('tel:$num');
      } else {
        await speak('I don\'t have $who in your contacts yet.');
      }
      onStatus?.call('Done');
      return;
    }

    // MESSAGE commands
    if (words.startsWith('message ') || words.startsWith('text ')) {
      final who = words.replaceFirst(RegExp(r'^(message|text) '), '').trim();
      final num = _contacts[who] ?? '';
      if (num.isNotEmpty) {
        await speak('Opening message to $who.');
        await _launch('sms:$num');
      } else {
        await speak('Contact not found for $who.');
      }
      onStatus?.call('Done');
      return;
    }

    // OPEN APP commands
    if (words.startsWith('open ')) {
      final app = words.replaceFirst('open ', '').trim();
      final uri = _apps[app];
      if (uri != null) {
        await speak('Opening $app.');
        await _launch(uri);
      } else {
        await speak('I\'m not sure how to open $app on this device.');
      }
      onStatus?.call('Done');
      return;
    }

    // NAVIGATE commands
    if (words.contains('go to') || words.contains('open screen') || words.contains('show me')) {
      final screenMap = {
        'home': 'home', 'main': 'home',
        'fun': 'fun', 'games': 'fun', 'play': 'fun',
        'ai': 'ai', 'buddy': 'ai', 'assistant': 'ai',
        'care': 'care', 'wellness': 'care', 'health': 'care',
        'social': 'social', 'community': 'social', 'friends': 'social',
        'profile': 'profile', 'settings': 'profile',
        'voice': 'voice',
      };
      for (final entry in screenMap.entries) {
        if (words.contains(entry.key)) {
          await speak('Going to ${entry.key}.');
          onNavigate?.call(entry.value);
          onStatus?.call('Done');
          return;
        }
      }
    }

    // EMERGENCY
    if (words.contains('emergency') || words.contains('help me') || words.contains('sos')) {
      await speak('Calling emergency services now.');
      await _launch('tel:999');
      onStatus?.call('Done');
      return;
    }

    // PLAY MUSIC
    if (words.contains('play music') || words.contains('play song')) {
      await speak('Opening music.');
      await _launch(_apps['music']!);
      onStatus?.call('Done');
      return;
    }

    // TAKE PHOTO / SELFIE
    if (words.contains('take photo') || words.contains('open camera') || words.contains('selfie')) {
      await speak('Opening camera.');
      await _launch(_apps['camera']!);
      onStatus?.call('Done');
      return;
    }

    // Unknown — respond with AI
    await speak('You said: $words. I\'m working on understanding that better.');
    onStatus?.call('Tap to speak');
  }

  Future<void> _launch(String uri) async {
    try {
      final u = Uri.parse(uri);
      if (await canLaunchUrl(u)) await launchUrl(u, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }
}
