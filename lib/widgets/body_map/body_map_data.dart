import 'dart:ui';
import 'package:korpomap/models/muscle_group.dart';

/// Normalized path definitions for the body map.
/// All coordinates are in 0.0–1.0 range, scaled to actual size at paint time.
/// Design canvas reference: 400w x 800h
class BodyMapData {

  BodyMapData._();

  static const double aspectRatio = 400 / 800;

  // ──────────────────────────────────────────────
  // BODY OUTLINE – smooth anatomical silhouette
  // ──────────────────────────────────────────────

  static Path getBodyOutline(Size s) {
    final w = s.width;
    final h = s.height;
    final path = Path();

    // Head (oval, slightly taller than wide)
    path.addOval(Rect.fromCenter(
      center: Offset(w * 0.500, h * 0.052),
      width: w * 0.155,
      height: h * 0.085,
    ));

    // Neck + body as one continuous path (left side, then right side)
    final body = Path()
      // Start at left neck
      ..moveTo(w * 0.440, h * 0.090)
      // Neck left side
      ..quadraticBezierTo(w * 0.435, h * 0.105, w * 0.430, h * 0.115)
      // Left shoulder slope
      ..quadraticBezierTo(w * 0.370, h * 0.120, w * 0.310, h * 0.135)
      // Left deltoid cap
      ..quadraticBezierTo(w * 0.255, h * 0.130, w * 0.235, h * 0.155)
      // Left upper arm outer
      ..quadraticBezierTo(w * 0.220, h * 0.185, w * 0.215, h * 0.210)
      ..quadraticBezierTo(w * 0.200, h * 0.250, w * 0.190, h * 0.285)
      // Left elbow
      ..quadraticBezierTo(w * 0.180, h * 0.310, w * 0.175, h * 0.325)
      // Left forearm outer
      ..quadraticBezierTo(w * 0.155, h * 0.370, w * 0.135, h * 0.410)
      // Left wrist
      ..quadraticBezierTo(w * 0.120, h * 0.440, w * 0.110, h * 0.455)
      // Left hand
      ..quadraticBezierTo(w * 0.090, h * 0.470, w * 0.085, h * 0.485)
      ..quadraticBezierTo(w * 0.080, h * 0.500, w * 0.095, h * 0.505)
      // Left hand back up
      ..quadraticBezierTo(w * 0.110, h * 0.500, w * 0.120, h * 0.485)
      // Left forearm inner
      ..quadraticBezierTo(w * 0.140, h * 0.445, w * 0.155, h * 0.410)
      ..quadraticBezierTo(w * 0.175, h * 0.365, w * 0.195, h * 0.325)
      // Left inner elbow
      ..quadraticBezierTo(w * 0.205, h * 0.305, w * 0.215, h * 0.285)
      // Left upper arm inner
      ..quadraticBezierTo(w * 0.235, h * 0.240, w * 0.250, h * 0.205)
      ..quadraticBezierTo(w * 0.265, h * 0.175, w * 0.285, h * 0.160)
      // Left armpit into torso
      ..quadraticBezierTo(w * 0.310, h * 0.165, w * 0.330, h * 0.185)
      // Left torso (chest → waist → hip)
      ..quadraticBezierTo(w * 0.340, h * 0.250, w * 0.345, h * 0.310)
      ..quadraticBezierTo(w * 0.340, h * 0.360, w * 0.350, h * 0.390)
      ..quadraticBezierTo(w * 0.365, h * 0.420, w * 0.375, h * 0.440)
      // Left hip
      ..quadraticBezierTo(w * 0.385, h * 0.460, w * 0.390, h * 0.475)
      // Left inner thigh
      ..quadraticBezierTo(w * 0.415, h * 0.510, w * 0.435, h * 0.530)
      ..quadraticBezierTo(w * 0.455, h * 0.555, w * 0.470, h * 0.570)
      // Crotch
      ..quadraticBezierTo(w * 0.490, h * 0.585, w * 0.500, h * 0.580)
      ..quadraticBezierTo(w * 0.510, h * 0.585, w * 0.530, h * 0.570)
      // Right inner thigh
      ..quadraticBezierTo(w * 0.545, h * 0.555, w * 0.565, h * 0.530)
      ..quadraticBezierTo(w * 0.585, h * 0.510, w * 0.610, h * 0.475)
      // Right hip
      ..quadraticBezierTo(w * 0.615, h * 0.460, w * 0.625, h * 0.440)
      ..quadraticBezierTo(w * 0.635, h * 0.420, w * 0.650, h * 0.390)
      ..quadraticBezierTo(w * 0.660, h * 0.360, w * 0.655, h * 0.310)
      // Right torso
      ..quadraticBezierTo(w * 0.660, h * 0.250, w * 0.670, h * 0.185)
      // Right armpit
      ..quadraticBezierTo(w * 0.690, h * 0.165, w * 0.715, h * 0.160)
      // Right upper arm inner
      ..quadraticBezierTo(w * 0.735, h * 0.175, w * 0.750, h * 0.205)
      ..quadraticBezierTo(w * 0.765, h * 0.240, w * 0.785, h * 0.285)
      // Right inner elbow
      ..quadraticBezierTo(w * 0.795, h * 0.305, w * 0.805, h * 0.325)
      // Right forearm inner
      ..quadraticBezierTo(w * 0.825, h * 0.365, w * 0.845, h * 0.410)
      ..quadraticBezierTo(w * 0.860, h * 0.445, w * 0.880, h * 0.485)
      // Right hand
      ..quadraticBezierTo(w * 0.890, h * 0.500, w * 0.905, h * 0.505)
      ..quadraticBezierTo(w * 0.920, h * 0.500, w * 0.915, h * 0.485)
      ..quadraticBezierTo(w * 0.910, h * 0.470, w * 0.890, h * 0.455)
      // Right wrist
      ..quadraticBezierTo(w * 0.880, h * 0.440, w * 0.865, h * 0.410)
      // Right forearm outer
      ..quadraticBezierTo(w * 0.845, h * 0.370, w * 0.825, h * 0.325)
      // Right elbow
      ..quadraticBezierTo(w * 0.820, h * 0.310, w * 0.810, h * 0.285)
      // Right upper arm outer
      ..quadraticBezierTo(w * 0.800, h * 0.250, w * 0.785, h * 0.210)
      ..quadraticBezierTo(w * 0.780, h * 0.185, w * 0.765, h * 0.155)
      // Right deltoid cap
      ..quadraticBezierTo(w * 0.745, h * 0.130, w * 0.690, h * 0.135)
      // Right shoulder slope
      ..quadraticBezierTo(w * 0.630, h * 0.120, w * 0.570, h * 0.115)
      // Right neck
      ..quadraticBezierTo(w * 0.565, h * 0.105, w * 0.560, h * 0.090)
      ..close();
    path.addPath(body, Offset.zero);

    // Left leg (separate path)
    final leftLeg = Path()
      ..moveTo(w * 0.390, h * 0.475)
      // Outer thigh
      ..quadraticBezierTo(w * 0.365, h * 0.530, w * 0.355, h * 0.580)
      ..quadraticBezierTo(w * 0.345, h * 0.630, w * 0.340, h * 0.670)
      // Outer knee
      ..quadraticBezierTo(w * 0.338, h * 0.700, w * 0.340, h * 0.720)
      // Outer shin
      ..quadraticBezierTo(w * 0.342, h * 0.760, w * 0.348, h * 0.800)
      // Ankle
      ..quadraticBezierTo(w * 0.350, h * 0.840, w * 0.360, h * 0.860)
      // Foot bottom
      ..quadraticBezierTo(w * 0.350, h * 0.880, w * 0.345, h * 0.895)
      ..quadraticBezierTo(w * 0.340, h * 0.910, w * 0.365, h * 0.915)
      ..lineTo(w * 0.430, h * 0.915)
      ..quadraticBezierTo(w * 0.455, h * 0.910, w * 0.450, h * 0.895)
      ..quadraticBezierTo(w * 0.445, h * 0.880, w * 0.440, h * 0.860)
      // Inner ankle
      ..quadraticBezierTo(w * 0.445, h * 0.840, w * 0.448, h * 0.800)
      // Inner shin
      ..quadraticBezierTo(w * 0.452, h * 0.760, w * 0.455, h * 0.720)
      // Inner knee
      ..quadraticBezierTo(w * 0.458, h * 0.700, w * 0.460, h * 0.670)
      // Inner thigh
      ..quadraticBezierTo(w * 0.462, h * 0.630, w * 0.465, h * 0.580)
      ..quadraticBezierTo(w * 0.468, h * 0.545, w * 0.470, h * 0.520)
      ..close();
    path.addPath(leftLeg, Offset.zero);

    // Right leg (mirrored)
    final rightLeg = Path()
      ..moveTo(w * 0.610, h * 0.475)
      // Inner thigh
      ..quadraticBezierTo(w * 0.532, h * 0.545, w * 0.535, h * 0.580)
      ..quadraticBezierTo(w * 0.538, h * 0.630, w * 0.540, h * 0.670)
      // Inner knee
      ..quadraticBezierTo(w * 0.542, h * 0.700, w * 0.545, h * 0.720)
      // Inner shin
      ..quadraticBezierTo(w * 0.548, h * 0.760, w * 0.552, h * 0.800)
      // Inner ankle
      ..quadraticBezierTo(w * 0.555, h * 0.840, w * 0.560, h * 0.860)
      // Foot
      ..quadraticBezierTo(w * 0.555, h * 0.880, w * 0.550, h * 0.895)
      ..quadraticBezierTo(w * 0.545, h * 0.910, w * 0.570, h * 0.915)
      ..lineTo(w * 0.635, h * 0.915)
      ..quadraticBezierTo(w * 0.660, h * 0.910, w * 0.655, h * 0.895)
      ..quadraticBezierTo(w * 0.650, h * 0.880, w * 0.640, h * 0.860)
      // Outer ankle
      ..quadraticBezierTo(w * 0.650, h * 0.840, w * 0.652, h * 0.800)
      // Outer shin
      ..quadraticBezierTo(w * 0.658, h * 0.760, w * 0.660, h * 0.720)
      // Outer knee
      ..quadraticBezierTo(w * 0.662, h * 0.700, w * 0.660, h * 0.670)
      // Outer thigh
      ..quadraticBezierTo(w * 0.655, h * 0.630, w * 0.645, h * 0.580)
      ..quadraticBezierTo(w * 0.635, h * 0.530, w * 0.610, h * 0.475)
      ..close();
    path.addPath(rightLeg, Offset.zero);

    return path;
  }

