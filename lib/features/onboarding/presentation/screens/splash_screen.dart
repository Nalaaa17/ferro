import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ferro/app/theme/theme.dart';

/// Splash Screen with breathing pulsing logo and progress bar per PRD §4.1.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _scaleAnimation;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    // Pulse animation (scale 0.96 -> 1.0, 1.2s repeat reverse)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.96, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Automatic transition after 1.5 seconds per PRD
    _navigationTimer = Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        context.go('/onboarding');
      }
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FerroColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Pulsing Logo Icon & Wordmark
              ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  children: [
                    Container(
                      width: 88.0,
                      height: 88.0,
                      decoration: BoxDecoration(
                        gradient: FerroColors.primaryGradient,
                        borderRadius: BorderRadius.circular(26.0),
                        boxShadow: [
                          BoxShadow(
                            color: FerroColors.primary.withValues(alpha: 0.4),
                            blurRadius: 32.0,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Image.asset(
                            'assets/images/ferro_logo.png',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => const Icon(
                              Icons.graphic_eq_rounded,
                              size: 48.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: FerroDimensions.space20),
                    Text(
                      'FERRO',
                      style: FerroTypography.display.copyWith(
                        letterSpacing: 4.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: FerroDimensions.space6),
                    Text(
                      'Universal Offline Audio Player',
                      style: FerroTypography.caption.copyWith(
                        letterSpacing: 0.5,
                        color: FerroColors.onSurfaceMuted,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Thin loading gradient bar (2dp)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 96.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(1.0),
                  child: const SizedBox(
                    height: 2.0,
                    child: LinearProgressIndicator(
                      backgroundColor: FerroColors.surfaceHigh,
                      valueColor: AlwaysStoppedAnimation<Color>(FerroColors.primary),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: FerroDimensions.space32),
            ],
          ),
        ),
      ),
    );
  }
}
