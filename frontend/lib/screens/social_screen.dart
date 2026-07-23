import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/theme.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/voice_fab.dart';
import '../widgets/gradient_header.dart';
import '../services/api_service.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});
  @override State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  List<dynamic> _groups = [];
  int _tab = 0; // 0=Community, 1=Friends, 2=Apps

  @override
  void initState() { super.initState(); _loadGroups(); }

  Future<void> _loadGroups() async {
    try {
      final g = await ApiService.getGroups();
      setState(() => _groups = g);
    } catch (_) {
      setState(() => _groups = [
        {'name': 'Low Vision Connect',  'description': 'Share tips and experiences', 'category': 'visual',   'member_count': '1200'},
        {'name': 'Mobility Warriors',   'description': 'Adaptive sports & tech hacks','category': 'mobility', 'member_count': '876'},
        {'name': 'Memory & Learning',   'description': 'Cognitive tools & support',  'category': 'cognitive','member_count': '540'},
        {'name': 'Deaf Music Lovers',   'description': 'Music felt, not just heard', 'category': 'hearing',  'member_count': '318'},
        {'name': 'Wellness Warriors',   'description': 'Mental health community',    'category': 'mental',   'member_count': '721'},
      ]);
    }
  }

  final _socialApps = [
    {'name': 'WhatsApp',   'uri': 'whatsapp://send',  'color': Color(0xFF25D366), 'icon': Icons.chat_rounded},
    {'name': 'Facebook',   'uri': 'fb://',             'color': Color(0xFF1877F2), 'icon': Icons.facebook_rounded},
    {'name': 'Twitter/X',  'uri': 'twitter://',        'color': Color(0xFF1DA1F2), 'icon': Icons.alternate_email_rounded},
    {'name': 'Instagram',  'uri': 'instagram://',      'color': Color(0xFFE1306C), 'icon': Icons.camera_alt_rounded},
    {'name': 'YouTube',    'uri': 'vnd.youtube://',    'color': Color(0xFFFF0000), 'icon': Icons.play_circle_rounded},
    {'name': 'SMS',        'uri': 'sms:',              'color': Color(0xFF34C759), 'icon': Icons.sms_rounded},
  ];

  final _friends = [
    {'name': 'Amina K',   'status': 'Online', 'num': 'tel:+256700000010'},
    {'name': 'Brian M',   'status': 'Today',  'num': 'tel:+256700000011'},
    {'name': 'Grace N',   'status': 'Online', 'num': 'tel:+256700000012'},
    {'name': 'David O',   'status': 'Yesterday','num': 'tel:+256700000013'},
  ];

  final _catColors = {
    'visual': Color(0xFF0284C7), 'mobility': Color(0xFF059669),
    'cognitive': Color(0xFF7C3AED), 'hearing': Color(0xFFD97706), 'mental': Color(0xFFDB2777),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1F5),
      floatingActionButton: const VoiceFab(),
      bottomNavigationBar: const AppBottomNav(currentIndex: 4),
      body: CustomScrollView(slivers: [
        SliverToBoxAdapter(
          child: GradientHeader(
            colors: AppColors.socialGrad,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Social 🌍', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700)),
                Text('Friends · Community · Connect', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13)),
                const SizedBox(height: 16),
                // Tabs
                Row(children: [
                  _tab_btn('Community', 0), const SizedBox(width: 8),
                  _tab_btn('Friends', 1),   const SizedBox(width: 8),
                  _tab_btn('Apps', 2),
                ]),
                const SizedBox(height: 16),
              ]),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
          sliver: SliverList(delegate: SliverChildListDelegate([
            if (_tab == 0) ..._groups.map((g) => _groupCard(g)).toList(),
            if (_tab == 1) ..._friends.map((f) => _friendCard(f)).toList(),
            if (_tab == 2) ...[
              const Text('Connect via your favourite apps', style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 2.4,
                children: _socialApps.map((a) => _appCard(a)).toList(),
              ),
            ],
          ])),
        ),
      ]),
    );
  }

  Widget _tab_btn(String label, int i) => GestureDetector(
    onTap: () => setState(() => _tab = i),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _tab == i ? Colors.white : Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(
        color: _tab == i ? AppColors.social : Colors.white,
        fontSize: 12, fontWeight: FontWeight.w600)),
    ),
  );

  Widget _groupCard(dynamic g) {
    final cat = g['category'] ?? 'visual';
    final color = _catColors[cat] ?? const Color(0xFF7C3AED);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.shade200)),
      child: Row(children: [
        Container(width: 44, height: 44, decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
          child: Icon(Icons.people_rounded, color: color, size: 22)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(g['name'] ?? '', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          Text(g['description'] ?? '', style: const TextStyle(fontSize: 11, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text('${g['member_count']} members', style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w500)),
        ])),
        TextButton(
          style: TextButton.styleFrom(backgroundColor: color.withOpacity(0.12), foregroundColor: color,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          onPressed: () {}, child: const Text('Join', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ),
      ]),
    );
  }

  Widget _friendCard(Map<String, dynamic> f) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.shade200)),
    child: Row(children: [
      Container(width: 44, height: 44, decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFDB2777), Color(0xFF7C3AED)]), shape: BoxShape.circle),
        child: Center(child: Text(f['name']![0], style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)))),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(f['name']!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        Row(children: [
          Container(width: 6, height: 6, margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(shape: BoxShape.circle, color: f['status'] == 'Online' ? const Color(0xFF059669) : Colors.grey)),
          Text(f['status']!, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ]),
      ])),
      GestureDetector(
        onTap: () async { final u = Uri.parse(f['num']!); if (await canLaunchUrl(u)) await launchUrl(u); },
        child: Container(width: 38, height: 38, decoration: BoxDecoration(color: const Color(0xFFD1FAE5), shape: BoxShape.circle),
          child: const Icon(Icons.phone_rounded, color: Color(0xFF059669), size: 18))),
      const SizedBox(width: 8),
      GestureDetector(
        onTap: () async { final u = Uri.parse('sms:${f['num']!.replaceAll('tel:', '')}'); if (await canLaunchUrl(u)) await launchUrl(u); },
        child: Container(width: 38, height: 38, decoration: BoxDecoration(color: const Color(0xFFEDE9FE), shape: BoxShape.circle),
          child: const Icon(Icons.message_rounded, color: Color(0xFF7C3AED), size: 18))),
    ]),
  );

  Widget _appCard(Map<String, dynamic> a) => GestureDetector(
    onTap: () async { try { final u = Uri.parse(a['uri'] as String); await launchUrl(u, mode: LaunchMode.externalApplication); } catch (_) {} },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
      child: Row(children: [
        Container(width: 36, height: 36, decoration: BoxDecoration(color: (a['color'] as Color).withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
          child: Icon(a['icon'] as IconData, color: a['color'] as Color, size: 20)),
        const SizedBox(width: 10),
        Text(a['name'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A0B3B))),
      ]),
    ),
  );
}