  // ──────────────────────────────────────────────
  // ANTERIOR MUSCLE GROUPS
  // ──────────────────────────────────────────────

  static Map<MuscleGroupId, Path> getAnteriorPaths(Size s) => {
    MuscleGroupId.neckFront: _neckFront(s),
    MuscleGroupId.chest: _chest(s),
    MuscleGroupId.shouldersFront: _shouldersFront(s),
    MuscleGroupId.biceps: _biceps(s),
    MuscleGroupId.forearmsFront: _forearmsFront(s),
    MuscleGroupId.handsFront: _handsFront(s),
    MuscleGroupId.abdominals: _abdominals(s),
    MuscleGroupId.quadriceps: _quadriceps(s),
    MuscleGroupId.adductors: _adductors(s),
    MuscleGroupId.shinsFront: _shinsFront(s),
    MuscleGroupId.feetFront: _feetFront(s),
  };

  // ── Neck (anterior) ──
  static Path _neckFront(Size s) {
    final w = s.width, h = s.height;
    return Path()
      ..moveTo(w * 0.440, h * 0.090)
      ..quadraticBezierTo(w * 0.445, h * 0.098, w * 0.450, h * 0.108)
      ..quadraticBezierTo(w * 0.470, h * 0.115, w * 0.500, h * 0.118)
      ..quadraticBezierTo(w * 0.530, h * 0.115, w * 0.550, h * 0.108)
      ..quadraticBezierTo(w * 0.555, h * 0.098, w * 0.560, h * 0.090)
      ..quadraticBezierTo(w * 0.530, h * 0.088, w * 0.500, h * 0.087)
      ..quadraticBezierTo(w * 0.470, h * 0.088, w * 0.440, h * 0.090)
      ..close();
  }

