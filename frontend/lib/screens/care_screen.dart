import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/theme.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/voice_fab.dart';
import '../widgets/gradient_header.dart';

class CareScreen extends StatefulWidget {
  const CareScreen({super.key});
  @override State<CareScreen> createState() => _CareScreenState();
}

class _CareScreenState extends State<CareScreen> {
  final _toggles = {'Medication': true, 'Water': true, 'Exercise': false, 'Sleep': true};

  final _contacts = [
    {'name': 'Dr. Sarah Nantume', 'role': 'Doctor',  'num': 'tel:+256700000003', 'color': Color(0xFFD1FAE5), 'ic': Icons.local_hospital_rounded, 'ac': Color(0xFF059669)},
    {'name': 'Mum',               'role': 'Family',  'num': 'tel:+256700000001', 'color': Color(0xFFEDE9FE), 'ic': Icons.favorite_rounded,       'ac': Color(0xFF7C3AED)},
    {'name': 'Dad',               'role': 'Family',  'num': 'tel:+256700000002', 'color': Color(0xFFE0F2FE), 'ic': Icons.person_rounded,          'ac': Color(0xFF0284C7)},
    {'name': 'Caregiver Rose',    'role': 'Carer',   'num': 'tel:+256700000004', 'color': Color(0xFFFCE7F3), 'ic': Icons.support_agent_rounded,   'ac': Color(0xFFDB2777)},
  ];

  Future<void> _call(String num) async {
    final uri = Uri.parse(num);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FDF4),
      floatingActionButton: const VoiceFab(),
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
      body: CustomScrollView(slivers: [
        SliverToBoxAdapter(
          child: GradientHeader(
            colors: AppColors.careGrad,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Care & Wellness ❤️', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
                Text('Your daily health companion', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13)),
                const SizedBox(height: 16),
                Row(children: [
                  _statBadge('💊', 'Meds', '8 AM'),
                  const SizedBox(width: 10),
                  _statBadge('💧', 'Water', 'Every 2h'),
                  const SizedBox(width: 10),
                  _statBadge('🌙', 'Sleep', '9:30 PM'),
                ]),
              ]),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
          sliver: SliverList(delegate: SliverChildListDelegate([
            const Text('Today\'s reminders', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey)),
            const SizedBox(height: 10),
            ..._toggles.entries.map((e) => _reminderCard(e.key, e.value)),
            const SizedBox(height: 20),
            const Text('Emergency contacts', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey)),
            const SizedBox(height: 10),
            ..._contacts.map((c) => _contactCard(c)),
          ])),
        ),
      ]),
    );
  }

  Widget _statBadge(String emoji, String label, String val) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
      child: Column(children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
        Text(val, style: TextStyle(color: Colors.white.withOpacity(0.65), fontSize: 9)),
      ]),
    ),
  );

  final _reminderDetails = {
    'Medication': {'icon': Icons.medication_rounded, 'sub': '8:00 AM · Daily', 'bg': Color(0xFFE0F2FE), 'ac': Color(0xFF0284C7)},
    'Water':      {'icon': Icons.water_drop_rounded, 'sub': 'Every 2 hours',   'bg': Color(0xFFD1FAE5), 'ac': Color(0xFF059669)},
    'Exercise':   {'icon': Icons.directions_run_rounded,'sub': '4:00 PM · Daily','bg': Color(0xFFFEF3C7),'ac': Color(0xFFD97706)},
    'Sleep':      {'icon': Icons.bedtime_rounded,    'sub': '9:30 PM · Nightly','bg': Color(0xFFEDE9FE),'ac': Color(0xFF7C3AED)},
  };

  Widget _reminderCard(String name, bool on) {
    final d = _reminderDetails[name]!;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.shade200)),
      child: Row(children: [
        Container(width: 44, height: 44, decoration: BoxDecoration(color: d['bg'] as Color, borderRadius: BorderRadius.circular(12)),
          child: Icon(d['icon'] as IconData, color: d['ac'] as Color, size: 22)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          Text(d['sub'] as String, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ])),
        Switch(
          value: _toggles[name]!,
          activeColor: d['ac'] as Color,
          onChanged: (v) => setState(() => _toggles[name] = v),
        ),
      ]),
    );
  }

  Widget _contactCard(Map<String, dynamic> c) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.shade200)),
    child: Row(children: [
      Container(width: 44, height: 44, decoration: BoxDecoration(color: c['color'] as Color, borderRadius: BorderRadius.circular(12)),
        child: Icon(c['ic'] as IconData, color: c['ac'] as Color, size: 22)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(c['name'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        Text(c['role'] as String, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ])),
      GestureDetector(
        onTap: () => _call(c['num'] as String),
        child: Container(width: 40, height: 40, decoration: BoxDecoration(color: const Color(0xFFD1FAE5), shape: BoxShape.circle),
          child: const Icon(Icons.phone_rounded, color: Color(0xFF059669), size: 20))),
    ]),
  );
}
