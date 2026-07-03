import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/api_service.dart';

class WellnessScreen extends StatefulWidget {
  const WellnessScreen({super.key});
  @override State<WellnessScreen> createState() => _WellnessScreenState();
}

class _WellnessScreenState extends State<WellnessScreen> with SingleTickerProviderStateMixin {
  final _journalCtrl = TextEditingController();
  bool _breathing = false;
  bool _inhale = true;
  late AnimationController _breathCtrl;
  late Animation<double> _breathAnim;

  @override
  void initState() {
    super.initState();
    _breathCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 4));
    _breathAnim = Tween(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(parent: _breathCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _breathCtrl.dispose(); _journalCtrl.dispose(); super.dispose(); }

  void _toggleBreath() {
    setState(() => _breathing = !_breathing);
    if (_breathing) _runBreath();
    else { _breathCtrl.stop(); _breathCtrl.reset(); }
  }

  void _runBreath() async {
    if (!_breathing) return;
    setState(() => _inhale = true);
    await _breathCtrl.forward();
    if (!_breathing) return;
    await Future.delayed(const Duration(seconds: 7));
    if (!_breathing) return;
    setState(() => _inhale = false);
    _breathCtrl.duration = const Duration(seconds: 8);
    await _breathCtrl.reverse();
    _breathCtrl.duration = const Duration(seconds: 4);
    if (_breathing) _runBreath();
  }

  Future<void> _saveJournal() async {
    if (_journalCtrl.text.trim().isEmpty) return;
    try {
      await ApiService.saveJournal(content: _journalCtrl.text.trim());
      _journalCtrl.clear();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Journal saved 💚'), backgroundColor: Color(0xFF0F6E56)));
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF0F6E56);
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          pinned: true, expandedHeight: 140,
          backgroundColor: teal,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.go('/dashboard'),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: teal,
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [
                const Text('Mental Wellness', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500)),
                const Text('Your daily wellbeing centre', style: TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                  child: const Row(children: [
                    Icon(Icons.local_fire_department, color: Color(0xFF9FE1CB), size: 20),
                    SizedBox(width: 8),
                    Text('7-day streak', style: TextStyle(color: Colors.white70, fontSize: 13)),
                    Spacer(),
                    Text('7', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
                  ]),
                ),
              ]),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(delegate: SliverChildListDelegate([
            // Breathing
            _card(child: Column(children: [
              const Row(children: [
                Icon(Icons.air, color: teal, size: 20),
                SizedBox(width: 8),
                Text('Breathing exercise', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
              ]),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _toggleBreath,
                child: AnimatedBuilder(
                  animation: _breathAnim,
                  builder: (_, __) => Transform.scale(
                    scale: _breathing ? _breathAnim.value : 1.0,
                    child: Container(
                      width: 90, height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFE1F5EE),
                        border: Border.all(color: teal, width: 2),
                      ),
                      child: Center(child: Text(
                        _breathing ? (_inhale ? 'Inhale' : 'Exhale') : 'Start',
                        style: const TextStyle(color: teal, fontWeight: FontWeight.w500, fontSize: 13))),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(_breathing ? '4-7-8 breathing active — tap to stop' : 'Tap to begin 4-7-8 breathing',
                style: TextStyle(color: Colors.grey[500], fontSize: 12)),
            ])),
            const SizedBox(height: 14),
            // Goals
            _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Row(children: [
                Icon(Icons.track_changes, color: teal, size: 20),
                SizedBox(width: 8),
                Text("Today's goals", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
              ]),
              const SizedBox(height: 14),
              _goalRow(Icons.water_drop, 'Hydration', 0.75),
              const SizedBox(height: 10),
              _goalRow(Icons.directions_walk, 'Movement', 0.40),
              const SizedBox(height: 10),
              _goalRow(Icons.wb_sunny, 'Sunlight', 1.0),
            ])),
            const SizedBox(height: 14),
            // Journal
            _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Row(children: [
                Icon(Icons.edit_note, color: teal, size: 20),
                SizedBox(width: 8),
                Text('Gratitude journal', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
              ]),
              const SizedBox(height: 12),
              TextField(
                controller: _journalCtrl,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'What are you grateful for today?',
                  hintStyle: TextStyle(fontSize: 13),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(width: double.infinity, child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: teal),
                onPressed: _saveJournal,
                child: const Text('Save entry'),
              )),
            ])),
            const SizedBox(height: 80),
          ])),
        ),
      ]),
      bottomNavigationBar: _buildNav(context),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: child,
    );
  }

  Widget _goalRow(IconData icon, String label, double progress) {
    return Row(children: [
      Container(width: 32, height: 32, decoration: const BoxDecoration(color: Color(0xFFE1F5EE), shape: BoxShape.circle),
        child: Icon(icon, size: 16, color: const Color(0xFF0F6E56))),
      const SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          Text('${(progress * 100).round()}%', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
        ]),
        const SizedBox(height: 4),
        LinearProgressIndicator(value: progress, backgroundColor: Colors.grey[200], color: const Color(0xFF0F6E56), borderRadius: BorderRadius.circular(4)),
      ])),
    ]);
  }

  BottomNavigationBar _buildNav(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 2,
      selectedItemColor: const Color(0xFF0F6E56),
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
    );
  }
}