  // ── Chest / Pectorals ──
  static Path _chest(Size s) {
    final w = s.width, h = s.height;
    final path = Path();
    // Left pec
    path
      ..moveTo(w * 0.340, h * 0.170)
      ..quadraticBezierTo(w * 0.380, h * 0.155, w * 0.430, h * 0.152)
      ..quadraticBezierTo(w * 0.465, h * 0.150, w * 0.490, h * 0.155)
      ..quadraticBezierTo(w * 0.490, h * 0.190, w * 0.485, h * 0.220)
      ..quadraticBezierTo(w * 0.450, h * 0.240, w * 0.400, h * 0.238)
      ..quadraticBezierTo(w * 0.360, h * 0.235, w * 0.340, h * 0.220)
      ..close();
    // Right pec
    path
      ..moveTo(w * 0.660, h * 0.170)
      ..quadraticBezierTo(w * 0.620, h * 0.155, w * 0.570, h * 0.152)
      ..quadraticBezierTo(w * 0.535, h * 0.150, w * 0.510, h * 0.155)
      ..quadraticBezierTo(w * 0.510, h * 0.190, w * 0.515, h * 0.220)
      ..quadraticBezierTo(w * 0.550, h * 0.240, w * 0.600, h * 0.238)
      ..quadraticBezierTo(w * 0.640, h * 0.235, w * 0.660, h * 0.220)
      ..close();
    return path;
  }

