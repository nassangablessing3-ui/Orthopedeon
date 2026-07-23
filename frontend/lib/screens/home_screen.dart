import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/voice_fab.dart';
import '../widgets/gradient_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _mood = -1;
  final _moods = [
    {'e': '😔', 'l': 'Low',     'm': 'Sending you extra love today 💜'},
    {'e': '😐', 'l': 'Okay',    'm': 'Steady days matter. You\'ve got this!'},
    {'e': '🙂', 'l': 'Good',    'm': 'Wonderful! Keep that energy going 🌟'},
    {'e': '😄', 'l': 'Great',   'm': 'You\'re doing amazing — keep shining! ✨'},
    {'e': '🌟', 'l': 'Amazing', 'm': 'You\'re absolutely glowing today! 🌈'},
  ];

  void _selectMood(int i) {
    setState(() => _mood = i);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(_moods[i]['m']!),
      backgroundColor: AppColors.home,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FF),
      floatingActionButton: const VoiceFab(),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
      body: CustomScrollView(slivers: [
        SliverToBoxAdapter(
          child: GradientHeader(
            colors: AppColors.homeGrad,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Good morning 🌅', style: TextStyle(color: Colors.white.withOpacity(0.65), fontSize: 13)),
                    const SizedBox(height: 4),
                    const Text('Hello, Amara!', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600)),
                  ]),
                  GestureDetector(
                    onTap: () => context.go('/profile'),
                    child: Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                        gradient: const LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFFEC4899)])),
                      child: const Center(child: Text('A', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600))),
                    ),
                  ),
                ]),
                const SizedBox(height: 16),
                Text('How are you feeling today?', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13)),
                const SizedBox(height: 10),
                Row(
                  children: List.generate(_moods.length, (i) => Expanded(
                    child: GestureDetector(
                      onTap: () => _selectMood(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: _mood == i ? Colors.white.withOpacity(0.25) : Colors.white.withOpacity(0.1),
                          border: Border.all(color: _mood == i ? Colors.white.withOpacity(0.6) : Colors.white.withOpacity(0.15)),
                        ),
                        child: Column(children: [
                          Text(_moods[i]['e']!, style: const TextStyle(fontSize: 22)),
                          const SizedBox(height: 3),
                          Text(_moods[i]['l']!, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 9)),
                        ]),
                      ),
                    ),
                  )),
                ),
              ]),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
          sliver: SliverList(delegate: SliverChildListDelegate([
            // Voice command hint
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF4C0519), Color(0xFFBE123C)]),
                borderRadius: BorderRadius.circular(16)),
              child: Row(children: [
                const Icon(Icons.mic_rounded, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Voice Control', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                  Text('Say "Call Mum" · "Open WhatsApp" · "Go to Fun"', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11)),
                ])),
                GestureDetector(
                  onTap: () => context.go('/voice'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                    child: const Text('Open', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 20),
            // Song of the day
            _sectionTitle('Song of the day'),
            const SizedBox(height: 8),
            _songCard(),
            const SizedBox(height: 20),
            // Quick actions
            _sectionTitle('Quick actions'),
            const SizedBox(height: 8),
            GridView.count(
              shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.5,
              children: [
                _qaCard('AI Buddy', 'Ask anything', Icons.smart_toy_rounded, AppColors.ai, const Color(0xFFE6F1FB), '/ai'),
                _qaCard('Fun Hub', 'Play & create', Icons.games_rounded, AppColors.fun, const Color(0xFFFEF3C7), '/fun'),
                _qaCard('Care', 'Health & reminders', Icons.favorite_rounded, AppColors.care, const Color(0xFFD1FAE5), '/care'),
                _qaCard('Social', 'Friends & community', Icons.people_rounded, AppColors.social, const Color(0xFFFCE7F3), '/social'),
              ],
            ),
            const SizedBox(height: 20),
            // Verse of the week
            _sectionTitle('Verse of the week'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: AppColors.careGrad),
                borderRadius: BorderRadius.circular(16)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('ENCOURAGEMENT', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 10, letterSpacing: 1)),
                const SizedBox(height: 8),
                const Text('"I can do all things through Christ who strengthens me."',
                  style: TextStyle(color: Colors.white, fontSize: 14, fontStyle: FontStyle.italic, height: 1.5)),
                const SizedBox(height: 6),
                Text('— Philippians 4:13', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
              ]),
            ),
            const SizedBox(height: 20),
            // Daily challenge
            _sectionTitle('Daily challenge'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200)),
              child: Row(children: [
                Container(width: 44, height: 44, decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.emoji_events_rounded, color: Color(0xFFD97706), size: 24)),
                const SizedBox(width: 12),
                const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Listen to today\'s story', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  Text('5 minutes · +20 pts', style: TextStyle(fontSize: 11, color: Colors.grey)),
                ])),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(10)),
                  child: const Text('+20', style: TextStyle(color: Color(0xFFD97706), fontWeight: FontWeight.w600, fontSize: 13)),
                ),
              ]),
            ),
          ])),
        ),
      ]),
    );
  }

  Widget _sectionTitle(String t) => Text(t, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey, letterSpacing: 0.3));

  Widget _songCard() => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
    child: Row(children: [
      Container(width: 52, height: 52, decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFFEC4899)]),
        borderRadius: BorderRadius.circular(12)),
        child: const Icon(Icons.music_note_rounded, color: Colors.white, size: 26)),
      const SizedBox(width: 12),
      const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('You Are Loved', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        Text('Stars Go Dim', style: TextStyle(fontSize: 12, color: Colors.grey)),
      ])),
      Container(width: 38, height: 38, decoration: BoxDecoration(color: AppColors.home, shape: BoxShape.circle),
        child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 22)),
    ]),
  );

  Widget _qaCard(String label, String sub, IconData icon, Color color, Color bg, String route) => GestureDetector(
    onTap: () => context.go(route),
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 36, height: 36, decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 20)),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        Text(sub, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ]),
    ),
  );
}
