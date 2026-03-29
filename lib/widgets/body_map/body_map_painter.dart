import 'package:flutter/material.dart';
import 'package:korpomap/models/muscle_group.dart';
import 'body_map_data.dart';

/// Renders the body silhouette and muscle groups on a Canvas
class BodyMapPainter extends CustomPainter {
  final BodySide side;
  final Map<MuscleGroupId, Color> muscleColors;
  final MuscleGroupId? selectedGroup;

  // Color palette
  static const _skinLight = Color(0xFFF8F0E8);
  static const _muscleFill = Color(0xFFE6CEBC);
  static const _muscleBorder = Color(0xFFCCB5A3);
  static const _outlineBorder = Color(0xFFBCA898);
  static const _selectedColor = Color(0xFF8B5CF6);

  BodyMapPainter({
    required this.side,
    this.muscleColors = const {},
    this.selectedGroup,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawOutline(canvas, size);
    _drawMuscleGroups(canvas, size);
    _drawLabels(canvas, size);
  }

  void _drawOutline(Canvas canvas, Size size) {
    final outline = BodyMapData.getBodyOutline(size);

    // Shadow
    canvas.drawPath(
      outline.shift(const Offset(2, 3)),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.06)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    // Fill
    canvas.drawPath(outline, Paint()
      ..color = _skinLight
      ..style = PaintingStyle.fill
    );

    // Border
    canvas.drawPath(outline, Paint()
      ..color = _outlineBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeJoin = StrokeJoin.round
    );
  }

  void _drawMuscleGroups(Canvas canvas, Size size) {
    final paths = side == BodySide.anterior
        ? BodyMapData.getAnteriorPaths(size)
        : BodyMapData.getPosteriorPaths(size);

    for (final entry in paths.entries) {
      final id = entry.key;
      final path = entry.value;
      final isSelected = id == selectedGroup;

      // Fill
      final baseColor = muscleColors[id] ?? _muscleFill;
      final fillColor = isSelected
          ? _selectedColor.withValues(alpha: 0.25)
          : baseColor;

      canvas.drawPath(path, Paint()
        ..color = fillColor
        ..style = PaintingStyle.fill
      );

      // Border
      final borderColor = isSelected ? _selectedColor : _muscleBorder;
      canvas.drawPath(path, Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = isSelected ? 2.5 : 0.8
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round
      );
    }
  }

  void _drawLabels(Canvas canvas, Size size) {
    if (selectedGroup == null) return;

    final paths = side == BodySide.anterior
        ? BodyMapData.getAnteriorPaths(size)
        : BodyMapData.getPosteriorPaths(size);

    final path = paths[selectedGroup];
    if (path == null) return;

    final group = MuscleGroup.all[selectedGroup];
    if (group == null) return;

    // Get center of the path bounds
    final bounds = path.getBounds();
    final center = bounds.center;

    // Draw label background
    final textSpan = TextSpan(
      text: group.label,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
    final tp = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    final padding = 6.0;
    final bgRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx, bounds.top - 14),
        width: tp.width + padding * 2,
        height: tp.height + padding,
      ),
      const Radius.circular(6),
    );

    canvas.drawRRect(bgRect, Paint()
      ..color = _selectedColor
      ..style = PaintingStyle.fill
    );

    tp.paint(canvas, Offset(
      center.dx - tp.width / 2,
      bounds.top - 14 - tp.height / 2,
    ));
  }

  @override
  bool shouldRepaint(covariant BodyMapPainter oldDelegate) {
    return side != oldDelegate.side
        || muscleColors != oldDelegate.muscleColors
        || selectedGroup != oldDelegate.selectedGroup;
  }
}