  // ── Shoulders anterior ──
  static Path _shouldersFront(Size s) {
    final w = s.width, h = s.height;
    final path = Path();
    // Left deltoid
    path
      ..moveTo(w * 0.310, h * 0.135)
      ..quadraticBezierTo(w * 0.270, h * 0.132, w * 0.245, h * 0.148)
      ..quadraticBezierTo(w * 0.230, h * 0.165, w * 0.230, h * 0.185)
      ..quadraticBezierTo(w * 0.255, h * 0.185, w * 0.280, h * 0.170)
      ..quadraticBezierTo(w * 0.310, h * 0.165, w * 0.330, h * 0.170)
      ..quadraticBezierTo(w * 0.325, h * 0.150, w * 0.310, h * 0.135)
      ..close();
    // Right deltoid
    path
      ..moveTo(w * 0.690, h * 0.135)
      ..quadraticBezierTo(w * 0.730, h * 0.132, w * 0.755, h * 0.148)
      ..quadraticBezierTo(w * 0.770, h * 0.165, w * 0.770, h * 0.185)
      ..quadraticBezierTo(w * 0.745, h * 0.185, w * 0.720, h * 0.170)
      ..quadraticBezierTo(w * 0.690, h * 0.165, w * 0.670, h * 0.170)
      ..quadraticBezierTo(w * 0.675, h * 0.150, w * 0.690, h * 0.135)
      ..close();
    return path;
  }

  // ── Biceps ──
  static Path _biceps(Size s) {
    final w = s.width, h = s.height;
    final path = Path();
    // Left bicep
    path
      ..moveTo(w * 0.245, h * 0.192)
      ..quadraticBezierTo(w * 0.260, h * 0.188, w * 0.275, h * 0.192)
      ..quadraticBezierTo(w * 0.265, h * 0.230, w * 0.250, h * 0.265)
      ..quadraticBezierTo(w * 0.240, h * 0.290, w * 0.230, h * 0.300)
      ..quadraticBezierTo(w * 0.215, h * 0.295, w * 0.205, h * 0.280)
      ..quadraticBezierTo(w * 0.215, h * 0.245, w * 0.230, h * 0.215)
      ..close();
    // Right bicep
    path
      ..moveTo(w * 0.755, h * 0.192)
      ..quadraticBezierTo(w * 0.740, h * 0.188, w * 0.725, h * 0.192)
      ..quadraticBezierTo(w * 0.735, h * 0.230, w * 0.750, h * 0.265)
      ..quadraticBezierTo(w * 0.760, h * 0.290, w * 0.770, h * 0.300)
      ..quadraticBezierTo(w * 0.785, h * 0.295, w * 0.795, h * 0.280)
      ..quadraticBezierTo(w * 0.785, h * 0.245, w * 0.770, h * 0.215)
      ..close();
    return path;
  }

