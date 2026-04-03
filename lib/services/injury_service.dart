import 'package:korpomap/config/supabase_config.dart';
import 'package:korpomap/models/injury.dart';
import 'package:korpomap/models/muscle_group.dart';

/// Handles CRUD operations for injuries in Supabase.
class InjuryService {
  final _table = SupabaseConfig.client.from('injuries');

  /// Returns all injuries for a patient, newest first.
  Future<List<Injury>> getByPatient(String patientId) async {
    final data = await _table
        .select()
        .eq('patient_id', patientId)
        .order('injury_date', ascending: false);

    return data.map((json) => Injury.fromJson(json)).toList();
  }

  /// Returns injuries for a specific muscle group of a patient.
  Future<List<Injury>> getByMuscleGroup(
    String patientId,
    MuscleGroupId groupId,
  ) async {
    final data = await _table
        .select()
        .eq('patient_id', patientId)
        .eq('muscle_group', groupId.name)
        .order('injury_date', ascending: false);

    return data.map((json) => Injury.fromJson(json)).toList();
  }

  /// Inserts a new injury and returns it.
  Future<Injury> create(Map<String, dynamic> values) async {
    final data = await _table.insert(values).select().single();

    return Injury.fromJson(data);
  }

  /// Updates an injury by id and returns the updated record.
  Future<Injury> update(String id, Map<String, dynamic> values) async {
    final data = await _table.update(values).eq('id', id).select().single();

    return Injury.fromJson(data);
  }

  /// Deletes an injury by id.
  Future<void> delete(String id) async {
    await _table.delete().eq('id', id);
  }
}
