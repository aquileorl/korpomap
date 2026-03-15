import 'package:korpomap/config/supabase_config.dart';
import 'package:korpomap/models/patient.dart';

///Handles CRUD operations for patients in Supabase
class PatientService {

  final _table = SupabaseConfig.client.from('patients');

  ///Returns all patients for the current user, newest first
  Future<List<Patient>> getAll() async {
    final data = await _table.select().order('created_at', ascending: false);

    return data.map((json) => Patient.fromJson(json)).toList();
  }

  ///Inserts a new patient and returns it
  Future<Patient> create(Map<String, dynamic> values) async {
    final data = await _table.insert(values).select().single();

    return Patient.fromJson(data);
  }

  ///Updates a patient by id and returns the updated record
  Future<Patient> update(String id, Map<String, dynamic> values) async {
    final data = await _table.update(values).eq('id',id).select().single();

    return Patient.fromJson(data);
  }

  ///Deletes a patient by id
  Future<void> delete(String id) async {
    await _table.delete().eq('id', id);
  }

}