  // ── Forearms anterior ──
  static Path _forearmsFront(Size s) {
    final w = s.width, h = s.height;
    final path = Path();
    // Left forearm
    path
      ..moveTo(w * 0.200, h * 0.305)
      ..quadraticBezierTo(w * 0.215, h * 0.310, w * 0.225, h * 0.310)
      ..quadraticBezierTo(w * 0.205, h * 0.360, w * 0.180, h * 0.400)
      ..quadraticBezierTo(w * 0.165, h * 0.425, w * 0.150, h * 0.440)
      ..quadraticBezierTo(w * 0.140, h * 0.435, w * 0.135, h * 0.425)
      ..quadraticBezierTo(w * 0.155, h * 0.385, w * 0.175, h * 0.345)
      ..close();
    // Right forearm
    path
      ..moveTo(w * 0.800, h * 0.305)
      ..quadraticBezierTo(w * 0.785, h * 0.310, w * 0.775, h * 0.310)
      ..quadraticBezierTo(w * 0.795, h * 0.360, w * 0.820, h * 0.400)
      ..quadraticBezierTo(w * 0.835, h * 0.425, w * 0.850, h * 0.440)
      ..quadraticBezierTo(w * 0.860, h * 0.435, w * 0.865, h * 0.425)
      ..quadraticBezierTo(w * 0.845, h * 0.385, w * 0.825, h * 0.345)
      ..close();
    return path;
  }

  // ── Hands anterior ──
  static Path _handsFront(Size s) {
    final w = s.width, h = s.height;
    final path = Path();
    path.addOval(Rect.fromCenter(
      center: Offset(w * 0.098, h * 0.480),
      width: w * 0.055, height: h * 0.038,
    ));
    path.addOval(Rect.fromCenter(
      center: Offset(w * 0.902, h * 0.480),
      width: w * 0.055, height: h * 0.038,
    ));
    return path;
  }

  // ── Abdominals ──
  static Path _abdominals(Size s) {
    final w = s.width, h = s.height;
    return Path()
      ..moveTo(w * 0.410, h * 0.240)
      ..quadraticBezierTo(w * 0.450, h * 0.235, w * 0.500, h * 0.233)
      ..quadraticBezierTo(w * 0.550, h * 0.235, w * 0.590, h * 0.240)
      ..quadraticBezierTo(w * 0.595, h * 0.300, w * 0.590, h * 0.350)
      ..quadraticBezierTo(w * 0.580, h * 0.395, w * 0.560, h * 0.420)
      ..quadraticBezierTo(w * 0.530, h * 0.440, w * 0.500, h * 0.445)
      ..quadraticBezierTo(w * 0.470, h * 0.440, w * 0.440, h * 0.420)
      ..quadraticBezierTo(w * 0.420, h * 0.395, w * 0.410, h * 0.350)
      ..quadraticBezierTo(w * 0.405, h * 0.300, w * 0.410, h * 0.240)
      ..close();
  }

