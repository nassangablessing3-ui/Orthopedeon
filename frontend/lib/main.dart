import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme.dart';
import 'services/api_service.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/voice_screen.dart';
import 'screens/wellness_screen.dart';
import 'screens/social_screen.dart';
import 'screens/joy_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ApiService.init();
  runApp(const ProviderScope(child: OrthpedeonApp()));
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/',         builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/onboard',  builder: (_, __) => const OnboardingScreen()),
    GoRoute(path: '/login',    builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
    GoRoute(path: '/dashboard',builder: (_, __) => const DashboardScreen()),
    GoRoute(path: '/voice',    builder: (_, __) => const VoiceScreen()),
    GoRoute(path: '/wellness', builder: (_, __) => const WellnessScreen()),
    GoRoute(path: '/social',   builder: (_, __) => const SocialScreen()),
    GoRoute(path: '/joy',      builder: (_, __) => const JoyScreen()),
  ],
);

class OrthpedeonApp extends StatelessWidget {
  const OrthpedeonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Orth_pedeon',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: _router,
    );
  }
}
