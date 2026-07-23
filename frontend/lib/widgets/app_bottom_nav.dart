import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  const AppBottomNav({super.key, required this.currentIndex});

  static const _routes  = ['/home', '/fun', '/ai', '/care', '/social', '/profile'];
  static const _labels  = ['Home', 'Fun', 'AI', 'Care', 'Social', 'Profile'];
  static const _icons   = [Icons.home_rounded, Icons.games_rounded, Icons.smart_toy_rounded,
                            Icons.favorite_rounded, Icons.people_rounded, Icons.person_rounded];
  static const _colors  = [AppColors.home, AppColors.fun, AppColors.ai,
                            AppColors.care, AppColors.social, AppColors.profile];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, -4))],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: List.generate(6, (i) {
              final active = i == currentIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => context.go(_routes[i]),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(horizontal: active ? 12 : 0, vertical: active ? 4 : 0),
                        decoration: BoxDecoration(
                          color: active ? _colors[i].withOpacity(0.15) : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(_icons[i], color: active ? _colors[i] : Colors.grey.shade400, size: 22),
                      ),
                      const SizedBox(height: 2),
                      Text(_labels[i], style: TextStyle(
                        fontSize: 9, fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                        color: active ? _colors[i] : Colors.grey.shade400,
                      )),
                    ]),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
