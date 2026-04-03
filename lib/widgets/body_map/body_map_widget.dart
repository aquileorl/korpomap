import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:korpomap/models/muscle_group.dart';
import 'package:path_parsing/path_parsing.dart';
import 'dart:ui' as ui;
import 'package:xml/xml.dart';

/// Interactive body map with anterior/posterior toggle using SVG
class BodyMapWidget extends StatefulWidget {
  final Map<MuscleGroupId, Color> muscleColors;
  final ValueChanged<MuscleGroupId>? onMuscleGroupTap;

  const BodyMapWidget({
    super.key,
    this.muscleColors = const {},
    this.onMuscleGroupTap,
  });

  @override
  State<BodyMapWidget> createState() => _BodyMapWidgetState();
}

/// Maps SVG group IDs to MuscleGroupId
const Map<String, MuscleGroupId> _anteriorIdMap = {
  'head_front': MuscleGroupId.neckFront, // head mapped to neck for simplicity
  'neck_front': MuscleGroupId.neckFront,
  'trapezius_front': MuscleGroupId.shouldersFront,
  'chest': MuscleGroupId.chest,
  'shoulders_front': MuscleGroupId.shouldersFront,
  'biceps': MuscleGroupId.biceps,
  'triceps': MuscleGroupId.triceps,
  'obliques': MuscleGroupId.obliques,
  'abs': MuscleGroupId.abdominals,
  'forearms_front': MuscleGroupId.forearmsFront,
  'hands_front': MuscleGroupId.handsFront,
  'adductors': MuscleGroupId.adductors,
  'quadriceps': MuscleGroupId.quadriceps,
  'knees_front': MuscleGroupId.knees,
  'shins': MuscleGroupId.shinsFront,
  'calves_front': MuscleGroupId.calvesFront,
  'ankles_front': MuscleGroupId.anklesFront,
  'feet_front': MuscleGroupId.feetFront,
};

const Map<String, MuscleGroupId> _posteriorIdMap = {
  'head_back': MuscleGroupId.neckBack,
  'neck_back': MuscleGroupId.neckBack,
  'trapezius': MuscleGroupId.trapezius,
  'shoulders_back': MuscleGroupId.shouldersBack,
  'upper_back': MuscleGroupId.upperBack,
  'triceps_back': MuscleGroupId.tricepsBack,
  'lower_back': MuscleGroupId.lowerBack,
  'forearms_back': MuscleGroupId.forearmsBack,
  'hands_back': MuscleGroupId.handsBack,
  'glutes': MuscleGroupId.glutes,
  'adductors_back': MuscleGroupId.adductorsBack,
  'hamstrings': MuscleGroupId.hamstrings,
  'calves': MuscleGroupId.calves,
  'ankles_back': MuscleGroupId.anklesBack,
  'feet_back': MuscleGroupId.feetBack,
};

class _BodyMapWidgetState extends State<BodyMapWidget> {
  BodySide _currentSide = BodySide.anterior;
  MuscleGroupId? _selectedGroup;
  final _svgKey = GlobalKey();
  final _transformController = TransformationController();

  // Parsed hit regions: MuscleGroupId -> list of Path objects
  Map<MuscleGroupId, List<ui.Path>>? _anteriorPaths;
  Map<MuscleGroupId, List<ui.Path>>? _posteriorPaths;

  // SVG viewBox
  final double _svgWidth = 724;
  final double _svgHeight = 1448;

  String get _assetPath => _currentSide == BodySide.anterior
      ? 'assets/images/body_anterior.svg'
      : 'assets/images/body_posterior.svg';

  @override
  void initState() {
    super.initState();
    _loadPaths();
  }

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  Future<void> _loadPaths() async {
    _anteriorPaths = await _parseSvgPaths('assets/images/body_anterior.svg', _anteriorIdMap, 0);
    _posteriorPaths = await _parseSvgPaths('assets/images/body_posterior.svg', _posteriorIdMap, 0);
    if (mounted) setState(() {});
  }

  /// Parses SVG file and extracts Flutter Path objects for each muscle group
  Future<Map<MuscleGroupId, List<ui.Path>>> _parseSvgPaths(
    String asset, Map<String, MuscleGroupId> idMap, double offsetX,
  ) async {
    final svgString = await rootBundle.loadString(asset);
    final doc = XmlDocument.parse(svgString);
    final result = <MuscleGroupId, List<ui.Path>>{};

    for (final g in doc.findAllElements('g')) {
      final id = g.getAttribute('id');
      if (id == null || !idMap.containsKey(id)) continue;

      final muscleId = idMap[id]!;
      final paths = result[muscleId] ?? [];

      for (final pathEl in g.findElements('path')) {
        final d = pathEl.getAttribute('d');
        if (d == null) continue;
        try {
          final flutterPath = ui.Path();
          final proxy = _FlutterPathProxy(flutterPath, offsetX);
          writeSvgPathDataToPath(d, proxy);
          paths.add(flutterPath);
        } catch (_) {
          // Skip paths that fail to parse
        }
      }

      if (paths.isNotEmpty) {
        result[muscleId] = paths;
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Toggle
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildToggle('Anterior', BodySide.anterior),
              _buildToggle('Posterior', BodySide.posterior),
            ],
          ),
        ),

