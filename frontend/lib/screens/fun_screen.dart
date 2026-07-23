import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/voice_fab.dart';
import '../widgets/gradient_header.dart';

class FunScreen extends StatelessWidget {
  const FunScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBEB),
      floatingActionButton: const VoiceFab(),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
      body: CustomScrollView(slivers: [
        SliverToBoxAdapter(
          child: GradientHeader(
            colors: AppColors.funGrad,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Fun Hub 🎮', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('Play · Create · Learn', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13)),
                const SizedBox(height: 16),
                // Horizontal chip row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    _chip('Games', Icons.games_rounded, const Color(0xFFD97706)),
                    _chip('Creativity', Icons.brush_rounded, const Color(0xFFDB2777)),
                    _chip('Learn', Icons.school_rounded, const Color(0xFF0284C7)),
                    _chip('Stories', Icons.auto_stories_rounded, const Color(0xFF059669)),
                    _chip('Music', Icons.music_note_rounded, const Color(0xFF7C3AED)),
                  ]),
                ),
              ]),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
          sliver: SliverList(delegate: SliverChildListDelegate([
            _secTitle('Entertainment'),
            const SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.3,
              children: [
                _funCard('🎮', 'Accessible\ngames', 'Voice & touch', const Color(0xFFFEF3C7), const Color(0xFFD97706)),
                _funCard('🧩', 'Trivia &\npuzzles', 'Brain training', const Color(0xFFEDE9FE), const Color(0xFF7C3AED)),
                _funCard('😂', 'Funny\nvideos', 'Laugh daily', const Color(0xFFFCE7F3), const Color(0xFFDB2777)),
                _funCard('🃏', 'Jokes', 'Smile & share', const Color(0xFFD1FAE5), const Color(0xFF059669)),
              ],
            ),
            const SizedBox(height: 20),
            _secTitle('Creativity corner'),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                _crCard('✏️', 'Drawing',  const Color(0xFFEDE9FE), const Color(0xFF7C3AED)),
                _crCard('🤖', 'AI Art',   const Color(0xFFFCE7F3), const Color(0xFFDB2777)),
                _crCard('🪶', 'Poetry',   const Color(0xFFD1FAE5), const Color(0xFF059669)),
                _crCard('📖', 'Story',    const Color(0xFFFEF3C7), const Color(0xFFD97706)),
                _crCard('🎵', 'Music',    const Color(0xFFE0F2FE), const Color(0xFF0284C7)),
                _crCard('📸', 'Photo',    const Color(0xFFFCE7F3), const Color(0xFFDB2777)),
              ]),
            ),
            const SizedBox(height: 20),
            _secTitle('Learn'),
            const SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.3,
              children: [
                _funCard('⠃', 'Braille\nbasics', 'Interactive', const Color(0xFFE0F2FE), const Color(0xFF0284C7)),
                _funCard('🤟', 'Sign\nlanguage', 'Visual guide', const Color(0xFFD1FAE5), const Color(0xFF059669)),
                _funCard('💻', 'Computer\nskills', 'Step by step', const Color(0xFFEDE9FE), const Color(0xFF7C3AED)),
                _funCard('♿', 'Accessibility\ntutorials', 'For everyone', const Color(0xFFFEF3C7), const Color(0xFFD97706)),
              ],
            ),
          ])),
        ),
      ]),
    );
  }

  Widget _chip(String label, IconData icon, Color color) => Container(
    margin: const EdgeInsets.only(right: 8),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, color: Colors.white, size: 14),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
    ]),
  );

  Widget _secTitle(String t) => Text(t, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey));

  Widget _funCard(String emoji, String name, String sub, Color bg, Color accent) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(emoji, style: const TextStyle(fontSize: 28)),
      const Spacer(),
      Text(name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: accent, height: 1.2)),
      Text(sub, style: const TextStyle(fontSize: 10, color: Colors.grey)),
    ]),
  );

  Widget _crCard(String emoji, String name, Color bg, Color accent) => Container(
    width: 90,
    margin: const EdgeInsets.only(right: 10),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(emoji, style: const TextStyle(fontSize: 24)),
      const SizedBox(height: 6),
      Text(name, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: accent)),
    ]),
  );
}