  // ── Quadriceps ──
  static Path _quadriceps(Size s) {
    final w = s.width, h = s.height;
    final path = Path();
    // Left quad
    path
      ..moveTo(w * 0.370, h * 0.470)
      ..quadraticBezierTo(w * 0.395, h * 0.465, w * 0.430, h * 0.475)
      ..quadraticBezierTo(w * 0.440, h * 0.530, w * 0.445, h * 0.580)
      ..quadraticBezierTo(w * 0.448, h * 0.620, w * 0.445, h * 0.660)
      ..quadraticBezierTo(w * 0.420, h * 0.675, w * 0.400, h * 0.670)
      ..quadraticBezierTo(w * 0.375, h * 0.665, w * 0.355, h * 0.650)
      ..quadraticBezierTo(w * 0.350, h * 0.610, w * 0.352, h * 0.560)
      ..quadraticBezierTo(w * 0.355, h * 0.515, w * 0.370, h * 0.470)
      ..close();
    // Right quad
    path
      ..moveTo(w * 0.630, h * 0.470)
      ..quadraticBezierTo(w * 0.605, h * 0.465, w * 0.570, h * 0.475)
      ..quadraticBezierTo(w * 0.560, h * 0.530, w * 0.555, h * 0.580)
      ..quadraticBezierTo(w * 0.552, h * 0.620, w * 0.555, h * 0.660)
      ..quadraticBezierTo(w * 0.580, h * 0.675, w * 0.600, h * 0.670)
      ..quadraticBezierTo(w * 0.625, h * 0.665, w * 0.645, h * 0.650)
      ..quadraticBezierTo(w * 0.650, h * 0.610, w * 0.648, h * 0.560)
      ..quadraticBezierTo(w * 0.645, h * 0.515, w * 0.630, h * 0.470)
      ..close();
    return path;
  }

  // ── Adductors (inner thigh) ──
  static Path _adductors(Size s) {
    final w = s.width, h = s.height;
    return Path()
      ..moveTo(w * 0.435, h * 0.480)
      ..quadraticBezierTo(w * 0.465, h * 0.475, w * 0.500, h * 0.478)
      ..quadraticBezierTo(w * 0.535, h * 0.475, w * 0.565, h * 0.480)
      ..quadraticBezierTo(w * 0.545, h * 0.530, w * 0.530, h * 0.565)
      ..quadraticBezierTo(w * 0.515, h * 0.575, w * 0.500, h * 0.578)
      ..quadraticBezierTo(w * 0.485, h * 0.575, w * 0.470, h * 0.565)
      ..quadraticBezierTo(w * 0.455, h * 0.530, w * 0.435, h * 0.480)
      ..close();
  }

  // ── Shins / Tibialis anterior ──
  static Path _shinsFront(Size s) {
    final w = s.width, h = s.height;
    final path = Path();
    // Left shin
    path
      ..moveTo(w * 0.348, h * 0.690)
      ..quadraticBezierTo(w * 0.375, h * 0.685, w * 0.440, h * 0.690)
      ..quadraticBezierTo(w * 0.445, h * 0.740, w * 0.448, h * 0.790)
      ..quadraticBezierTo(w * 0.445, h * 0.825, w * 0.435, h * 0.845)
      ..quadraticBezierTo(w * 0.405, h * 0.850, w * 0.380, h * 0.845)
      ..quadraticBezierTo(w * 0.355, h * 0.835, w * 0.348, h * 0.800)
      ..quadraticBezierTo(w * 0.345, h * 0.750, w * 0.348, h * 0.690)
      ..close();
    // Right shin
    path
      ..moveTo(w * 0.652, h * 0.690)
      ..quadraticBezierTo(w * 0.625, h * 0.685, w * 0.560, h * 0.690)
      ..quadraticBezierTo(w * 0.555, h * 0.740, w * 0.552, h * 0.790)
      ..quadraticBezierTo(w * 0.555, h * 0.825, w * 0.565, h * 0.845)
      ..quadraticBezierTo(w * 0.595, h * 0.850, w * 0.620, h * 0.845)
      ..quadraticBezierTo(w * 0.645, h * 0.835, w * 0.652, h * 0.800)
      ..quadraticBezierTo(w * 0.655, h * 0.750, w * 0.652, h * 0.690)
      ..close();
    return path;
  }

