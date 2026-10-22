import 'package:flutter/material.dart';
import 'package:ferro/app/theme/theme.dart';
import 'package:ferro/core/widgets/widgets.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FerroColors.background,
      appBar: AppBar(
        title: Text('Cari', style: FerroTypography.display.copyWith(fontSize: 22.0)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: FerroDimensions.space16,
          vertical: FerroDimensions.space12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Input Field
            const TextField(
              decoration: InputDecoration(
                hintText: 'Cari lagu, artis, atau album...',
                prefixIcon: Icon(Icons.search_rounded, color: FerroColors.onSurfaceMuted),
              ),
            ),
            const SizedBox(height: FerroDimensions.space24),

            // Recent Searches Chips
            Text('Pencarian Terakhir', style: FerroTypography.title),
            const SizedBox(height: FerroDimensions.space12),
            Wrap(
              spacing: FerroDimensions.space8,
              runSpacing: FerroDimensions.space8,
              children: [
                FerroChip(label: 'Daft Punk', isSelected: false, onTap: () {}),
                FerroChip(label: 'Abbey Road', isSelected: false, onTap: () {}),
                FerroChip(label: 'FLAC 24-bit', isSelected: false, onTap: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
