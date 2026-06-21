import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../auth/data/auth_repository.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fade;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _fade = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _opacity = CurvedAnimation(parent: _fade, curve: Curves.easeIn);
    _navigate();
  }

  Future<void> _navigate() async {
    // Validate the persisted session (token) instead of trusting a flag that
    // earlier was only set on the login screen, never on register→verify.
    final results = await Future.wait<dynamic>([
      _isAuthenticated(),
      Future.delayed(const Duration(milliseconds: 2000)),
    ]);
    if (!mounted) return;
    final loggedIn = results[0] as bool;
    final prefs = await SharedPreferences.getInstance();
    final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;
    await prefs.setBool('isLoggedIn', loggedIn);
    if (loggedIn) {
      context.go(AppRoutes.homeFeed);
    } else if (seenOnboarding) {
      context.go(AppRoutes.login);
    } else {
      context.go(AppRoutes.onboarding);
    }
  }

  Future<bool> _isAuthenticated() async {
    try {
      await AuthRepository().getMe();
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  void dispose() {
    _fade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [Color(0xFFE8D5FA), Colors.white],
          ),
        ),
        child: Stack(
          children: [
            // Dot cluster — bottom right
            const Positioned(
              bottom: 60,
              right: -20,
              child: _DotCluster(),
            ),
            // Purple bottom accent bar
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 5,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryDark, AppColors.primary],
                  ),
                ),
              ),
            ),
            // Logo centred
            Center(
              child: FadeTransition(
                opacity: _opacity,
                child: _PlanovarLogo(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Planovar logo ────────────────────────────────────────────────────────────
// Replace the Image.asset with your real logo once assets/images/splash_logo.png is added.
class _PlanovarLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/splash_logo.png',
      width: 240,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => _FallbackLogo(),
    );
  }
}

class _FallbackLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Gradient P icon placeholder
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF6C63FF), Color(0xFF9139E6)],
            ),
          ),
          child: const Icon(Icons.star_rounded, color: Colors.white, size: 28),
        ),
        const SizedBox(width: 12),
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'PLAN',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                  letterSpacing: 1.5,
                ),
              ),
              TextSpan(
                text: 'OVAR',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF00BCD4),
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Dot cluster painter ──────────────────────────────────────────────────────
class _DotCluster extends StatelessWidget {
  const _DotCluster();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(220, 200),
      painter: _DotPainter(),
    );
  }
}

class _DotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.primary.withValues(alpha: 0.25);

    // Grid of circles with varied sizes and opacity
    final dots = [
      // (x, y, radius, opacity)
      (180.0, 30.0, 14.0, 0.5),
      (140.0, 10.0, 8.0, 0.3),
      (200.0, 70.0, 10.0, 0.4),
      (160.0, 65.0, 5.0, 0.25),
      (120.0, 45.0, 6.0, 0.2),
      (210.0, 110.0, 16.0, 0.55),
      (175.0, 110.0, 8.0, 0.3),
      (140.0, 90.0, 4.0, 0.2),
      (100.0, 75.0, 5.0, 0.15),
      (195.0, 150.0, 12.0, 0.45),
      (155.0, 145.0, 6.0, 0.28),
      (115.0, 130.0, 9.0, 0.22),
      (75.0, 115.0, 5.0, 0.15),
      (185.0, 185.0, 8.0, 0.35),
      (148.0, 180.0, 14.0, 0.4),
      (108.0, 165.0, 6.0, 0.25),
      (70.0, 152.0, 10.0, 0.2),
      (38.0, 140.0, 4.0, 0.12),
    ];

    for (final (x, y, r, a) in dots) {
      canvas.drawCircle(
        Offset(x, y),
        r,
        paint..color = AppColors.primary.withValues(alpha: a),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
