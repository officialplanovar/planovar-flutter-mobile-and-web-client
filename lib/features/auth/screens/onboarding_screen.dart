import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/glossy_button.dart';

// ─── Slide data ───────────────────────────────────────────────────────────────

class _Slide {
  const _Slide({
    required this.assetPath,
    required this.titleBlack,
    required this.titlePurple,
    required this.body,
    this.overlay,
    this.belowDotsWidget,
  });

  final String assetPath;
  final String titleBlack;
  final String titlePurple; // italic purple part
  final String body;
  final Widget? overlay; // widget floating inside the image (bottom or top)
  final Widget? belowDotsWidget; // widget shown between dots and title
}

final _slides = [
  _Slide(
    assetPath: 'assets/images/onboarding_1.png',
    titleBlack: 'Tired of chasing endless',
    titlePurple: 'referrals?',
    body:
        'Planning an event shouldn\'t feel like a second job. Stop the fragmentation and discover quality vendors in seconds.',
  ),
  _Slide(
    assetPath: 'assets/images/onboarding_2.png',
    titleBlack: 'The finest talent, at your',
    titlePurple: 'fingertips.',
    body:
        'Access our curated network of top-tier caterers, decorators, and photographers. Verified quality, every time.'
    // overlay: const _VendorCardOverlay(),
  ),
  _Slide(
    assetPath: 'assets/images/onboarding_3.png',
    titleBlack: 'Join the community of pro',
    titlePurple: 'planners.',
    body:
        'Don\'t miss out on exclusive vendor rates. Join over 50,000 users hosting unforgettable moments.',
    // overlay: const _EventsPlannedBadge(),
    belowDotsWidget: const _CommunityAvatars(),
  ),
];

// ─── Screen ───────────────────────────────────────────────────────────────────

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _current = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    if (_current < _slides.length - 1) {
      debugPrint('next');
      _controller.nextPage(
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeInOut,
      );
      return;
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('seenOnboarding', true);
      debugPrint('seenOnboarding set; mounted=$mounted');
      if (!mounted) return;
      context.go(AppRoutes.login);
      debugPrint('navigated to login');
    } catch (e, st) {
      debugPrint('onboarding _next error: $e\n$st');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.c.surface,
      body: SafeArea(
        child: Column(
          children: [
            // ── Paged image cards ──────────────────────────────────────────
            Expanded(
              flex: 52,
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _current = i),
                itemCount: _slides.length,
                itemBuilder: (_, i) => _ImageCard(slide: _slides[i]),
              ),
            ),

            const SizedBox(height: 20),

            // ── Dot indicator ──────────────────────────────────────────────
            SmoothPageIndicator(
              controller: _controller,
              count: _slides.length,
              effect: const ExpandingDotsEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: AppColors.primary,
                dotColor: Color(0xFFD9D9D9),
                expansionFactor: 3,
                spacing: 5,
              ),
            ),

            // ── Optional widget between dots and title (slide 3 avatars) ──
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _slides[_current].belowDotsWidget != null
                  ? Padding(
                      key: ValueKey('below_$_current'),
                      padding: const EdgeInsets.only(top: 16),
                      child: _slides[_current].belowDotsWidget,
                    )
                  : const SizedBox(key: ValueKey('none'), height: 0),
            ),

            const SizedBox(height: 20),

            // ── Title ──────────────────────────────────────────────────────
            Expanded(
              flex: 22,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _TitleText(
                    key: ValueKey(_current),
                    blackPart: _slides[_current].titleBlack,
                    purplePart: _slides[_current].titlePurple,
                    body: _slides[_current].body,
                  ),
                ),
              ),
            ),

            // ── Button ─────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: GlossyButton(
                label: _current == _slides.length - 1 ? 'Get Started' : 'Next',
                onPressed: _next,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Image card ───────────────────────────────────────────────────────────────

class _ImageCard extends StatelessWidget {
  const _ImageCard({required this.slide});
  final _Slide slide;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              slide.assetPath,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: context.c.primaryLight,
                child: const Icon(
                  Icons.image_outlined,
                  size: 60,
                  color: AppColors.primary,
                ),
              ),
            ),
            if (slide.overlay != null)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                top: 0,
                child: slide.overlay!,
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Title text ───────────────────────────────────────────────────────────────

class _TitleText extends StatelessWidget {
  const _TitleText({
    super.key,
    required this.blackPart,
    required this.purplePart,
    required this.body,
  });

  final String blackPart;
  final String purplePart;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: context.c.textPrimary,
              height: 1.3,
            ),
            children: [
              TextSpan(text: '$blackPart\n'),
              TextSpan(
                text: purplePart,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          body,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: context.c.textHint,
            height: 1.55,
          ),
        ),
      ],
    );
  }
}

// ─── Slide 2 — Vendor card overlay ───────────────────────────────────────────

// class _VendorCardOverlay extends StatelessWidget {
//   const _VendorCardOverlay();
//
//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(20),
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//             decoration: BoxDecoration(
//               color: Colors.white.withValues(alpha: 0.82),
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(
//                 color: Colors.white.withValues(alpha: 0.6),
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withValues(alpha: 0.08),
//                   blurRadius: 12,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 // Avatar with purple ring
//                 Container(
//                   padding: const EdgeInsets.all(2),
//                   decoration: const BoxDecoration(
//                     shape: BoxShape.circle,
//                     gradient: LinearGradient(
//                       colors: [AppColors.primary, AppColors.primaryDark],
//                     ),
//                   ),
//                   child: CircleAvatar(
//                     radius: 24,
//                     backgroundColor: Colors.grey[200],
//                     backgroundImage:
//                         const AssetImage('assets/images/ob2_vendor.png'),
//                     onBackgroundImageError: (_, __) {},
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 // Name + badge
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Text(
//                         'Bloom & Co.',
//                         style: TextStyle(
//                           fontWeight: FontWeight.w700,
//                           fontSize: 15,
//                           color: Color(0xFF1A1A2E),
//                         ),
//                       ),
//                       const SizedBox(height: 3),
//                       Row(
//                         children: const [
//                           Icon(Icons.star_rounded,
//                               size: 14, color: AppColors.starColor),
//                           SizedBox(width: 4),
//                           Text(
//                             'Top Rated Vendor',
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Color(0xFF6B7280),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Chat button
//                 Container(
//                   width: 44,
//                   height: 44,
//                   decoration: const BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: AppColors.primary,
//                   ),
//                   child: const Icon(Icons.chat_bubble_rounded,
//                       color: Colors.white, size: 20),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// ─── Slide 3 — "🔥 Events planned" badge (inside image, top) ─────────────────

class _EventsPlannedBadge extends StatelessWidget {
  const _EventsPlannedBadge();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.88),
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🔥', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Text(
                '1200 Events Planned Today',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: context.c.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Slide 3 — Stacked community avatars (below dots) ────────────────────────

class _CommunityAvatars extends StatelessWidget {
  const _CommunityAvatars();

  static const _avatars = [
    'assets/images/ob3_avatar_1.png',
    'assets/images/ob3_avatar_2.png',
    'assets/images/ob3_avatar_3.png',
  ];

  @override
  Widget build(BuildContext context) {
    const size = 38.0;
    const overlap = 14.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size + (_avatars.length - 1) * (size - overlap),
          height: size,
          child: Stack(
            children: [
              for (int i = 0; i < _avatars.length; i++)
                Positioned(
                  left: i * (size - overlap),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: CircleAvatar(
                      radius: size / 2,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: AssetImage(_avatars[i]),
                      onBackgroundImageError: (_, __) {},
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: context.c.primaryLight,
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Text(
            '+50k',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
