import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ferro/app/theme/theme.dart';
import 'package:ferro/core/widgets/widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingItem> _pages = const [
    _OnboardingItem(
      title: 'Semua Format, Satu Player',
      description:
          'MP3, FLAC, WAV, bahkan audio dari video MP4/MKV — semua bisa diputar tanpa konversi.',
      icon: Icons.audio_file_rounded,
      tag: 'LOSSLESS PLAYBACK',
    ),
    _OnboardingItem(
      title: 'EQ yang Hafal Perangkatmu',
      description:
          'Colok IEM, sambung TWS — kurva EQ 10-band & volume menyesuaikan otomatis seketika.',
      icon: Icons.headphones_rounded,
      tag: 'PER-GEAR PRESET',
    ),
    _OnboardingItem(
      title: '100% Offline & Privat',
      description:
          'Musimu tidak pernah meninggalkan perangkat. Tanpa kuota internet, tanpa server, privasi maksimal.',
      icon: Icons.verified_user_rounded,
      tag: 'OFFLINE FIRST',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    } else {
      context.go('/permission');
    }
  }

  void _onSkip() {
    context.go('/permission');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FerroColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        actions: [
          if (_currentPage < _pages.length - 1)
            TextButton(
              onPressed: _onSkip,
              child: Text(
                'Lewati',
                style: FerroTypography.title.copyWith(
                  color: FerroColors.onSurfaceMuted,
                  fontSize: 14.0,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Swipeable Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  final item = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: FerroDimensions.space32,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Illustration Circle with Halo
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 180.0,
                              height: 180.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    FerroColors.primary.withValues(alpha: 0.2),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 120.0,
                              height: 120.0,
                              decoration: BoxDecoration(
                                color: FerroColors.surfaceHigh,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: FerroColors.divider,
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.4),
                                    blurRadius: 16.0,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Icon(
                                  item.icon,
                                  size: 56.0,
                                  color: FerroColors.primaryLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: FerroDimensions.space32),

                        // Tag Chip
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: FerroDimensions.space12,
                            vertical: FerroDimensions.space4,
                          ),
                          decoration: BoxDecoration(
                            color: FerroColors.surfaceHigh,
                            borderRadius: FerroDimensions.radiusPillAll,
                            border: Border.all(
                              color: FerroColors.primary.withValues(alpha: 0.5),
                              width: 1.0,
                            ),
                          ),
                          child: Text(
                            item.tag,
                            style: FerroTypography.captionBold.copyWith(
                              color: FerroColors.primary,
                              fontSize: 11.0,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: FerroDimensions.space16),

                        // Title
                        Text(
                          item.title,
                          textAlign: TextAlign.center,
                          style: FerroTypography.display.copyWith(
                            fontSize: 24.0,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: FerroDimensions.space12),

                        // Description
                        Text(
                          item.description,
                          textAlign: TextAlign.center,
                          style: FerroTypography.body.copyWith(
                            color: FerroColors.onSurfaceMuted,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Dots Indicator & Action Button
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: FerroDimensions.space24,
                vertical: FerroDimensions.space24,
              ),
              child: Column(
                children: [
                  // Dot Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (index) {
                      final isActive = index == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        width: isActive ? 24.0 : 8.0,
                        height: 8.0,
                        decoration: BoxDecoration(
                          color: isActive ? FerroColors.primary : FerroColors.surfaceHigh,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: FerroDimensions.space24),

                  // Bottom Action Button
                  FerroButton(
                    label: _currentPage == _pages.length - 1
                        ? 'Mulai Menggunakan Ferro'
                        : 'Lanjut',
                    icon: _currentPage == _pages.length - 1
                        ? Icons.arrow_forward_rounded
                        : null,
                    fullWidth: true,
                    onPressed: _onNext,
                    variant: FerroButtonVariant.filled,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingItem {
  const _OnboardingItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.tag,
  });

  final String title;
  final String description;
  final IconData icon;
  final String tag;
}
