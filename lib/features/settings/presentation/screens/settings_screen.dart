import 'package:flutter/material.dart';
import 'package:ferro/app/theme/theme.dart';
import 'package:ferro/core/widgets/widgets.dart';
import 'package:ferro/features/car_mode/presentation/screens/car_mode_screen.dart';
import 'package:ferro/features/devices/presentation/screens/devices_screen.dart';
import 'package:ferro/features/equalizer/presentation/screens/equalizer_screen.dart';
import 'package:ferro/features/player/presentation/providers/player_controller.dart';
import 'package:ferro/data/repositories/mock_repositories.dart';

/// Modern Grouped Inset Settings Screen per PRD §4.4.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Audio Settings State
  double _crossfadeSeconds = 3.0; // 0 = Nonaktif, 1 - 12 detik
  bool _gaplessPlayback = true;

  // Library Settings State
  bool _ignoreShortAudio = true; // Abaikan < 30 detik
  final Set<String> _excludedFolders = {'WhatsApp Audio', 'Recordings'};

  // Display Settings State
  bool _amoledMode = false;
  String _selectedLanguage = 'Bahasa Indonesia';

  void _showExcludeFolderDialog() {
    final candidateFolders = [
      'WhatsApp Audio',
      'Telegram Audio',
      'Recordings',
      'Voice Notes',
      'Notifications / Ringtones',
      'Android / Media / Cache',
    ];

    showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: FerroColors.surface,
              shape: const RoundedRectangleBorder(
                borderRadius: FerroDimensions.radiusCardAll,
                side: BorderSide(color: FerroColors.divider),
              ),
              title: Text(
                'Folder yang Diabaikan',
                style: FerroTypography.headline.copyWith(fontSize: 18.0),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Pilih folder yang tidak ingin dimasukkan ke dalam daftar lagu library:',
                      style: FerroTypography.caption.copyWith(color: FerroColors.onSurfaceMuted),
                    ),
                    const SizedBox(height: FerroDimensions.space12),
                    ...candidateFolders.map((folder) {
                      final isExcluded = _excludedFolders.contains(folder);
                      return CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        activeColor: FerroColors.primary,
                        title: Text(folder, style: FerroTypography.body),
                        value: isExcluded,
                        onChanged: (val) {
                          setDialogState(() {
                            if (val == true) {
                              _excludedFolders.add(folder);
                            } else {
                              _excludedFolders.remove(folder);
                            }
                          });
                          setState(() {});
                        },
                      );
                    }),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Tutup', style: FerroTypography.body.copyWith(color: FerroColors.primary)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _rescanLibrary() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: FerroColors.surface,
          shape: const RoundedRectangleBorder(
            borderRadius: FerroDimensions.radiusCardAll,
            side: BorderSide(color: FerroColors.divider),
          ),
          child: Padding(
            padding: const EdgeInsets.all(FerroDimensions.space24),
            child: Row(
              children: [
                const CircularProgressIndicator(color: FerroColors.primary),
                const SizedBox(width: FerroDimensions.space20),
                Text('Memindai koleksi audio...', style: FerroTypography.body),
              ],
            ),
          ),
        );
      },
    );

    // Simulate rescan
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pemindaian selesai: 142 file musik lokal terindeks 🎵'),
          ),
        );
      }
    });
  }

  void _showDonationDialog() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: FerroColors.surface,
          shape: const RoundedRectangleBorder(
            borderRadius: FerroDimensions.radiusCardAll,
            side: BorderSide(color: FerroColors.divider),
          ),
          title: Row(
            children: [
              const Icon(Icons.favorite_rounded, color: FerroColors.error, size: 24.0),
              const SizedBox(width: FerroDimensions.space8),
              Text('Dukung Ferro Player', style: FerroTypography.headline.copyWith(fontSize: 18.0)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ferro dikembangkan secara 100% offline, bebas iklan selamanya, dan gratis untuk komunitas audiophile.',
                style: FerroTypography.body.copyWith(height: 1.4),
              ),
              const SizedBox(height: FerroDimensions.space16),
              Card(
                color: FerroColors.surfaceHigh,
                child: Padding(
                  padding: const EdgeInsets.all(FerroDimensions.space12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.coffee_rounded, color: FerroColors.primaryLight),
                          const SizedBox(width: FerroDimensions.space12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Trakteer / Saweria', style: FerroTypography.title.copyWith(fontSize: 14.0)),
                                Text('Mulai dari Rp 5.000 via QRIS / GoPay', style: FerroTypography.caption),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: FerroDimensions.space12),
                      Row(
                        children: [
                          const Icon(Icons.public_rounded, color: FerroColors.primaryLight),
                          const SizedBox(width: FerroDimensions.space12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Buy Me a Coffee / GitHub Sponsors', style: FerroTypography.title.copyWith(fontSize: 14.0)),
                                Text('Dukungan internasional via PayPal / Stripe', style: FerroTypography.caption),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Tutup', style: FerroTypography.body.copyWith(color: FerroColors.onSurfaceMuted)),
            ),
            FerroButton(
              label: 'Buka Trakteer',
              height: 38.0,
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Membuka tautan donasi Trakteer di browser')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showGitHubUpdateDialog() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: FerroColors.surface,
          shape: const RoundedRectangleBorder(
            borderRadius: FerroDimensions.radiusCardAll,
            side: BorderSide(color: FerroColors.divider),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: FerroColors.primary.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.system_update_rounded, color: FerroColors.primaryLight, size: 20.0),
              ),
              const SizedBox(width: FerroDimensions.space8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pembaruan Tersedia!', style: FerroTypography.headline.copyWith(fontSize: 17.0)),
                    Text('v1.1.0-beta • GitHub Releases', style: FerroTypography.caption.copyWith(color: FerroColors.primary)),
                  ],
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Versi terbaru Ferro Player telah dirilis di GitHub dengan pembaruan:',
                style: FerroTypography.caption.copyWith(color: FerroColors.onSurfaceMuted),
              ),
              const SizedBox(height: FerroDimensions.space12),
              Container(
                padding: const EdgeInsets.all(FerroDimensions.space12),
                decoration: BoxDecoration(
                  color: FerroColors.surfaceHigh,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: FerroColors.divider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildReleaseNote('✨ Dukungan format DSD (.dsf / .dff) native Direct Stream'),
                    _buildReleaseNote('🎤 Peningkatan akurasi sinkronisasi karaoke lirik kata demi kata'),
                    _buildReleaseNote('⚡ Optimasi pemindaian pustaka lokal 40% lebih cepat'),
                    _buildReleaseNote('🔋 Pengurangan konsumsi baterai pemutaran di latar belakang'),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Nanti Saja', style: FerroTypography.body.copyWith(color: FerroColors.onSurfaceMuted)),
            ),
            FerroButton(
              label: 'Unduh APK (GitHub)',
              icon: Icons.download_rounded,
              height: 38.0,
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mengunduh APK v1.1.0-beta dari GitHub Releases...')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildReleaseNote(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(text, style: FerroTypography.caption.copyWith(fontSize: 11.5, height: 1.35)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final crossfadeLabel = _crossfadeSeconds == 0 ? 'Nonaktif' : '${_crossfadeSeconds.toInt()} detik';

    return Scaffold(
      backgroundColor: FerroColors.background,
      appBar: AppBar(
        title: Text('Pengaturan', style: FerroTypography.display.copyWith(fontSize: 22.0)),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: FerroDimensions.space16,
          vertical: FerroDimensions.space12,
        ),
        children: [
          // 1. Audio Settings Group
          _buildSettingsGroup(
            title: 'AUDIO & DSP',
            tiles: [
              _buildTile(
                icon: Icons.equalizer_rounded,
                title: 'Equalizer & Efek Suara',
                subtitle: '10-Band EQ, Bass Boost, Virtualizer 3D',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const EqualizerScreen()),
                  );
                },
              ),
              _buildTile(
                icon: Icons.headphones_rounded,
                title: 'Perangkat Saya (Per-Gear Auto Preset)',
                subtitle: 'Auto-switch EQ & volume per perangkat',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const DevicesScreen()),
                  );
                },
              ),
              _buildTile(
                icon: Icons.sync_rounded,
                title: 'Pindai Pustaka Audio',
                subtitle: 'Pindai penyimpanan HP untuk mendeteksi file lagu baru',
                onTap: () => _handleRescan(context),
              ),
              // Crossfade Tile with Slider
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: FerroDimensions.space16,
                  vertical: FerroDimensions.space8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.compare_arrows_rounded, color: FerroColors.primaryLight, size: 22.0),
                            const SizedBox(width: FerroDimensions.space12),
                            Text('Transisi Lagu (Crossfade)', style: FerroTypography.title.copyWith(fontSize: 14.5)),
                          ],
                        ),
                        Text(
                          crossfadeLabel,
                          style: FerroTypography.monoTimer.copyWith(color: FerroColors.primary),
                        ),
                      ],
                    ),
                    Slider(
                      value: _crossfadeSeconds,
                      min: 0.0,
                      max: 12.0,
                      divisions: 12,
                      onChanged: (val) {
                        setState(() {
                          _crossfadeSeconds = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
              // Gapless Playback Switch
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: FerroDimensions.space16),
                secondary: const Icon(Icons.sync_rounded, color: FerroColors.primaryLight),
                title: Text('Gapless Playback', style: FerroTypography.title.copyWith(fontSize: 14.5)),
                subtitle: Text('Menghilangkan jeda sunyi antar trek lagu live/konser', style: FerroTypography.caption),
                value: _gaplessPlayback,
                onChanged: (val) {
                  setState(() {
                    _gaplessPlayback = val;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: FerroDimensions.space20),

          // 2. Library & File Storage Group
          _buildSettingsGroup(
            title: 'PUSTAKA & FILE MEDIA',
            tiles: [
              _buildTile(
                icon: Icons.folder_off_outlined,
                title: 'Folder yang Diabaikan (Exclude)',
                subtitle: '${_excludedFolders.length} folder diabaikan (WhatsApp, Recordings)',
                onTap: _showExcludeFolderDialog,
              ),
              _buildTile(
                icon: Icons.refresh_rounded,
                title: 'Pindai Ulang Koleksi Musik',
                subtitle: 'Sinkronisasi ulang file audio lokal di perangkat',
                onTap: _rescanLibrary,
              ),
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: FerroDimensions.space16),
                secondary: const Icon(Icons.timer_outlined, color: FerroColors.primaryLight),
                title: Text('Abaikan File Audio Singkat', style: FerroTypography.title.copyWith(fontSize: 14.5)),
                subtitle: Text('Jangan masukkan file suara berdurasi di bawah 30 detik', style: FerroTypography.caption),
                value: _ignoreShortAudio,
                onChanged: (val) {
                  setState(() {
                    _ignoreShortAudio = val;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: FerroDimensions.space20),

          // 3. Display & Interface Group
          _buildSettingsGroup(
            title: 'TAMPILAN & ANTARMUKA',
            tiles: [
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: FerroDimensions.space16),
                secondary: const Icon(Icons.dark_mode_rounded, color: FerroColors.primaryLight),
                title: Text('Mode Gelap AMOLED Pitch Black', style: FerroTypography.title.copyWith(fontSize: 14.5)),
                subtitle: Text('Menggunakan latar belakang hitam murni #000000', style: FerroTypography.caption),
                value: _amoledMode,
                onChanged: (val) {
                  setState(() {
                    _amoledMode = val;
                  });
                },
              ),
              _buildTile(
                icon: Icons.directions_car_rounded,
                title: 'Mode Mengemudi (Car Mode)',
                subtitle: 'Antarmuka tombol besar minim distraksi',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const CarModeScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.language_rounded, color: FerroColors.primaryLight),
                title: Text('Bahasa Aplikasi', style: FerroTypography.title.copyWith(fontSize: 14.5)),
                subtitle: Text(_selectedLanguage, style: FerroTypography.caption),
                trailing: const Icon(Icons.chevron_right_rounded, color: FerroColors.onSurfaceMuted),
                onTap: () {
                  setState(() {
                    _selectedLanguage = _selectedLanguage == 'Bahasa Indonesia' ? 'English' : 'Bahasa Indonesia';
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Bahasa diubah ke $_selectedLanguage')),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: FerroDimensions.space20),

          // 4. Info App & Donations Group
          _buildSettingsGroup(
            title: 'TENTANG & PEMBARUAN',
            tiles: [
              _buildTile(
                icon: Icons.info_outline_rounded,
                title: 'Tentang Ferro Player',
                subtitle: 'v1.0.0-beta • 100% Offline & Open Source',
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'FERRO Player',
                    applicationVersion: 'v1.0.0-beta (Build 2026.10)',
                    applicationIcon: Image.asset(
                      'assets/images/ferro_logo.png',
                      width: 48.0,
                      height: 48.0,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.graphic_eq_rounded,
                        size: 48.0,
                        color: FerroColors.primary,
                      ),
                    ),
                    children: [
                      const Text(
                        'Universal Offline Audio & Video-Audio Player dengan fitur Per-Gear Auto Preset, 10-Band EQ, dan lirik tersinkronisasi.',
                      ),
                    ],
                  );
                },
              ),
              _buildTile(
                icon: Icons.system_update_rounded,
                title: 'Periksa Pembaruan Aplikasi',
                subtitle: 'Cek rilis APK versi terbaru di GitHub Releases',
                onTap: _showGitHubUpdateDialog,
              ),
              _buildTile(
                icon: Icons.favorite_border_rounded,
                title: 'Donasi Pengembang (Trakteer / Buy Me a Coffee)',
                subtitle: 'Dukung pengembangan Ferro gratis tanpa iklan',
                onTap: _showDonationDialog,
              ),
            ],
          ),
          const SizedBox(height: 100.0), // Spacing for MiniPlayer
        ],
      ),
    );
  }

  Widget _buildSettingsGroup({required String title, required List<Widget> tiles}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: FerroDimensions.space8, bottom: FerroDimensions.space8),
          child: Text(
            title,
            style: FerroTypography.captionBold.copyWith(
              color: FerroColors.primary,
              letterSpacing: 1.0,
              fontSize: 11.0,
            ),
          ),
        ),
        Card(
          margin: EdgeInsets.zero,
          child: Column(
            children: tiles,
          ),
        ),
      ],
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: FerroColors.primaryLight),
      title: Text(title, style: FerroTypography.title.copyWith(fontSize: 14.5)),
      subtitle: Text(subtitle, style: FerroTypography.caption),
      trailing: const Icon(Icons.chevron_right_rounded, color: FerroColors.onSurfaceMuted),
      onTap: onTap,
    );
  }

  Future<void> _handleRescan(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Memindai penyimpanan perangkat untuk file musik...'),
        duration: Duration(seconds: 2),
      ),
    );
    final count = await PlayerController.instance.scanDeviceMusic(MockSongRepository());
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(count > 0
              ? 'Pemindaian selesai: $count lagu ditemukan!'
              : 'Pemindaian selesai. Pustaka audio siap diputar.'),
        ),
      );
    }
  }
}
