import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class JoyScreen extends StatelessWidget {
  const JoyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const amber = Color(0xFF854F0B);
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          pinned: true, expandedHeight: 120,
          backgroundColor: amber,
          leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => context.go('/dashboard')),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: amber,
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 16),
              child: const Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [
                Text('Joy Center', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500)),
                Text('Play, learn & celebrate', style: TextStyle(color: Colors.white70, fontSize: 13)),
              ]),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(delegate: SliverChildListDelegate([
            // Daily challenge
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: amber, borderRadius: BorderRadius.circular(14)),
              child: Row(children: [
                const Icon(Icons.emoji_events, color: Color(0xFFFAC775), size: 36),
                const SizedBox(width: 14),
                const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Daily challenge', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                  SizedBox(height: 3),
                  Text('Listen to a 5-min story and answer one question', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ])),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.white.withOpacity(0.15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  child: const Text('Start', style: TextStyle(fontSize: 12)),
                ),
              ]),
            ),
            const SizedBox(height: 20),
            const Text('Entertainment', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey, letterSpacing: 0.4)),
            const SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.5,
              children: const [
                _JoyCard(emoji: '🎮', name: 'Accessible games', sub: 'Voice & touch play'),
                _JoyCard(emoji: '📚', name: 'Audiobooks', sub: '1,000+ titles'),
                _JoyCard(emoji: '🎙️', name: 'Podcasts', sub: 'Disability & life'),
                _JoyCard(emoji: '🎵', name: 'Relaxing sounds', sub: 'Sleep & focus'),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Achievements', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey, letterSpacing: 0.4)),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: const [
                _AchievementBadge(icon: Icons.local_fire_department, label: '7-day streak', earned: true),
                SizedBox(width: 12),
                _AchievementBadge(icon: Icons.mic, label: 'First voice task', earned: true),
                SizedBox(width: 12),
                _AchievementBadge(icon: Icons.people, label: 'Joined a group', earned: true),
                SizedBox(width: 12),
                _AchievementBadge(icon: Icons.star, label: '500 points', earned: false),
                SizedBox(width: 12),
                _AchievementBadge(icon: Icons.favorite, label: '30-day wellness', earned: false),
              ]),
            ),
            const SizedBox(height: 80),
          ])),
        ),
      ]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        selectedItemColor: amber,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (i) { const r = ['/dashboard', '/social', '/wellness', '/joy', '/voice']; context.go(r[i]); },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Social'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Wellness'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Joy'),
          BottomNavigationBarItem(icon: Icon(Icons.mic), label: 'AI'),
        ],
      ),
    );
  }
}

class _JoyCard extends StatelessWidget {
  final String emoji, name, sub;
  const _JoyCard({required this.emoji, required this.name, required this.sub});
  @override Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey[200]!)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(emoji, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 6),
        Text(name, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
        Text(sub, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
      ]),
    );
  }
}

class _AchievementBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool earned;
  const _AchievementBadge({required this.icon, required this.label, required this.earned});
  @override Widget build(BuildContext context) {
    return Column(children: [
      Container(
        width: 56, height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: earned ? const Color(0xFFFAEEDA) : Colors.grey[100],
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Icon(icon, color: earned ? const Color(0xFF854F0B) : Colors.grey[300], size: 26),
      ),
      const SizedBox(height: 6),
      SizedBox(width: 70, child: Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[500]), textAlign: TextAlign.center, maxLines: 2)),
    ]);
  }
}
