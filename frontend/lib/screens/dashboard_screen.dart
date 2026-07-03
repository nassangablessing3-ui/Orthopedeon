import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/api_service.dart';
import '../widgets/mood_selector.dart';
import '../widgets/feature_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            backgroundColor: const Color(0xFF1A0B3B),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                decoration: const BoxDecoration(color: Color(0xFF1A0B3B)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text('Good morning 👋', style: TextStyle(color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 4),
                    const Text('Welcome back', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 12),
                    Row(children: [
                      _badge(Icons.local_fire_department, '7-day streak'),
                      const SizedBox(width: 8),
                      _badge(Icons.star, '320 pts'),
                    ]),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white70),
                onPressed: () async { await ApiService.logout(); context.go('/login'); },
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(delegate: SliverChildListDelegate([
              // Voice assistant CTA
              GestureDetector(
                onTap: () => context.go('/voice'),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C3AED),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(children: [
                    Icon(Icons.mic, color: Color(0xFFC8A8F8), size: 32),
                    SizedBox(width: 14),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('AI Voice Assistant', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
                      Text('Tap to speak — I\'m listening', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ])),
                    Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
                  ]),
                ),
              ),
              const SizedBox(height: 20),
              const Text('How are you feeling?', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey)),
              const SizedBox(height: 10),
              const MoodSelector(),
              const SizedBox(height: 20),
              const Text('Features', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey)),
              const SizedBox(height: 10),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.4,
                children: const [
                  FeatureCard(label: 'Wellness', sub: 'Mood · Goals · Breathing', icon: Icons.favorite, color: Color(0xFF0F6E56), bgColor: Color(0xFFE1F5EE), route: '/wellness'),
                  FeatureCard(label: 'Social Hub', sub: 'Groups · Chat · Events', icon: Icons.people, color: Color(0xFF185FA5), bgColor: Color(0xFFE6F1FB), route: '/social'),
                  FeatureCard(label: 'Joy Center', sub: 'Games · Audiobooks', icon: Icons.celebration, color: Color(0xFF854F0B), bgColor: Color(0xFFFAEEDA), route: '/joy'),
                  FeatureCard(label: 'Accessibility', sub: 'OCR · Voice · Captions', icon: Icons.document_scanner, color: Color(0xFF7C3AED), bgColor: Color(0xFFF0E8FF), route: '/voice'),
                ],
              ),
              const SizedBox(height: 80),
            ])),
          ),
        ],
      ),
      bottomNavigationBar: _BottomNav(currentIndex: 0),
    );
  }

  Widget _badge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: Colors.white70, size: 14),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ]),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  const _BottomNav({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: const Color(0xFF7C3AED),
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      onTap: (i) {
        const routes = ['/dashboard', '/social', '/wellness', '/joy', '/voice'];
        context.go(routes[i]);
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Social'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Wellness'),
        BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Joy'),
        BottomNavigationBarItem(icon: Icon(Icons.mic), label: 'AI'),
      ],
    );
  }
}
