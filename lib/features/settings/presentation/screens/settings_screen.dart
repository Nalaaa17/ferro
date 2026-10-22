import 'package:flutter/material.dart';
import 'package:ferro/app/theme/theme.dart';
import 'package:ferro/features/devices/presentation/screens/devices_screen.dart';
import 'package:ferro/features/equalizer/presentation/screens/equalizer_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          // Audio Settings Group
          _buildSettingsGroup(
            title: 'Audio',
            tiles: [
              _buildTile(
                icon: Icons.equalizer_rounded,
                title: 'Equalizer & Sound Effects',
                subtitle: '10-Band EQ, Bass Boost, Virtualizer',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const EqualizerScreen()),
                  );
                },
              ),
              _buildTile(
                icon: Icons.headphones_rounded,
                title: 'Perangkat Saya (Per-Gear)',
                subtitle: 'Auto-switch EQ & volume per perangkat',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const DevicesScreen()),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: FerroDimensions.space20),

          // About & Privacy Group
          _buildSettingsGroup(
            title: 'Aplikasi',
            tiles: [
              _buildTile(
                icon: Icons.info_outline_rounded,
                title: 'Tentang Ferro',
                subtitle: 'Versi v1.0.0-beta • 100% Offline',
                onTap: () {},
              ),
              _buildTile(
                icon: Icons.favorite_border_rounded,
                title: 'Donasi (Trakteer / Buy Me a Coffee)',
                subtitle: 'Dukung pengembangan Ferro gratis tanpa iklan',
                onTap: () {},
              ),
            ],
          ),
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
            ),
          ),
        ),
        Card(
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
      title: Text(title, style: FerroTypography.title.copyWith(fontSize: 15.0)),
      subtitle: Text(subtitle, style: FerroTypography.caption),
      trailing: const Icon(Icons.chevron_right_rounded, color: FerroColors.onSurfaceMuted),
      onTap: onTap,
    );
  }
}
