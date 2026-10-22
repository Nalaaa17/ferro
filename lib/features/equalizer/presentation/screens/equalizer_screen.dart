import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ferro/app/theme/theme.dart';
import 'package:ferro/core/widgets/widgets.dart';
import 'package:ferro/features/equalizer/presentation/providers/equalizer_controller.dart';

/// Fullscreen 10-band Equalizer and Audio Effects UI per PRD §4.11.
class EqualizerScreen extends StatefulWidget {
  const EqualizerScreen({super.key});

  @override
  State<EqualizerScreen> createState() => _EqualizerScreenState();
}

class _EqualizerScreenState extends State<EqualizerScreen> {
  final EqualizerController _eq = EqualizerController.instance;

  @override
  void initState() {
    super.initState();
    _eq.addListener(_onEqChanged);
  }

  @override
  void dispose() {
    _eq.removeListener(_onEqChanged);
    super.dispose();
  }

  void _onEqChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onGainChanged(int index, double value) {
    // Snap to 0dB with light haptic feedback when near zero
    var effectiveValue = value;
    if (effectiveValue > -0.4 && effectiveValue < 0.4) {
      if (_eq.bandGains[index] != 0.0) {
        HapticFeedback.selectionClick();
      }
      effectiveValue = 0.0;
    }
    _eq.setBandGain(index, effectiveValue);
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = _eq.isEnabled;
    final activeProfile = _eq.activeProfile;

    return Scaffold(
      backgroundColor: FerroColors.background,
      appBar: AppBar(
        title: Text('Equalizer', style: FerroTypography.headline),
        actions: [
          // Master Switch Toggle
          Row(
            children: [
              Text(
                isEnabled ? 'AKTIF' : 'NONAKTIF',
                style: FerroTypography.captionBold.copyWith(
                  color: isEnabled ? FerroColors.primary : FerroColors.onSurfaceMuted,
                  fontSize: 11.0,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(width: FerroDimensions.space8),
              Switch(
                value: isEnabled,
                onChanged: _eq.toggleEnabled,
              ),
              const SizedBox(width: FerroDimensions.space12),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: FerroDimensions.space16,
          vertical: FerroDimensions.space12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Active Device Association Banner
            Container(
              padding: const EdgeInsets.all(FerroDimensions.space12),
              decoration: BoxDecoration(
                color: FerroColors.surface,
                borderRadius: FerroDimensions.radiusCardAll,
                border: Border.all(color: FerroColors.divider, width: 1.0),
              ),
              child: Row(
                children: [
                  const Icon(Icons.headphones_rounded, color: FerroColors.primaryLight, size: 22.0),
                  const SizedBox(width: FerroDimensions.space12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tersambung ke: ${activeProfile.displayName}',
                          style: FerroTypography.title.copyWith(fontSize: 13.5),
                        ),
                        Text(
                          'Preset: ${_eq.selectedPreset} • Vol: ${activeProfile.savedVolume}%',
                          style: FerroTypography.caption.copyWith(color: FerroColors.primary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: FerroDimensions.space16),

            // Preset Selection Chips
            Text('Preset Frekuensi', style: FerroTypography.title),
            const SizedBox(height: FerroDimensions.space12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...EqualizerController.presets.keys.map((preset) {
                    final isSelected = _eq.selectedPreset == preset;
                    return Padding(
                      padding: const EdgeInsets.only(right: FerroDimensions.space8),
                      child: FerroChip(
                        label: preset,
                        isSelected: isSelected,
                        onTap: isEnabled ? () => _eq.selectPreset(preset) : () {},
                      ),
                    );
                  }),
                  if (_eq.selectedPreset == 'Custom')
                    Padding(
                      padding: const EdgeInsets.only(right: FerroDimensions.space8),
                      child: FerroChip(
                        label: 'Custom',
                        isSelected: true,
                        onTap: () {},
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: FerroDimensions.space20),

            // 10-Band Vertical Fader Panel
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: FerroDimensions.space12,
                  vertical: FerroDimensions.space16,
                ),
                child: Column(
                  children: [
                    // Scale labels (+12dB, 0dB, -12dB)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('+12dB', style: FerroTypography.monoTimer.copyWith(fontSize: 11.0)),
                        Text('Kurva 10-Band FFmpeg Filter', style: FerroTypography.caption),
                        Text('-12dB', style: FerroTypography.monoTimer.copyWith(fontSize: 11.0)),
                      ],
                    ),
                    const Divider(height: 20),

                    // 10 Vertical Sliders Row
                    Opacity(
                      opacity: isEnabled ? 1.0 : 0.4,
                      child: SizedBox(
                        height: 220.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            EqualizerController.frequencyLabels.length,
                            (index) {
                              final freq = EqualizerController.frequencyLabels[index];
                              final gain = _eq.bandGains[index];

                              return _buildVerticalBandFader(
                                index: index,
                                frequency: freq,
                                gain: gain,
                                isEnabled: isEnabled,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: FerroDimensions.space20),

            // Accordion Panel for Audio Effects (Bass Boost, Virtualizer, Loudness)
            Card(
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  initiallyExpanded: true,
                  leading: const Icon(Icons.surround_sound_rounded, color: FerroColors.primaryLight),
                  title: Text('Efek Suara Tambahan', style: FerroTypography.title),
                  subtitle: Text(
                    'Bass Boost, Virtualizer 3D, Loudness Normalizer',
                    style: FerroTypography.caption,
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: FerroDimensions.space16,
                        vertical: FerroDimensions.space12,
                      ),
                      child: Column(
                        children: [
                          // 1. Bass Boost Slider (0 - 100)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Bass Boost', style: FerroTypography.title.copyWith(fontSize: 14.5)),
                              Text(
                                '${_eq.bassBoost.round()}%',
                                style: FerroTypography.monoTimer.copyWith(color: FerroColors.primary),
                              ),
                            ],
                          ),
                          Slider(
                            value: _eq.bassBoost,
                            min: 0.0,
                            max: 100.0,
                            onChanged: isEnabled ? _eq.setBassBoost : null,
                          ),
                          const SizedBox(height: FerroDimensions.space12),

                          // 2. Virtualizer Slider (0 - 100)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Virtualizer (3D Audio)', style: FerroTypography.title.copyWith(fontSize: 14.5)),
                              Text(
                                '${_eq.virtualizer.round()}%',
                                style: FerroTypography.monoTimer.copyWith(color: FerroColors.primary),
                              ),
                            ],
                          ),
                          Slider(
                            value: _eq.virtualizer,
                            min: 0.0,
                            max: 100.0,
                            onChanged: isEnabled ? _eq.setVirtualizer : null,
                          ),
                          const SizedBox(height: FerroDimensions.space12),

                          // 3. Loudness Normalization Switch
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text('Normalisasi Volume', style: FerroTypography.title.copyWith(fontSize: 14.5)),
                            subtitle: Text(
                              'Menyamakan tingkat kenyaringan antar file audio berbeda',
                              style: FerroTypography.caption,
                            ),
                            value: _eq.loudnessNormalization,
                            onChanged: isEnabled ? _eq.toggleLoudnessNormalization : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: FerroDimensions.space24),

            // CTA Button: Simpan ke Profil Perangkat Aktif
            FerroButton(
              label: 'Simpan ke Profil Perangkat Aktif',
              icon: Icons.save_rounded,
              fullWidth: true,
              onPressed: () {
                _eq.saveToActiveProfile();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Kurva EQ berhasil disimpan untuk "${activeProfile.displayName}" 🎧',
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: FerroDimensions.space24),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalBandFader({
    required int index,
    required String frequency,
    required double gain,
    required bool isEnabled,
  }) {
    return Column(
      children: [
        // Gain display (+X.X dB)
        Text(
          gain >= 0 ? '+${gain.toStringAsFixed(1)}' : gain.toStringAsFixed(1),
          style: FerroTypography.monoTimer.copyWith(
            fontSize: 9.5,
            color: gain == 0.0 ? FerroColors.onSurfaceMuted : FerroColors.primary,
            fontWeight: gain == 0.0 ? FontWeight.w400 : FontWeight.w700,
          ),
        ),
        const SizedBox(height: FerroDimensions.space6),

        // Vertical Slider Rotated
        Expanded(
          child: RotatedBox(
            quarterTurns: 3, // Rotate 270 degrees to make vertical slider
            child: SliderTheme(
              data: Theme.of(context).sliderTheme.copyWith(
                trackHeight: 3.5,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 12.0),
              ),
              child: Slider(
                value: gain,
                min: -12.0,
                max: 12.0,
                onChanged: isEnabled ? (val) => _onGainChanged(index, val) : null,
              ),
            ),
          ),
        ),
        const SizedBox(height: FerroDimensions.space6),

        // Frequency Label (31Hz, 1kHz, etc)
        Text(
          frequency,
          style: FerroTypography.captionBold.copyWith(
            fontSize: 10.0,
            color: FerroColors.onSurfaceMuted,
          ),
        ),
      ],
    );
  }
}
