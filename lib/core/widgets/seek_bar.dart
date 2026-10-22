import 'package:flutter/material.dart';
import 'package:ferro/app/theme/theme.dart';

/// Custom Seekbar widget featuring 3dp progress track with Ferro gradient and animated thumb per PRD §3.5.
class FerroSeekBar extends StatefulWidget {
  const FerroSeekBar({
    super.key,
    required this.position,
    required this.duration,
    this.bufferedPosition,
    this.onChanged,
    this.onChangeEnd,
    this.showTimeLabels = true,
  });

  final Duration position;
  final Duration duration;
  final Duration? bufferedPosition;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;
  final bool showTimeLabels;

  @override
  State<FerroSeekBar> createState() => _FerroSeekBarState();
}

class _FerroSeekBarState extends State<FerroSeekBar> {
  double? _dragValue;
  bool _isDragging = false;
  bool _isHovered = false;

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (duration.inHours > 0) {
      final hours = duration.inHours.toString();
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final totalDurationMs = widget.duration.inMilliseconds.toDouble();
    final effectiveTotalMs = totalDurationMs > 0 ? totalDurationMs : 1.0;

    final currentPositionMs = _dragValue ?? widget.position.inMilliseconds.toDouble();
    final clampedPositionMs = currentPositionMs.clamp(0.0, effectiveTotalMs);

    final bufferedPositionMs = (widget.bufferedPosition?.inMilliseconds.toDouble() ?? 0.0)
        .clamp(0.0, effectiveTotalMs);

    final progressRatio = (clampedPositionMs / effectiveTotalMs).clamp(0.0, 1.0);
    final bufferRatio = (bufferedPositionMs / effectiveTotalMs).clamp(0.0, 1.0);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Track and Scrubber Area
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragStart: (details) {
              setState(() {
                _isDragging = true;
              });
              _updateDrag(details.localPosition.dx, context.size?.width ?? 1.0, effectiveTotalMs);
            },
            onHorizontalDragUpdate: (details) {
              _updateDrag(details.localPosition.dx, context.size?.width ?? 1.0, effectiveTotalMs);
            },
            onHorizontalDragEnd: (_) {
              if (_dragValue != null && widget.onChangeEnd != null) {
                widget.onChangeEnd!(Duration(milliseconds: _dragValue!.round()));
              }
              setState(() {
                _isDragging = false;
                _dragValue = null;
              });
            },
            onTapDown: (details) {
              _updateDrag(details.localPosition.dx, context.size?.width ?? 1.0, effectiveTotalMs);
              if (_dragValue != null && widget.onChangeEnd != null) {
                widget.onChangeEnd!(Duration(milliseconds: _dragValue!.round()));
              }
              setState(() {
                _dragValue = null;
              });
            },
            child: SizedBox(
              height: 24.0, // Touch target
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  // 1. Inactive Background Track (3dp)
                  Container(
                    width: double.infinity,
                    height: 3.0,
                    decoration: BoxDecoration(
                      color: FerroColors.divider,
                      borderRadius: BorderRadius.circular(1.5),
                    ),
                  ),

                  // 2. Buffered Track (3dp)
                  FractionallySizedBox(
                    widthFactor: bufferRatio,
                    child: Container(
                      height: 3.0,
                      decoration: BoxDecoration(
                        color: FerroColors.surfaceHigh,
                        borderRadius: BorderRadius.circular(1.5),
                      ),
                    ),
                  ),

                  // 3. Active Progress Track (3dp with Gradient)
                  FractionallySizedBox(
                    widthFactor: progressRatio,
                    child: Container(
                      height: 3.0,
                      decoration: BoxDecoration(
                        gradient: FerroColors.primaryGradient,
                        borderRadius: BorderRadius.circular(1.5),
                      ),
                    ),
                  ),

                  // 4. Thumb (Animates size on drag/hover)
                  Align(
                    alignment: Alignment(progressRatio * 2.0 - 1.0, 0.0),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: (_isDragging || _isHovered) ? 14.0 : 0.0,
                      height: (_isDragging || _isHovered) ? 14.0 : 0.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: FerroColors.primary.withValues(alpha: 0.6),
                            blurRadius: 8.0,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Time Labels (Mono Timer)
          if (widget.showTimeLabels) ...[
            const SizedBox(height: FerroDimensions.space4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(Duration(milliseconds: clampedPositionMs.round())),
                  style: FerroTypography.monoTimer,
                ),
                Text(
                  _formatDuration(widget.duration),
                  style: FerroTypography.monoTimer,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _updateDrag(double localX, double totalWidth, double totalMs) {
    if (totalWidth <= 0) return;
    final ratio = (localX / totalWidth).clamp(0.0, 1.0);
    final newMs = ratio * totalMs;
    setState(() {
      _dragValue = newMs;
    });
    if (widget.onChanged != null) {
      widget.onChanged!(Duration(milliseconds: newMs.round()));
    }
  }
}
