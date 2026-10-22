import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferro/app/theme/theme.dart';
import 'package:ferro/features/devices/domain/entities/device_profile.dart';
import 'package:ferro/features/equalizer/presentation/providers/equalizer_controller.dart';
import 'package:ferro/features/player/presentation/providers/player_controller.dart';

/// Riverpod Provider managing Equalizer and Per-Gear Device profiles per PRD §5.2.
final deviceGearProvider = Provider<EqualizerController>((ref) {
  return EqualizerController.instance;
});

/// Active gear profile notifier responding to hardware gear changes
class ActiveGearProfileNotifier extends Notifier<DeviceProfile> {
  @override
  DeviceProfile build() {
    final eq = EqualizerController.instance;
    void listener() {
      state = eq.activeProfile;
    }

    eq.addListener(listener);
    ref.onDispose(() => eq.removeListener(listener));
    return eq.activeProfile;
  }

  void switchDevice(String profileId) {
    EqualizerController.instance.switchActiveDevice(profileId);
    state = EqualizerController.instance.activeProfile;
  }
}

final activeGearProfileProvider =
    NotifierProvider<ActiveGearProfileNotifier, DeviceProfile>(ActiveGearProfileNotifier.new);

/// Simulation utility to simulate hardware plug/unplug events in the browser per PRD §5.2
class HardwareGearSimulator {
  HardwareGearSimulator._();

  static void simulatePlugGear(BuildContext context, String profileId) {
    final eq = EqualizerController.instance;
    final player = PlayerController.instance;

    eq.switchActiveDevice(profileId);
    final active = eq.activeProfile;

    // Apply auto-set target volume
    player.setVolume(active.savedVolume / 100.0);

    // Show stylish confirmation banner
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: FerroColors.surface,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: FerroDimensions.radiusCardAll,
          side: BorderSide(color: FerroColors.primary),
        ),
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: FerroColors.primary.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.cable_rounded, color: FerroColors.primaryLight, size: 20.0),
            ),
            const SizedBox(width: FerroDimensions.space12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Perangkat Terdeteksi: ${active.displayName}',
                    style: FerroTypography.title.copyWith(fontSize: 13.5, color: Colors.white),
                  ),
                  Text(
                    'Preset EQ: ${active.presetName} • Volume: ${active.savedVolume}%',
                    style: FerroTypography.caption.copyWith(color: FerroColors.primaryLight),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Opens an interactive modal allowing anyone in the browser to simulate plugging in different audio gear
  static void showSimulationSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: FerroColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: FerroDimensions.radiusSheetTop,
        side: BorderSide(color: FerroColors.divider, width: 1.0),
      ),
      builder: (context) {
        final eq = EqualizerController.instance;
        final profiles = eq.profiles;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(FerroDimensions.space16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(Icons.sensors_rounded, color: FerroColors.primaryLight, size: 24.0),
                          const SizedBox(width: FerroDimensions.space8),
                          Expanded(
                            child: Text(
                              'Simulasi Deteksi Hardware (Browser)',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: FerroTypography.title.copyWith(fontSize: 15.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: FerroDimensions.space4),
                Text(
                  'Uji coba fitur Per-Gear Auto Preset. Pilih gear di bawah untuk mensimulasikan koneksi hardware audio:',
                  style: FerroTypography.caption.copyWith(color: FerroColors.onSurfaceMuted),
                ),
                const SizedBox(height: FerroDimensions.space16),
                ...profiles.map((profile) {
                  final isActive = profile.isActive;

                  IconData icon;
                  switch (profile.connectionType) {
                    case 'usb':
                      icon = Icons.usb_rounded;
                      break;
                    case 'wired':
                      icon = Icons.headphones_rounded;
                      break;
                    case 'bluetooth':
                    default:
                      icon = Icons.bluetooth_audio_rounded;
                      break;
                  }

                  return Card(
                    color: isActive ? FerroColors.primary.withValues(alpha: 0.15) : FerroColors.surfaceHigh,
                    margin: const EdgeInsets.only(bottom: FerroDimensions.space8),
                    child: ListTile(
                      leading: Icon(icon, color: isActive ? FerroColors.primary : FerroColors.primaryLight),
                      title: Text(profile.displayName, style: FerroTypography.title.copyWith(fontSize: 14.5)),
                      subtitle: Text(
                        'Preset: ${profile.presetName} • Target Vol: ${profile.savedVolume}%',
                        style: FerroTypography.caption,
                      ),
                      trailing: isActive
                          ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                              decoration: BoxDecoration(
                                color: FerroColors.success.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Text(
                                'TERHUBUNG',
                                style: FerroTypography.captionBold.copyWith(
                                  color: FerroColors.success,
                                  fontSize: 10.0,
                                ),
                              ),
                            )
                          : const Icon(Icons.cable_rounded, color: FerroColors.onSurfaceMuted),
                      onTap: () {
                        Navigator.pop(context);
                        simulatePlugGear(context, profile.id);
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