  // ── Feet anterior ──
  static Path _feetFront(Size s) {
    final w = s.width, h = s.height;
    final path = Path();
    // Left foot
    path
      ..moveTo(w * 0.360, h * 0.865)
      ..quadraticBezierTo(w * 0.350, h * 0.885, w * 0.350, h * 0.900)
      ..quadraticBezierTo(w * 0.355, h * 0.912, w * 0.385, h * 0.912)
      ..lineTo(w * 0.425, h * 0.912)
      ..quadraticBezierTo(w * 0.448, h * 0.910, w * 0.445, h * 0.895)
      ..quadraticBezierTo(w * 0.442, h * 0.878, w * 0.435, h * 0.865)
      ..close();
    // Right foot
    path
      ..moveTo(w * 0.640, h * 0.865)
      ..quadraticBezierTo(w * 0.650, h * 0.885, w * 0.650, h * 0.900)
      ..quadraticBezierTo(w * 0.645, h * 0.912, w * 0.615, h * 0.912)
      ..lineTo(w * 0.575, h * 0.912)
      ..quadraticBezierTo(w * 0.552, h * 0.910, w * 0.555, h * 0.895)
      ..quadraticBezierTo(w * 0.558, h * 0.878, w * 0.565, h * 0.865)
      ..close();
    return path;
  }

  // ──────────────────────────────────────────────
  // POSTERIOR MUSCLE GROUPS
  // ──────────────────────────────────────────────

  static Map<MuscleGroupId, Path> getPosteriorPaths(Size s) => {
    MuscleGroupId.neckBack: _neckBack(s),
    MuscleGroupId.trapezius: _trapezius(s),
    MuscleGroupId.shouldersBack: _shouldersBack(s),
    MuscleGroupId.triceps: _triceps(s),
    MuscleGroupId.forearmsBack: _forearmsBack(s),
    MuscleGroupId.handsBack: _handsBack(s),
    MuscleGroupId.lowerBack: _lowerBack(s),
    MuscleGroupId.glutes: _glutes(s),
    MuscleGroupId.hamstrings: _hamstrings(s),
    MuscleGroupId.calves: _calves(s),
    MuscleGroupId.feetBack: _feetBack(s),
  };

  // ── Neck (posterior) ──
  static Path _neckBack(Size s) => _neckFront(s);

  // ── Trapezius ──
  static Path _trapezius(Size s) {
    final w = s.width, h = s.height;
    return Path()
      ..moveTo(w * 0.370, h * 0.125)
      ..quadraticBezierTo(w * 0.420, h * 0.120, w * 0.450, h * 0.118)
      ..quadraticBezierTo(w * 0.475, h * 0.130, w * 0.500, h * 0.145)
      ..quadraticBezierTo(w * 0.525, h * 0.130, w * 0.550, h * 0.118)
      ..quadraticBezierTo(w * 0.580, h * 0.120, w * 0.630, h * 0.125)
      ..quadraticBezierTo(w * 0.640, h * 0.155, w * 0.635, h * 0.185)
      ..quadraticBezierTo(w * 0.600, h * 0.210, w * 0.560, h * 0.220)
      ..quadraticBezierTo(w * 0.530, h * 0.225, w * 0.500, h * 0.228)
      ..quadraticBezierTo(w * 0.470, h * 0.225, w * 0.440, h * 0.220)
      ..quadraticBezierTo(w * 0.400, h * 0.210, w * 0.365, h * 0.185)
      ..quadraticBezierTo(w * 0.360, h * 0.155, w * 0.370, h * 0.125)
      ..close();
  }

  // ── Shoulders posterior ──
  static Path _shouldersBack(Size s) => _shouldersFront(s);

  // ── Triceps ──
  static Path _triceps(Size s) => _biceps(s);

  // ── Forearms posterior ──
  static Path _forearmsBack(Size s) => _forearmsFront(s);

  // ── Hands posterior ──
  static Path _handsBack(Size s) => _handsFront(s);

  // ── Lower back / Lumbar ──
  static Path _lowerBack(Size s) {
    final w = s.width, h = s.height;
    return Path()
      ..moveTo(w * 0.410, h * 0.240)
      ..quadraticBezierTo(w * 0.450, h * 0.235, w * 0.500, h * 0.233)
      ..quadraticBezierTo(w * 0.550, h * 0.235, w * 0.590, h * 0.240)
      ..quadraticBezierTo(w * 0.585, h * 0.300, w * 0.575, h * 0.350)
      ..quadraticBezierTo(w * 0.560, h * 0.390, w * 0.535, h * 0.410)
      ..quadraticBezierTo(w * 0.515, h * 0.420, w * 0.500, h * 0.422)
      ..quadraticBezierTo(w * 0.485, h * 0.420, w * 0.465, h * 0.410)
      ..quadraticBezierTo(w * 0.440, h * 0.390, w * 0.425, h * 0.350)
      ..quadraticBezierTo(w * 0.415, h * 0.300, w * 0.410, h * 0.240)
      ..close();
  }

