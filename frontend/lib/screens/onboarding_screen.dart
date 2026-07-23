import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with TickerProviderStateMixin {
  final Set<int> _selected = {};
  late AnimationController _headerCtrl;
  late Animation<double> _headerAnim;

  final _options = [
    {'emoji': '👁️',  'label': 'Visual impairment',   'sub': 'Blind or low vision',           'color': Color(0xFF0284C7), 'bg': Color(0xFFE0F2FE)},
    {'emoji': '👂',  'label': 'Hearing impairment',   'sub': 'Deaf or hard of hearing',       'color': Color(0xFF059669), 'bg': Color(0xFFD1FAE5)},
    {'emoji': '♿',  'label': 'Mobility support',      'sub': 'Limited movement',              'color': Color(0xFF7C3AED), 'bg': Color(0xFFEDE9FE)},
    {'emoji': '🧠',  'label': 'Cognitive support',    'sub': 'Memory or learning',            'color': Color(0xFFDB2777), 'bg': Color(0xFFFCE7F3)},
    {'emoji': '💛',  'label': 'Mental wellness',      'sub': 'Mood & emotional health',       'color': Color(0xFFD97706), 'bg': Color(0xFFFEF3C7)},
    {'emoji': '🤝',  'label': 'Social connection',    'sub': 'Meeting & making friends',      'color': Color(0xFFBE123C), 'bg': Color(0xFFFFE4E6)},
  ];

  @override
  void initState() {
    super.initState();
    _headerCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _headerAnim = CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOut);
    _headerCtrl.forward();
  }

  @override
  void dispose() { _headerCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FF),
      body: Column(children: [
        // ── TOP HALF — App icon + branding ────────────────────────────────
        FadeTransition(
          opacity: _headerAnim,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.38,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [Color(0xFF0D0630), Color(0xFF2D1463), Color(0xFF5B2D8E)]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(36), bottomRight: Radius.circular(36))),
            child: SafeArea(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                // Large icon fills the top half
                Container(
                  width: 100, height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [BoxShadow(color: const Color(0xFF7C3AED).withOpacity(0.5), blurRadius: 28, spreadRadius: 4)]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(26),
                    child: Image.asset('assets/icons/app_icon.png', fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFFEC4899)])),
                        child: const Icon(Icons.accessibility_new, color: Colors.white, size: 52)))),
                ),
                const SizedBox(height: 16),
                const Text('Orth_pedeon', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700, letterSpacing: -0.5)),
                const SizedBox(height: 6),
                Text('Independence · Connection · Joy', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13, letterSpacing: 0.3)),
              ]),
            ),
          ),
        ),

        // ── BOTTOM HALF — Tell us about yourself ─────────────────────────
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Tell us about yourself', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF1A0B3B))),
              const SizedBox(height: 4),
              Text('Select all that apply — we personalise everything for you.', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              const SizedBox(height: 14),
              Expanded(
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.55),
                  itemCount: _options.length,
                  itemBuilder: (_, i) {
                    final opt = _options[i];
                    final sel = _selected.contains(i);
                    final color = opt['color'] as Color;
                    final bg    = opt['bg']    as Color;
                    return GestureDetector(
                      onTap: () => setState(() => sel ? _selected.remove(i) : _selected.add(i)),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: sel ? bg : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: sel ? color : Colors.grey.shade200, width: sel ? 2 : 1),
                          boxShadow: sel ? [BoxShadow(color: color.withOpacity(0.18), blurRadius: 10, offset: const Offset(0, 4))] : [],
                        ),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(opt['emoji'] as String, style: const TextStyle(fontSize: 26)),
                            if (sel) Container(
                              width: 20, height: 20,
                              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                              child: const Icon(Icons.check, color: Colors.white, size: 13)),
                          ]),
                          const SizedBox(height: 6),
                          Text(opt['label'] as String, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: sel ? color : const Color(0xFF1A0B3B))),
                          const SizedBox(height: 2),
                          Text(opt['sub'] as String, style: TextStyle(fontSize: 10, color: Colors.grey.shade500, height: 1.3)),
                        ]),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go('/home'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C3AED),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    shadowColor: const Color(0xFF7C3AED).withOpacity(0.4)),
                  child: const Text('Get started →', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: GestureDetector(
                  onTap: () => context.go('/home'),
                  child: Text('Skip — explore the app first',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500, decoration: TextDecoration.underline)),
                ),
              ),
              const SizedBox(height: 16),
            ]),
          ),
        ),
      ]),
    );
  }
}