        // SVG body map with zoom/pan
        Expanded(
          child: InteractiveViewer(
            transformationController: _transformController,
            minScale: 1.0,
            maxScale: 3.0,
            child: Center(
              child: AspectRatio(
                aspectRatio: _svgWidth / _svgHeight,
                child: GestureDetector(
                  key: _svgKey,
                  onTapUp: _handleTap,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Stack(
                        children: [
                          SvgPicture.asset(
                            _assetPath,
                            fit: BoxFit.fill,
                            width: constraints.maxWidth,
                            height: constraints.maxHeight,
                          ),
                          if (widget.muscleColors.isNotEmpty)
                            CustomPaint(
                              size: Size(
                                constraints.maxWidth,
                                constraints.maxHeight,
                              ),
                              painter: _MuscleColorPainter(
                                paths: _currentSide == BodySide.anterior
                                    ? _anteriorPaths
                                    : _posteriorPaths,
                                colors: widget.muscleColors,
                                svgWidth: _svgWidth,
                                svgHeight: _svgHeight,
                                svgOffsetX: _currentSide == BodySide.posterior
                                    ? 724.0
                                    : 0.0,
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),

        // Selected label
        if (_selectedGroup != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                MuscleGroup.all[_selectedGroup]?.label ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _handleTap(TapUpDetails details) {
    final box = _svgKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;

    final localPos = details.localPosition;
    final widgetSize = box.size;

    // Convert tap to SVG coordinates
    final offsetX = _currentSide == BodySide.posterior ? 724.0 : 0.0;
    final svgX = (localPos.dx / widgetSize.width) * _svgWidth + offsetX;
    final svgY = (localPos.dy / widgetSize.height) * _svgHeight;

    final hitPaths = _currentSide == BodySide.anterior
        ? _anteriorPaths
        : _posteriorPaths;

    if (hitPaths == null) return;

    // Hit test using Path.contains - pixel perfect
    for (final entry in hitPaths.entries) {
      for (final path in entry.value) {
        if (path.contains(Offset(svgX, svgY))) {
          setState(() => _selectedGroup = entry.key);
          widget.onMuscleGroupTap?.call(entry.key);
          return;
        }
      }
    }
    setState(() => _selectedGroup = null);
  }

  Widget _buildToggle(String label, BodySide side) {
    final isActive = _currentSide == side;
    return GestureDetector(
      onTap: () => setState(() {
        _currentSide = side;
        _selectedGroup = null;
        _transformController.value = Matrix4.identity();
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF8B5CF6) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey[600],
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

/// Paints semi-transparent color overlays on muscle group paths.
class _MuscleColorPainter extends CustomPainter {
  final Map<MuscleGroupId, List<ui.Path>>? paths;
  final Map<MuscleGroupId, Color> colors;
  final double svgWidth;
  final double svgHeight;
  final double svgOffsetX;

  _MuscleColorPainter({
    this.paths,
    required this.colors,
    required this.svgWidth,
    required this.svgHeight,
    this.svgOffsetX = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (paths == null || colors.isEmpty) return;

    final scaleX = size.width / svgWidth;
    final scaleY = size.height / svgHeight;

    canvas.save();
    canvas.scale(scaleX, scaleY);
    // Shift posterior paths (viewBox starts at 724) back to widget origin
    if (svgOffsetX > 0) {
      canvas.translate(-svgOffsetX, 0);
    }

    for (final entry in colors.entries) {
      final groupPaths = paths![entry.key];
      if (groupPaths == null) continue;

      final paint = Paint()
        ..color = entry.value.withValues(alpha: 0.4)
        ..style = PaintingStyle.fill;

      for (final path in groupPaths) {
        canvas.drawPath(path, paint);
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _MuscleColorPainter old) =>
      old.colors != colors || old.paths != paths;
}

/// Proxy that converts SVG path commands to Flutter Path operations
/// with an optional X offset for posterior viewBox
class _FlutterPathProxy extends PathProxy {
  final ui.Path path;
  final double offsetX;

  _FlutterPathProxy(this.path, this.offsetX);

  @override
  void close() => path.close();

  @override
  void cubicTo(double x1, double y1, double x2, double y2, double x3, double y3) =>
      path.cubicTo(x1 + offsetX, y1, x2 + offsetX, y2, x3 + offsetX, y3);

  @override
  void lineTo(double x, double y) => path.lineTo(x + offsetX, y);

  @override
  void moveTo(double x, double y) => path.moveTo(x + offsetX, y);
}