  // ── Glutes ──
  static Path _glutes(Size s) {
    final w = s.width, h = s.height;
    final path = Path();
    // Left glute
    path
      ..moveTo(w * 0.380, h * 0.425)
      ..quadraticBezierTo(w * 0.420, h * 0.418, w * 0.470, h * 0.425)
      ..quadraticBezierTo(w * 0.485, h * 0.425, w * 0.495, h * 0.430)
      ..quadraticBezierTo(w * 0.495, h * 0.465, w * 0.480, h * 0.490)
      ..quadraticBezierTo(w * 0.460, h * 0.505, w * 0.430, h * 0.500)
      ..quadraticBezierTo(w * 0.400, h * 0.495, w * 0.380, h * 0.478)
      ..quadraticBezierTo(w * 0.370, h * 0.455, w * 0.380, h * 0.425)
      ..close();
    // Right glute
    path
      ..moveTo(w * 0.620, h * 0.425)
      ..quadraticBezierTo(w * 0.580, h * 0.418, w * 0.530, h * 0.425)
      ..quadraticBezierTo(w * 0.515, h * 0.425, w * 0.505, h * 0.430)
      ..quadraticBezierTo(w * 0.505, h * 0.465, w * 0.520, h * 0.490)
      ..quadraticBezierTo(w * 0.540, h * 0.505, w * 0.570, h * 0.500)
      ..quadraticBezierTo(w * 0.600, h * 0.495, w * 0.620, h * 0.478)
      ..quadraticBezierTo(w * 0.630, h * 0.455, w * 0.620, h * 0.425)
      ..close();
    return path;
  }

  // ── Hamstrings ──
  static Path _hamstrings(Size s) {
    final w = s.width, h = s.height;
    final path = Path();
    // Left hamstring
    path
      ..moveTo(w * 0.370, h * 0.500)
      ..quadraticBezierTo(w * 0.395, h * 0.505, w * 0.435, h * 0.510)
      ..quadraticBezierTo(w * 0.445, h * 0.560, w * 0.450, h * 0.610)
      ..quadraticBezierTo(w * 0.448, h * 0.650, w * 0.445, h * 0.675)
      ..quadraticBezierTo(w * 0.415, h * 0.680, w * 0.395, h * 0.672)
      ..quadraticBezierTo(w * 0.365, h * 0.660, w * 0.352, h * 0.640)
      ..quadraticBezierTo(w * 0.348, h * 0.595, w * 0.355, h * 0.550)
      ..quadraticBezierTo(w * 0.360, h * 0.520, w * 0.370, h * 0.500)
      ..close();
    // Right hamstring
    path
      ..moveTo(w * 0.630, h * 0.500)
      ..quadraticBezierTo(w * 0.605, h * 0.505, w * 0.565, h * 0.510)
      ..quadraticBezierTo(w * 0.555, h * 0.560, w * 0.550, h * 0.610)
      ..quadraticBezierTo(w * 0.552, h * 0.650, w * 0.555, h * 0.675)
      ..quadraticBezierTo(w * 0.585, h * 0.680, w * 0.605, h * 0.672)
      ..quadraticBezierTo(w * 0.635, h * 0.660, w * 0.648, h * 0.640)
      ..quadraticBezierTo(w * 0.652, h * 0.595, w * 0.645, h * 0.550)
      ..quadraticBezierTo(w * 0.640, h * 0.520, w * 0.630, h * 0.500)
      ..close();
    return path;
  }

  // ── Calves ──
  static Path _calves(Size s) => _shinsFront(s);

  // ── Feet posterior ──
  static Path _feetBack(Size s) => _feetFront(s);
}
