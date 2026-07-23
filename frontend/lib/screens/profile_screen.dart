import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/gradient_header.dart';
import '../services/api_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      bottomNavigationBar: const AppBottomNav(currentIndex: 5),
      body: CustomScrollView(slivers: [
        SliverToBoxAdapter(
          child: GradientHeader(
            colors: AppColors.profileGrad,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              child: Column(children: [
                Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, border: Border.all(color: Colors.white.withOpacity(0.3), width: 3),
                    gradient: const LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFFDB2777)])),
                  child: const Center(child: Text('A', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w700)))),
                const SizedBox(height: 12),
                const Text('Amara Nakato', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
                Text('Member since 2025 · Kampala', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
                const SizedBox(height: 16),
                Row(children: [
                  _stat('7', 'Day streak', context),
                  _divider(),
                  _stat('320', 'Points', context),
                  _divider(),
                  _stat('12', 'Badges', context),
                  _divider(),
                  _stat('5', 'Friends', context),
                ]),
              ]),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
          sliver: SliverList(delegate: SliverChildListDelegate([
            _section('Accessibility', [
              _row(Icons.text_fields_rounded, 'Font size', 'Large', const Color(0xFF0284C7)),
              _row(Icons.contrast_rounded, 'High contrast', 'On', const Color(0xFF059669)),
              _row(Icons.volume_up_rounded, 'Text to speech', 'On', const Color(0xFF7C3AED)),
              _row(Icons.mic_rounded, 'Voice control', 'Active', const Color(0xFFBE123C)),
            ]),
            const SizedBox(height: 16),
            _section('App settings', [
              _row(Icons.dark_mode_rounded, 'Dark mode', 'System', const Color(0xFF1E3A5F)),
              _row(Icons.language_rounded, 'Language', 'English', const Color(0xFF0284C7)),
              _row(Icons.notifications_rounded, 'Notifications', 'On', const Color(0xFFD97706)),
              _row(Icons.lock_rounded, 'Privacy & security', '', const Color(0xFF059669)),
            ]),
            const SizedBox(height: 16),
            _section('Account', [
              _row(Icons.edit_rounded, 'Edit profile', '', const Color(0xFF7C3AED)),
              _row(Icons.backup_rounded, 'Backup data', '', const Color(0xFF0284C7)),
            ]),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async { await ApiService.logout(); context.go('/login'); },
                icon: const Icon(Icons.logout_rounded, color: Color(0xFFDC2626)),
                label: const Text('Sign out', style: TextStyle(color: Color(0xFFDC2626))),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFDC2626), width: 0.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14)),
              ),
            ),
          ])),
        ),
      ]),
    );
  }

  Widget _stat(String val, String label, BuildContext ctx) => Expanded(
    child: Column(children: [
      Text(val, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
      Text(label, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 10)),
    ]),
  );

  Widget _divider() => Container(width: 0.5, height: 30, color: Colors.white.withOpacity(0.2));

  Widget _section(String title, List<Widget> rows) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(title.toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey, letterSpacing: 0.5)),
    const SizedBox(height: 8),
    Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.shade200)),
      child: Column(children: rows),
    ),
  ]);

  Widget _row(IconData icon, String label, String val, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade100, width: 0.5))),
    child: Row(children: [
      Container(width: 32, height: 32, decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: color, size: 18)),
      const SizedBox(width: 12),
      Expanded(child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))),
      if (val.isNotEmpty) Text(val, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      const SizedBox(width: 4),
      const Icon(Icons.chevron_right_rounded, color: Colors.grey, size: 18),
    ]),
  );
}
