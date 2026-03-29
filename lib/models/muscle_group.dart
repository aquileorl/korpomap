/// Represents the two sides of the body map
enum BodySide { anterior, posterior }

/// All muscle group identifiers in the body map
enum MuscleGroupId {
  // Anterior
  neckFront,
  chest,
  obliques,
  abdominals,
  shouldersFront,
  biceps,
  triceps,
  forearmsFront,
  handsFront,
  adductors,
  quadriceps,
  knees,
  shinsFront,
  calvesFront,
  anklesFront,
  feetFront,

  // Posterior
  neckBack,
  trapezius,
  shouldersBack,
  upperBack,
  tricepsBack,
  lowerBack,
  forearmsBack,
  handsBack,
  glutes,
  adductorsBack,
  hamstrings,
  calves,
  anklesBack,
  feetBack,
}

/// Data class representing a muscle group with its metadata
class MuscleGroup {
  final MuscleGroupId id;
  final String label;
  final BodySide side;
  final List<String> muscles;

  const MuscleGroup({
    required this.id,
    required this.label,
    required this.side,
    required this.muscles,
  });

  /// All muscle groups indexed by their ID
  static const Map<MuscleGroupId, MuscleGroup> all = {
    // ── Anterior ──────────────────────────────────────────────
    MuscleGroupId.neckFront: MuscleGroup(
      id: MuscleGroupId.neckFront,
      label: 'Cuello',
      side: BodySide.anterior,
      muscles: ['Frontal', 'Esternocleidomastoideo', 'Masetero'],
    ),
    MuscleGroupId.chest: MuscleGroup(
      id: MuscleGroupId.chest,
      label: 'Pectoral',
      side: BodySide.anterior,
      muscles: ['Pectoral mayor', 'Pectoral menor', 'Serrato'],
    ),
    MuscleGroupId.obliques: MuscleGroup(
      id: MuscleGroupId.obliques,
      label: 'Oblicuo externo',
      side: BodySide.anterior,
      muscles: ['Oblicuo externo'],
    ),
    MuscleGroupId.abdominals: MuscleGroup(
      id: MuscleGroupId.abdominals,
      label: 'Abdomen',
      side: BodySide.anterior,
      muscles: ['Abdomen'],
    ),
    MuscleGroupId.shouldersFront: MuscleGroup(
      id: MuscleGroupId.shouldersFront,
      label: 'Hombro',
      side: BodySide.anterior,
      muscles: ['Trapecio', 'Deltoides'],
    ),
    MuscleGroupId.biceps: MuscleGroup(
      id: MuscleGroupId.biceps,
      label: 'Bíceps',
      side: BodySide.anterior,
      muscles: ['Bíceps', 'Braquial'],
    ),
    MuscleGroupId.triceps: MuscleGroup(
      id: MuscleGroupId.triceps,
      label: 'Tríceps',
      side: BodySide.anterior,
      muscles: ['Tríceps'],
    ),
    MuscleGroupId.forearmsFront: MuscleGroup(
      id: MuscleGroupId.forearmsFront,
      label: 'Antebrazo',
      side: BodySide.anterior,
      muscles: ['Braquiorradial', 'Pronador redondo', 'Flexor radial del carpo'],
    ),
    MuscleGroupId.handsFront: MuscleGroup(
      id: MuscleGroupId.handsFront,
      label: 'Mano y muñeca',
      side: BodySide.anterior,
      muscles: ['Mano y muñeca'],
    ),
    MuscleGroupId.adductors: MuscleGroup(
      id: MuscleGroupId.adductors,
      label: 'Aductores',
      side: BodySide.anterior,
      muscles: ['Iliopsoas', 'Aductor'],
    ),
    MuscleGroupId.quadriceps: MuscleGroup(
      id: MuscleGroupId.quadriceps,
      label: 'Cuádriceps',
      side: BodySide.anterior,
      muscles: ['Sartorio', 'Recto femoral', 'Vasto lateral', 'Vasto interno'],
    ),
    MuscleGroupId.knees: MuscleGroup(
      id: MuscleGroupId.knees,
      label: 'Rodilla',
      side: BodySide.anterior,
      muscles: ['Rodilla'],
    ),
    MuscleGroupId.shinsFront: MuscleGroup(
      id: MuscleGroupId.shinsFront,
      label: 'Tibial anterior',
      side: BodySide.anterior,
      muscles: ['Tibial anterior', 'Peroneo largo'],
    ),
    MuscleGroupId.calvesFront: MuscleGroup(
      id: MuscleGroupId.calvesFront,
      label: 'Sóleo y gemelo',
      side: BodySide.anterior,
      muscles: ['Sóleo', 'Gemelo'],
    ),
    MuscleGroupId.anklesFront: MuscleGroup(
      id: MuscleGroupId.anklesFront,
      label: 'Tobillo',
      side: BodySide.anterior,
      muscles: ['Tobillo'],
    ),
    MuscleGroupId.feetFront: MuscleGroup(
      id: MuscleGroupId.feetFront,
      label: 'Pie',
      side: BodySide.anterior,
      muscles: ['Extensor corto de los dedos'],
    ),

    // ── Posterior ─────────────────────────────────────────────
    MuscleGroupId.neckBack: MuscleGroup(
      id: MuscleGroupId.neckBack,
      label: 'Cuello',
      side: BodySide.posterior,
      muscles: ['Occipitofrontal', 'Esplenio', 'Cervical'],
    ),
    MuscleGroupId.trapezius: MuscleGroup(
      id: MuscleGroupId.trapezius,
      label: 'Trapecio',
      side: BodySide.posterior,
      muscles: ['Trapecio', 'Elevador de la escápula', 'Romboides'],
    ),
    MuscleGroupId.shouldersBack: MuscleGroup(
      id: MuscleGroupId.shouldersBack,
      label: 'Hombro',
      side: BodySide.posterior,
      muscles: ['Supraespinoso', 'Infraespinoso', 'Redondo menor', 'Redondo mayor', 'Deltoides'],
    ),
    MuscleGroupId.upperBack: MuscleGroup(
      id: MuscleGroupId.upperBack,
      label: 'Dorsal',
      side: BodySide.posterior,
      muscles: ['Dorsal', 'Dorsal ancho'],
    ),
    MuscleGroupId.tricepsBack: MuscleGroup(
      id: MuscleGroupId.tricepsBack,
      label: 'Tríceps',
      side: BodySide.posterior,
      muscles: ['Tríceps'],
    ),
    MuscleGroupId.lowerBack: MuscleGroup(
      id: MuscleGroupId.lowerBack,
      label: 'Lumbar',
      side: BodySide.posterior,
      muscles: ['Lumbar'],
    ),
    MuscleGroupId.forearmsBack: MuscleGroup(
      id: MuscleGroupId.forearmsBack,
      label: 'Antebrazo',
      side: BodySide.posterior,
      muscles: ['Extensores del carpo', 'Flexor cubital'],
    ),
    MuscleGroupId.handsBack: MuscleGroup(
      id: MuscleGroupId.handsBack,
      label: 'Manos',
      side: BodySide.posterior,
      muscles: ['Manos'],
    ),
    MuscleGroupId.glutes: MuscleGroup(
      id: MuscleGroupId.glutes,
      label: 'Glúteos',
      side: BodySide.posterior,
      muscles: ['Glúteo medio', 'Glúteo mayor', 'Cadera'],
    ),
    MuscleGroupId.adductorsBack: MuscleGroup(
      id: MuscleGroupId.adductorsBack,
      label: 'Tensor fascia lata',
      side: BodySide.posterior,
      muscles: ['Tensor fascia lata'],
    ),
    MuscleGroupId.hamstrings: MuscleGroup(
      id: MuscleGroupId.hamstrings,
      label: 'Isquiotibiales',
      side: BodySide.posterior,
      muscles: ['Bíceps femoral', 'Semitendinoso', 'Semimembranoso'],
    ),
    MuscleGroupId.calves: MuscleGroup(
      id: MuscleGroupId.calves,
      label: 'Gemelo',
      side: BodySide.posterior,
      muscles: ['Gemelo', 'Tibial anterior', 'Peroneo largo'],
    ),
    MuscleGroupId.anklesBack: MuscleGroup(
      id: MuscleGroupId.anklesBack,
      label: 'Tendón de Aquiles',
      side: BodySide.posterior,
      muscles: ['Tendón de Aquiles'],
    ),
    MuscleGroupId.feetBack: MuscleGroup(
      id: MuscleGroupId.feetBack,
      label: 'Pies',
      side: BodySide.posterior,
      muscles: ['Pies'],
    ),
  };

  /// Returns all muscle groups for a given body side
  static List<MuscleGroup> bySide(BodySide side) {
    return all.values.where((g) => g.side == side).toList();
  }
}
