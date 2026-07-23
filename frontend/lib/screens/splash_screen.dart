import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade, _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _scale = Tween(begin: 0.8, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    _ctrl.forward();
    // Go straight to home — no login required
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) context.go('/home');
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [Color(0xFF0D0630), Color(0xFF1A0B3B), Color(0xFF2D0E6E)])),
        child: FadeTransition(
          opacity: _fade,
          child: Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              ScaleTransition(
                scale: _scale,
                child: Container(
                  width: 110, height: 110,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [BoxShadow(color: const Color(0xFF7C3AED).withOpacity(0.5), blurRadius: 32, spreadRadius: 4)],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: Image.asset('assets/icons/app_icon.png', fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFF7C3AED),
                        child: const Icon(Icons.accessibility_new, color: Colors.white, size: 56))),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Orth_pedeon', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w600, letterSpacing: -0.5)),
              const SizedBox(height: 8),
              Text('Independence · Connection · Joy', style: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 13, letterSpacing: 0.5)),
              const SizedBox(height: 48),
              SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white.withOpacity(0.5), strokeWidth: 2)),
            ]),
          ),
        ),
      ),
    );
  }
}
