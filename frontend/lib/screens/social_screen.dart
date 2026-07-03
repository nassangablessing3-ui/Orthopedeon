import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/api_service.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});
  @override State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  List<dynamic> _groups = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    try {
      final groups = await ApiService.getGroups();
      setState(() { _groups = groups; _loading = false; });
    } catch (_) {
      // show fallback data if API not connected
      setState(() {
        _loading = false;
        _groups = [
          {'id': '1', 'name': 'Low Vision Connect', 'description': 'Share tips and experiences', 'category': 'visual', 'member_count': '1200'},
          {'id': '2', 'name': 'Mobility Warriors', 'description': 'Adaptive sports, tech hacks, and daily wins', 'category': 'mobility', 'member_count': '876'},
          {'id': '3', 'name': 'Memory & Learning', 'description': 'Cognitive tools and peer support', 'category': 'cognitive', 'member_count': '540'},
          {'id': '4', 'name': 'Deaf Music Lovers', 'description': 'Rhythm felt, not just heard', 'category': 'hearing', 'member_count': '318'},
        ];
      });
    }
  }

  final _catIcons = {
    'visual': Icons.visibility,
    'hearing': Icons.hearing,
    'mobility': Icons.accessible,
    'cognitive': Icons.psychology,
    'mental_wellness': Icons.favorite,
    'general': Icons.people,
  };

  final _catColors = {
    'visual': const Color(0xFF185FA5),
    'hearing': const Color(0xFF993C1D),
    'mobility': const Color(0xFF0F6E56),
    'cognitive': const Color(0xFF993556),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Hub'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go('/dashboard')),
        actions: [const Icon(Icons.search, color: Colors.grey), const SizedBox(width: 12)],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _groups.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final g = _groups[i];
                  final cat = g['category'] ?? 'general';
                  final color = _catColors[cat] ?? const Color(0xFF7C3AED);
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                        child: Icon(_catIcons[cat] ?? Icons.people, color: color, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(g['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                        const SizedBox(height: 3),
                        Text(g['description'] ?? '', style: TextStyle(color: Colors.grey[500], fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 6),
                        Row(children: [
                          const Icon(Icons.people_outline, size: 12, color: Colors.grey),
                          const SizedBox(width: 3),
                          Text('${g['member_count']} members', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                        ]),
                      ])),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          if (g['id'] != null) ApiService.joinGroup(g['id'].toString());
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Joined ${g['name']}!'), backgroundColor: const Color(0xFF7C3AED)));
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          textStyle: const TextStyle(fontSize: 12),
                        ),
                        child: const Text('Join'),
                      ),
                    ]),
                  );
                },
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: const Color(0xFF185FA5),
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
