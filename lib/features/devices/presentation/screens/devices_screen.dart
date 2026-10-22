import 'package:flutter/material.dart';
import 'package:ferro/app/theme/theme.dart';
import 'package:ferro/core/widgets/widgets.dart';
import 'package:ferro/features/devices/domain/entities/device_profile.dart';
import 'package:ferro/features/equalizer/presentation/providers/equalizer_controller.dart';
import 'package:ferro/features/equalizer/presentation/screens/equalizer_screen.dart';

/// Perangkat Saya (Per-Gear Auto Preset UI) Screen per PRD §4.12.
class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  final EqualizerController _eq = EqualizerController.instance;

  @override
  void initState() {
    super.initState();
    _eq.addListener(_onChanged);
  }

  @override
  void dispose() {
    _eq.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _openEditProfileModal({DeviceProfile? existingProfile}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: FerroColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: FerroDimensions.radiusSheetTop,
        side: BorderSide(color: FerroColors.divider, width: 1.0),
      ),
      builder: (context) {
        return _DeviceProfileEditorSheet(
          profile: existingProfile,
          onSave: (savedProfile) {
            if (existingProfile == null) {
              _eq.addProfile(savedProfile);
            } else {
              _eq.updateProfile(savedProfile);
            }
          },
        );
      },
    );
  }

  void _confirmDeleteProfile(DeviceProfile profile) {
    if (_eq.profiles.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Minimal harus ada 1 profil perangkat tersimpan.')),
      );
      return;
    }

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: FerroColors.surface,
          shape: const RoundedRectangleBorder(
            borderRadius: FerroDimensions.radiusCardAll,
            side: BorderSide(color: FerroColors.divider),
          ),
          title: Text('Hapus Profil?', style: FerroTypography.headline.copyWith(fontSize: 18.0)),
          content: Text(
            'Apakah Anda yakin ingin menghapus profil "${profile.displayName}"?',
            style: FerroTypography.body,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal', style: FerroTypography.body.copyWith(color: FerroColors.onSurfaceMuted)),
            ),
            TextButton(
              onPressed: () {
                _eq.deleteProfile(profile.id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Profil "${profile.displayName}" telah dihapus')),
                );
              },
              child: Text(
                'Hapus',
                style: FerroTypography.body.copyWith(color: FerroColors.error, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final profiles = _eq.profiles;

    return Scaffold(
      backgroundColor: FerroColors.background,
      appBar: AppBar(
        title: Text('Perangkat Saya', style: FerroTypography.headline),
        actions: [
          IconButton(
            icon: const Icon(Icons.equalizer_rounded),
            tooltip: 'Buka Equalizer',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const EqualizerScreen()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: FerroColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          'Tambah Profil',
          style: FerroTypography.title.copyWith(color: Colors.white, fontSize: 14.0),
        ),
        onPressed: () => _openEditProfileModal(),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: FerroDimensions.space16,
          vertical: FerroDimensions.space12,
        ),
        children: [
          // 1. Education Banner for Automatic Hardware Detection
          _buildEducationBanner(),
          const SizedBox(height: FerroDimensions.space20),

          // 2. Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Profil Tersimpan (${profiles.length})', style: FerroTypography.title),
              Text(
                'Auto-Switch: ${_eq.autoSwitchEnabled ? "Aktif" : "Mati"}',
                style: FerroTypography.captionBold.copyWith(
                  color: _eq.autoSwitchEnabled ? FerroColors.primary : FerroColors.onSurfaceMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: FerroDimensions.space12),

          // 3. List of Device Profiles
          ...profiles.map((profile) => _buildDeviceCard(profile)),

          const SizedBox(height: 80.0), // Spacing for FAB
        ],
      ),
    );
  }

  Widget _buildEducationBanner() {
    return Container(
      padding: const EdgeInsets.all(FerroDimensions.space16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            FerroColors.primary.withValues(alpha: 0.15),
            FerroColors.surface,
          ],
        ),
        borderRadius: FerroDimensions.radiusCardAll,
        border: Border.all(
          color: FerroColors.primary.withValues(alpha: 0.35),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: FerroColors.primary.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.sensors_rounded,
                  color: FerroColors.primaryLight,
                  size: 20.0,
                ),
              ),
              const SizedBox(width: FerroDimensions.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Deteksi Perangkat Cerdas (Per-Gear)',
                      style: FerroTypography.title.copyWith(fontSize: 15.0),
                    ),
                    Text(
                      'Headphone / TWS / USB DAC dideteksi otomatis',
                      style: FerroTypography.caption.copyWith(color: FerroColors.onSurfaceMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: FerroDimensions.space12),
          Text(
            'Ferro otomatis mengingat kurva equalizer dan volume target yang Anda tentukan untuk setiap perangkat audio yang terhubung. Begitu Anda colok atau hubungkan Bluetooth, suara langsung disesuaikan.',
            style: FerroTypography.body.copyWith(
              fontSize: 13.0,
              color: FerroColors.onSurfaceMuted,
              height: 1.4,
            ),
          ),
          const SizedBox(height: FerroDimensions.space12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Auto-switch preset saat tersambung',
                style: FerroTypography.captionBold.copyWith(color: FerroColors.onSurface),
              ),
              Switch(
                value: _eq.autoSwitchEnabled,
                onChanged: _eq.toggleAutoSwitch,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceCard(DeviceProfile profile) {
    final isActive = profile.isActive;

    IconData connectionIcon;
    String connectionLabel;
    switch (profile.connectionType) {
      case 'usb':
        connectionIcon = Icons.usb_rounded;
        connectionLabel = 'USB DAC / Dongle';
        break;
      case 'wired':
        connectionIcon = Icons.headphones_rounded;
        connectionLabel = 'Jack 3.5mm Wired';
        break;
      case 'bluetooth':
      default:
        connectionIcon = Icons.bluetooth_audio_rounded;
        connectionLabel = 'Bluetooth Audio';
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: FerroDimensions.space12),
      decoration: BoxDecoration(
        color: FerroColors.surface,
        borderRadius: FerroDimensions.radiusCardAll,
        border: Border.all(
          color: isActive ? FerroColors.primary : FerroColors.divider,
          width: isActive ? 1.5 : 1.0,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: FerroColors.primary.withValues(alpha: 0.12),
                  blurRadius: 16.0,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(FerroDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Icon, Display Name, Active Badge
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: isActive
                        ? FerroColors.primary.withValues(alpha: 0.2)
                        : FerroColors.surfaceHigh,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Icon(
                    connectionIcon,
                    color: isActive ? FerroColors.primaryLight : FerroColors.onSurfaceMuted,
                    size: 22.0,
                  ),
                ),
                const SizedBox(width: FerroDimensions.space12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.displayName,
                        style: FerroTypography.title.copyWith(fontSize: 16.0),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        connectionLabel,
                        style: FerroTypography.caption.copyWith(color: FerroColors.onSurfaceMuted),
                      ),
                    ],
                  ),
                ),
                if (isActive)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: FerroColors.success.withValues(alpha: 0.2),
                      borderRadius: FerroDimensions.radiusPillAll,
                      border: Border.all(color: FerroColors.success, width: 1.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6.0,
                          height: 6.0,
                          decoration: const BoxDecoration(
                            color: FerroColors.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: FerroDimensions.space6),
                        Text(
                          'AKTIF',
                          style: FerroTypography.captionBold.copyWith(
                            color: FerroColors.success,
                            fontSize: 11.0,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const Divider(height: 24.0),

            // Middle Row: EQ Sparkline Curve Preview & Settings info
            Row(
              children: [
                // 10-band Mini Curve Sparkline
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Kurva EQ: ', style: FerroTypography.caption),
                          Text(
                            profile.presetName,
                            style: FerroTypography.captionBold.copyWith(color: FerroColors.primary),
                          ),
                        ],
                      ),
                      const SizedBox(height: FerroDimensions.space8),
                      _buildMiniEqCurve(profile.eqGains),
                    ],
                  ),
                ),
                const SizedBox(width: FerroDimensions.space16),

                // Volume & Effects info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.volume_up_rounded, size: 16.0, color: FerroColors.onSurfaceMuted),
                        const SizedBox(width: 4.0),
                        Text(
                          'Vol: ${profile.savedVolume}%',
                          style: FerroTypography.monoTimer.copyWith(fontSize: 12.0),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Bass: +${profile.bassBoost.round()}%',
                      style: FerroTypography.caption.copyWith(color: FerroColors.onSurfaceMuted),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: FerroDimensions.space12),

            // Bottom Action Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!isActive)
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                    ),
                    icon: const Icon(Icons.check_circle_outline_rounded, size: 16.0, color: FerroColors.primary),
                    label: Text(
                      'Jadikan Aktif',
                      style: FerroTypography.captionBold.copyWith(color: FerroColors.primary),
                    ),
                    onPressed: () {
                      _eq.switchActiveDevice(profile.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Profil aktif diubah ke "${profile.displayName}" 🎧')),
                      );
                    },
                  )
                else
                  Text(
                    'Profil audio sedang aktif digunakan',
                    style: FerroTypography.caption.copyWith(
                      color: FerroColors.success,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20.0),
                      color: FerroColors.onSurfaceMuted,
                      tooltip: 'Edit Profil',
                      onPressed: () => _openEditProfileModal(existingProfile: profile),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, size: 20.0),
                      color: FerroColors.onSurfaceMuted,
                      tooltip: 'Hapus Profil',
                      onPressed: () => _confirmDeleteProfile(profile),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Audiophile 10-bar mini EQ curve preview visualizer
  Widget _buildMiniEqCurve(List<double> gains) {
    return Container(
      height: 32.0,
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: FerroColors.surfaceHigh,
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(gains.length, (i) {
          final gain = gains[i]; // range -12.0 to +12.0
          // Normalized height from 4.0 to 24.0
          final normalizedHeight = ((gain + 12.0) / 24.0 * 20.0 + 4.0).clamp(4.0, 24.0);
          final isElevated = gain > 0;

          return Container(
            width: 4.5,
            height: normalizedHeight,
            decoration: BoxDecoration(
              color: isElevated ? FerroColors.primary : FerroColors.onSurfaceMuted.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(2.0),
            ),
          );
        }),
      ),
    );
  }
}

/// Modal Editor for Device Profiles (Name, Connection Type, Preset, Volume, Effects)
class _DeviceProfileEditorSheet extends StatefulWidget {
  const _DeviceProfileEditorSheet({
    this.profile,
    required this.onSave,
  });

  final DeviceProfile? profile;
  final void Function(DeviceProfile) onSave;

  @override
  State<_DeviceProfileEditorSheet> createState() => _DeviceProfileEditorSheetState();
}

class _DeviceProfileEditorSheetState extends State<_DeviceProfileEditorSheet> {
  late final TextEditingController _nameController;
  late String _connectionType;
  late String _presetName;
  late int _targetVolume;
  late double _bassBoost;
  late double _virtualizer;
  late bool _loudnessNormalization;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _nameController = TextEditingController(text: p?.displayName ?? 'Perangkat Audio Baru');
    _connectionType = p?.connectionType ?? 'bluetooth';
    _presetName = p?.presetName ?? 'Pop';
    _targetVolume = p?.savedVolume ?? 70;
    _bassBoost = p?.bassBoost ?? 25.0;
    _virtualizer = p?.virtualizer ?? 15.0;
    _loudnessNormalization = p?.loudnessNormalization ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      return;
    }

    final p = widget.profile;
    final gains = EqualizerController.presets[_presetName] ??
        p?.eqGains ??
        [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];

    final updated = DeviceProfile(
      id: p?.id ?? 'd_${DateTime.now().millisecondsSinceEpoch}',
      deviceKey: p?.deviceKey ?? 'DEV:${name.replaceAll(' ', '_')}',
      displayName: name,
      connectionType: _connectionType,
      eqGains: List.from(gains),
      presetName: _presetName,
      savedVolume: _targetVolume,
      bassBoost: _bassBoost,
      virtualizer: _virtualizer,
      loudnessNormalization: _loudnessNormalization,
      isActive: p?.isActive ?? false,
    );

    widget.onSave(updated);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isNew = widget.profile == null;

    return Padding(
      padding: EdgeInsets.only(
        left: FerroDimensions.space16,
        right: FerroDimensions.space16,
        top: FerroDimensions.space20,
        bottom: MediaQuery.of(context).viewInsets.bottom + FerroDimensions.space20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sheet Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isNew ? 'Tambah Profil Perangkat' : 'Edit Profil Perangkat',
                  style: FerroTypography.headline.copyWith(fontSize: 18.0),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(height: 20.0),

            // 1. Device Name Field
            Text('Nama Perangkat', style: FerroTypography.captionBold),
            const SizedBox(height: FerroDimensions.space8),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Contoh: Sony WH-1000XM5, IEM KZ, dsb.',
                prefixIcon: Icon(Icons.headphones_rounded, color: FerroColors.primaryLight),
              ),
            ),
            const SizedBox(height: FerroDimensions.space16),

            // 2. Connection Type Selector
            Text('Tipe Koneksi Hardware', style: FerroTypography.captionBold),
            const SizedBox(height: FerroDimensions.space8),
            Row(
              children: [
                _buildConnectionChoice('bluetooth', 'Bluetooth', Icons.bluetooth_audio_rounded),
                const SizedBox(width: FerroDimensions.space8),
                _buildConnectionChoice('usb', 'USB DAC', Icons.usb_rounded),
                const SizedBox(width: FerroDimensions.space8),
                _buildConnectionChoice('wired', 'Jack 3.5mm', Icons.headphones_rounded),
              ],
            ),
            const SizedBox(height: FerroDimensions.space16),

            // 3. EQ Preset Selection
            Text('Preset EQ Awal', style: FerroTypography.captionBold),
            const SizedBox(height: FerroDimensions.space8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: EqualizerController.presets.keys.map((preset) {
                  final isSelected = _presetName == preset;
                  return Padding(
                    padding: const EdgeInsets.only(right: FerroDimensions.space8),
                    child: FerroChip(
                      label: preset,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          _presetName = preset;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: FerroDimensions.space16),

            // 4. Target Volume Slider (0 - 100%)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Volume Target Otomatis', style: FerroTypography.captionBold),
                Text('$_targetVolume%', style: FerroTypography.monoTimer.copyWith(color: FerroColors.primary)),
              ],
            ),
            Slider(
              value: _targetVolume.toDouble(),
              min: 0.0,
              max: 100.0,
              onChanged: (val) {
                setState(() {
                  _targetVolume = val.round();
                });
              },
            ),
            const SizedBox(height: FerroDimensions.space12),

            // 5. Sound Effects (Bass Boost & Loudness)
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Normalisasi Volume', style: FerroTypography.body),
              value: _loudnessNormalization,
              onChanged: (val) {
                setState(() {
                  _loudnessNormalization = val;
                });
              },
            ),
            const SizedBox(height: FerroDimensions.space20),

            // 6. Action Buttons
            Row(
              children: [
                Expanded(
                  child: FerroButton(
                    label: 'Batal',
                    variant: FerroButtonVariant.outline,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: FerroDimensions.space12),
                Expanded(
                  child: FerroButton(
                    label: 'Simpan Profil',
                    variant: FerroButtonVariant.filled,
                    onPressed: _submit,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionChoice(String type, String label, IconData icon) {
    final isSelected = _connectionType == type;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _connectionType = type;
          });
        },
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
            color: isSelected ? FerroColors.primary.withValues(alpha: 0.2) : FerroColors.surfaceHigh,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: isSelected ? FerroColors.primary : FerroColors.divider,
              width: 1.0,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 20.0,
                color: isSelected ? FerroColors.primaryLight : FerroColors.onSurfaceMuted,
              ),
              const SizedBox(height: 4.0),
              Text(
                label,
                style: FerroTypography.captionBold.copyWith(
                  fontSize: 10.5,
                  color: isSelected ? FerroColors.primaryLight : FerroColors.onSurfaceMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
