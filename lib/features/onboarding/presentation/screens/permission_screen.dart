import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ferro/app/theme/theme.dart';
import 'package:ferro/core/widgets/widgets.dart';

/// Permission screen explaining offline storage access per PRD §4.3 (friendly for browser & mobile).
class PermissionScreen extends StatelessWidget {
  const PermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FerroColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: FerroDimensions.space32,
            vertical: FerroDimensions.space24,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Glowing Folder Illustration
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 170.0,
                    height: 170.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          FerroColors.primary.withValues(alpha: 0.25),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 110.0,
                    height: 110.0,
                    decoration: BoxDecoration(
                      color: FerroColors.surfaceHigh,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: FerroColors.primary.withValues(alpha: 0.6),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: FerroColors.primary.withValues(alpha: 0.25),
                          blurRadius: 24.0,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.folder_shared_rounded,
                        size: 52.0,
                        color: FerroColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: FerroDimensions.space32),

              // Headline
              Text(
                'Izinkan Ferro Mengakses Musikmu',
                textAlign: TextAlign.center,
                style: FerroTypography.display.copyWith(
                  fontSize: 24.0,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: FerroDimensions.space12),

              // Explanation Body
              Text(
                'Ferro memerlukan izin membaca penyimpanan agar dapat memindai dan memutar koleksi lagu Anda. File musik Anda tidak akan pernah diunggah ke internet — 100% tersimpan aman di perangkat.',
                textAlign: TextAlign.center,
                style: FerroTypography.body.copyWith(
                  color: FerroColors.onSurfaceMuted,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: FerroDimensions.space24),

              // Privacy highlight chip
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: FerroDimensions.space16,
                  vertical: FerroDimensions.space8,
                ),
                decoration: BoxDecoration(
                  color: FerroColors.surface,
                  borderRadius: FerroDimensions.radiusCardAll,
                  border: Border.all(color: FerroColors.divider, width: 1.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.lock_outline_rounded,
                      size: 16.0,
                      color: FerroColors.success,
                    ),
                    const SizedBox(width: FerroDimensions.space8),
                    Text(
                      'Privasi Penuh: Tanpa Iklan & Tanpa Tracking',
                      style: FerroTypography.captionBold.copyWith(
                        color: FerroColors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Action Buttons
              FerroButton(
                label: 'Izinkan Akses',
                icon: Icons.check_rounded,
                fullWidth: true,
                onPressed: () => context.go('/home'),
                variant: FerroButtonVariant.filled,
              ),
              const SizedBox(height: FerroDimensions.space12),
              FerroButton(
                label: 'Jelajahi Demo Terlebih Dahulu',
                fullWidth: true,
                onPressed: () => context.go('/home'),
                variant: FerroButtonVariant.text,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
