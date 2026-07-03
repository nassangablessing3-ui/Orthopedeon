import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final List<String> _selected = [];

  final _options = [
    {'key': 'visual',          'label': 'Visual impairment',   'sub': 'Blind or low vision',         'icon': Icons.visibility_off},
    {'key': 'hearing',         'label': 'Hearing impairment',  'sub': 'Deaf or hard of hearing',     'icon': Icons.hearing_disabled},
    {'key': 'mobility',        'label': 'Mobility impairment', 'sub': 'Limited hand or body movement','icon': Icons.accessible},
    {'key': 'cognitive',       'label': 'Cognitive support',   'sub': 'Memory or learning',           'icon': Icons.psychology},
    {'key': 'mental_wellness', 'label': 'Mental wellness',     'sub': 'Mood & emotional health',     'icon': Icons.favorite},
    {'key': 'social',          'label': 'Social connection',   'sub': 'Meeting others',              'icon': Icons.people},
  ];

  void _toggle(String key) {
    setState(() {
      if (_selected.contains(key)) _selected.remove(key);
      else _selected.add(key);
    });
  }

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF7C3AED);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text('Tell us about yourself',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Text('We personalise Orth_pedeon around your needs.',
                style: TextStyle(color: Colors.grey[600], fontSize: 14)),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12,
                  childAspectRatio: 1.35,
                  children: _options.map((opt) {
                    final selected = _selected.contains(opt['key']);
                    return GestureDetector(
                      onTap: () => _toggle(opt['key'] as String),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: selected ? purple : Colors.grey[300]!,
                            width: selected ? 1.5 : 1,
                          ),
                          color: selected ? const Color(0xFFF5EFFE) : Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(opt['icon'] as IconData, color: purple, size: 26),
                            const SizedBox(height: 8),
                            Text(opt['label'] as String,
                              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                            const SizedBox(height: 2),
                            Text(opt['sub'] as String,
                              style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go('/register',
                      extra: {'disability_types': _selected}),
                  child: const Text('Continue'),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () => context.go('/login'),
                  child: const Text('Already have an account? Sign in',
                    style: TextStyle(color: Color(0xFF7C3AED))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
