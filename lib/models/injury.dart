import 'package:korpomap/models/muscle_group.dart';

/// Represents an injury record linked to a patient and muscle group.
class Injury {
  final String id;
  final String patientId;
  final MuscleGroupId muscleGroup;
  final String? muscle;
  final String? description;
  final String severity;
  final String status;
  final DateTime injuryDate;
  final DateTime createdAt;

  Injury({
    required this.id,
    required this.patientId,
    required this.muscleGroup,
    this.muscle,
    this.description,
    required this.severity,
    required this.status,
    required this.injuryDate,
    required this.createdAt,
  });

  bool get isActive => status == 'active';

  factory Injury.fromJson(Map<String, dynamic> json) {
    return Injury(
      id: json['id'] as String,
      patientId: json['patient_id'] as String,
      muscleGroup: MuscleGroupId.values.byName(json['muscle_group'] as String),
      muscle: json['muscle'] as String?,
      description: json['description'] as String?,
      severity: json['severity'] as String,
      status: json['status'] as String,
      injuryDate: DateTime.parse(json['injury_date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patient_id': patientId,
      'muscle_group': muscleGroup.name,
      'muscle': muscle,
      'description': description,
      'severity': severity,
      'status': status,
      'injury_date': injuryDate.toIso8601String().split('T').first,
    };
  }
}
