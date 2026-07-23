import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme.dart';
import 'services/api_service.dart';
import 'services/voice_service.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/voice_screen.dart';
import 'screens/fun_screen.dart';
import 'screens/ai_screen.dart';
import 'screens/care_screen.dart';
import 'screens/social_screen.dart';
import 'screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ApiService.init();
  await VoiceService().init();
  runApp(const ProviderScope(child: OrthpedeonApp()));
}

final _router = GoRouter(
  // App opens directly on home — no forced login
  initialLocation: '/',
  routes: [
    GoRoute(path: '/',         builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/onboard',  builder: (_, __) => const OnboardingScreen()),
    GoRoute(path: '/login',    builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
    GoRoute(path: '/home',     builder: (_, __) => const HomeScreen()),
    GoRoute(path: '/voice',    builder: (_, __) => const VoiceScreen()),
    GoRoute(path: '/fun',      builder: (_, __) => const FunScreen()),
    GoRoute(path: '/ai',       builder: (_, __) => const AiScreen()),
    GoRoute(path: '/care',     builder: (_, __) => const CareScreen()),
    GoRoute(path: '/social',   builder: (_, __) => const SocialScreen()),
    GoRoute(path: '/profile',  builder: (_, __) => const ProfileScreen()),
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
